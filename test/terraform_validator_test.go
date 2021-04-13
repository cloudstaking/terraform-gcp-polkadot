package main

import (
	"fmt"
	"strings"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/gcp"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// TestValidatorWithPolkashots deploys a validator and enable polkashots
func TestValidatorWithPolkashots(t *testing.T) {
	t.Parallel()

	instanceName := fmt.Sprintf("validator-%s", strings.ToLower(random.UniqueId()))
	projectId := gcp.GetGoogleProjectIDFromEnvVar(t)

	keyPair := ssh.GenerateRSAKeyPair(t, 2048)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/simple-validator",
		EnvVars: map[string]string{
			"GOOGLE_CLOUD_PROJECT": projectId,
		},
		Vars: map[string]interface{}{
			"ssh_key":       keyPair.PublicKey,
			"instance_name": instanceName,
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	publicInstanceIP := terraform.Output(t, terraformOptions, "public_ip")
	httpUsername := terraform.Output(t, terraformOptions, "http_username")
	httpPassword := terraform.Output(t, terraformOptions, "http_password")

	publicHost := ssh.Host{
		Hostname:    publicInstanceIP,
		SshKeyPair:  keyPair,
		SshUserName: "ubuntu",
	}

	maxRetries := 30
	timeBetweenRetries := 120 * time.Second

	description := fmt.Sprintf("SSHing to validator %s to check if docker & docker-compose are installed", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkBinaries(t, publicHost, "host")
	})

	description = fmt.Sprintf("Checking if node_exporter is running in %s", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkNodeExporter(t, publicInstanceIP, httpUsername, httpPassword)
	})

	description = fmt.Sprintf("SSHing to validator (%s) to check if snapshot folder exist and >5GB", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkPolkadotSnapshot(t, publicHost)
	})

	description = fmt.Sprintf("SSHing to validator (%s) to check if application files exist", publicInstanceIP)
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		return checkAppFiles(t, publicHost, "host")
	})
}
