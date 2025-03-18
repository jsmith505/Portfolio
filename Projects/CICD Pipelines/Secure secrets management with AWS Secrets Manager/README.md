# Secure Secrets Management with AWS Secrets Manager

## Overview

AWS Secrets Manager is a fully managed service that enables you to easily rotate, manage, and retrieve database credentials, API keys, and other secrets. With Secrets Manager, you can store, access, and manage sensitive information securely and efficiently within your AWS environment.

This guide will walk you through setting up AWS Secrets Manager to securely manage secrets like database credentials, API keys, and other sensitive information.

## Features

- **Secure Storage**: Store sensitive data like database passwords, API keys, and other secrets securely.
- **Automatic Rotation**: Automatically rotate secrets at regular intervals.
- **Audit Logging**: Integration with AWS CloudTrail to log access to secrets.
- **Access Control**: Use AWS Identity and Access Management (IAM) to control access to secrets.

## Prerequisites

- AWS Account
- IAM permissions to use AWS Secrets Manager and manage secrets
- AWS CLI or Management Console access

## Step 1: Create a Secret in AWS Secrets Manager

### Using the AWS Management Console:

1. Navigate to the **AWS Secrets Manager** service in the AWS Management Console.
2. Choose **Store a new secret**.
3. Select the type of secret you want to store (e.g., **Other type of secret** for custom secrets).
4. Enter the key-value pairs of your secret (e.g., for a database, use `username` and `password`).
5. Click **Next** and enter a **name** for your secret (e.g., `MyDatabaseCredentials`).
6. Set the **rotation** (optional). You can choose to rotate the secret every set number of days.
7. Review your configuration and click **Store**.

### Using the AWS CLI:

```bash
aws secretsmanager create-secret \
    --name MyDatabaseCredentials \
    --description "My database credentials" \
    --secret-string '{"username":"myuser","password":"mypassword"}'
