package test

import (
	"regexp"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformModuleTemplateExamples(t *testing.T) {
	t.Parallel()

	testMinimalExample(t, "../examples/minimal")
	testCompleteExample(t, "../examples/complete")
}

func testMinimalExample(t *testing.T, terraformDir string) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: terraformDir,
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	expectedOutput := terraform.Output(t, terraformOptions, "hello_world")
	// Very minimalistic test
	// TODO:
	// add more useful tests
	// examples:
	// get the awssdk and test some tags/resources ect.
	matched, err := regexp.MatchString(`^\d+$`, expectedOutput)
	assert.True(t, matched, "Expected created resource id in output", err)
}

func testCompleteExample(t *testing.T, terraformDir string) {
	// Construct the terraform options with default retryable errors to handle the most common
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// Set the path to the Terraform code that will be tested.
		TerraformDir: terraformDir,
	})

	// Clean up resources with "terraform destroy" at the end of the test.
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply". Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables and check they have the expected values.
	expectedOutput := terraform.Output(t, terraformOptions, "hello_world")
	// Very minimalistic test
	// TODO:
	// add more useful tests
	// examples:
	// get the awssdk and test some tags/resources ect.
	matched, err := regexp.MatchString(`^\d+$`, expectedOutput)
	assert.True(t, matched, "Expected created resource id in output", err)
}
