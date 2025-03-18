# Provisioning AWS Resources using Terraform and CloudFormation

## Overview

In this tutorial, you will learn how to use **Terraform** and **AWS CloudFormation** to provision AWS resources in an automated and scalable manner. Terraform allows you to define infrastructure as code (IaC), while AWS CloudFormation provides native AWS support for provisioning resources. By combining these tools, you can ensure that your AWS infrastructure is reproducible and manageable.

This tutorial will guide you through the steps to set up AWS resources using both **Terraform** and **CloudFormation**, with an emphasis on best practices for IaC.

## Prerequisites

Before starting this tutorial, ensure you have the following:

- **Terraform** installed. You can follow the installation instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- **AWS CLI** installed and configured on your local machine. Follow the installation guide [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).
- An **AWS Account** and the necessary permissions to create and manage resources.
- Basic knowledge of **AWS resources** (EC2, S3, IAM) and how **CloudFormation** and **Terraform** work.

## Steps

### Step 1: Set Up Terraform Project

1. Create a new directory for your Terraform project:

    ```bash
    mkdir terraform-cloudformation
    cd terraform-cloudformation
    ```

2. Initialize a new Terraform project:

    ```bash
    terraform init
    ```

3. Create a `main.tf` file to define the infrastructure.

### Step 2: Define AWS Provider in Terraform

In the `main.tf` file, define the **AWS provider** to allow Terraform to interact with AWS.

```hcl
provider "aws" {
  region = "us-west-2"
}
