# Title

<description>

---

## What I built 

### 1. Created an invalid `main.tf` file 

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "ec2" {
  ami = 
  instance_type = 
}

```
The error in this case was that I did not provide any value for the ami and instance type arguements when configuring the aws_instance resource.

### 2. Created a workflow to lint the terraform code

Created a GitHub Actions workflow named `ci-test.yaml` inside the `.github/workflows` directory at the root of the repository. GitHub automatically detects workflow files placed in this directory and executes them when the configured trigger events occur.

```yaml
# Name of the GitHub Actions workflow
name: Run tests automatically on each push

# Trigger the workflow whenever code is pushed to the repository
on: [push]

# Define the jobs to be executed
jobs: 
  build:

    # Run the job on an Ubuntu virtual machine
    runs-on: ubuntu-latest

    # Define the steps to execute
    steps:

      # Step 1 - Download the repository source code
      - name: Checkout repository
        uses: actions/checkout@v6

      # Step 2 - Lint the Terraform code
      - name: Lint Terraform
        uses: actionshub/terraform-lint@main
  
```

This ensures Terraform code is automatically checked for potential errors, syntax issues and poor coding practices whenever changes are pushed to the repository.

### 3 . Successful Execution and Linting 

**GitHub Actions Workflow**

The GitHub Actions workflow executed successfully, completing all the configured steps without errors.

**Linting Terraform code**




---

## What I learnt 

1. 


---

## Issues I've solved



---






