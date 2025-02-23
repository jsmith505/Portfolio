# Getting Started with AWS and Terraform

## Overview

This guide will walk you through the steps to provision infrastructure on AWS using **Terraform**, a powerful open-source infrastructure as code (IaC) tool. You will learn how to manage and automate the creation of AWS resources such as EC2 instances, security groups, and key pairs using Terraform scripts. The tutorial will guide you through the Terraform workflow, starting from setup and initialization to applying and managing infrastructure.

By the end of this tutorial, you will have the knowledge to manage your AWS resources using Terraform, providing repeatable, consistent, and version-controlled deployments.

## Prerequisites

Before starting this tutorial, make sure you have the following:

- **Terraform** installed. You can follow the installation instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- An **AWS account** with appropriate IAM permissions to create and manage resources (EC2, VPC, security groups).
- **AWS CLI** installed and configured with your AWS credentials. You can configure it using the command `aws configure`.

## Steps

### Step 1: Install Terraform

1. Download Terraform for your operating system from the [Terraform Downloads Page](https://www.terraform.io/downloads.html).
2. Follow the installation instructions to install Terraform.

### Step 2: Set Up Your AWS Account

1. Sign up for an AWS account if you don’t have one already.
2. Create an IAM user with **Programmatic Access** and **AdministratorAccess** to manage your resources.
3. Configure your AWS CLI using the `aws configure` command and enter the IAM user credentials.

### Step 3: Initialize a New Terraform Project

1. Create a new directory for your Terraform project:

    ```bash
    mkdir terraform-aws-ec2
    cd terraform-aws-ec2
    ```

2. Inside the directory, create a new file called `main.tf` where you'll define your AWS infrastructure.

### Step 4: Configure Your AWS Provider

In the `main.tf` file, start by defining the AWS provider to specify the region and credentials to be used by Terraform.

```hcl
provider "aws" {
  region = "us-west-2"
}
