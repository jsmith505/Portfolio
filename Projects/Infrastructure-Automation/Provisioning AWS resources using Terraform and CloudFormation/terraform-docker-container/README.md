# Getting Started with Docker and Terraform

## Overview

In this tutorial, you will learn how to use **Terraform** to manage and automate **Docker** containers. You will create a Docker container on your local machine using Terraform configuration files. This tutorial demonstrates how to define and manage Docker resources such as containers, images, networks, and volumes using **Terraform**.

By the end of this tutorial, you will have the ability to define Docker containers and deploy them using Terraform, making your Docker environments more reproducible and automated.

## Prerequisites

Before starting this tutorial, make sure you have the following:

- **Terraform** installed. You can follow the installation instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).
- **Docker** installed and running on your local machine. Follow the installation instructions from [Docker's official site](https://docs.docker.com/get-docker/).
- Basic understanding of Docker and its components, such as containers, images, and networks.

## Steps

### Step 1: Install Terraform and Docker

1. Install **Terraform** by following the instructions on the [Terraform Downloads Page](https://www.terraform.io/downloads.html).
2. Install **Docker** by following the instructions on the [Docker Downloads Page](https://docs.docker.com/get-docker/).

### Step 2: Set Up Your Terraform Project

1. Create a new directory for your Terraform project:

    ```bash
    mkdir terraform-docker
    cd terraform-docker
    ```

2. Inside the directory, create a file called `main.tf` where you'll define your Docker resources.

### Step 3: Define the Docker Provider

In the `main.tf` file, specify the **Docker provider**. This tells Terraform to use Docker for managing containers and other resources.

```hcl
provider "docker" {
  host = "unix:///var/run/docker.sock"
}
