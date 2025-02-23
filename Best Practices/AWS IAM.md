# AWS IAM

## Overview
AWS Identity and Access Management (IAM) is a service that helps you securely control access to AWS resources. It enables authentication, authorization, and management of users, groups, roles, and policies.

## IAM Components

### 1. **Users**
- Represents an individual person or application needing access.
- Can have direct permissions or inherit them from groups.

### 2. **Groups**
- Collection of IAM users with shared permissions.
- Helps simplify management by assigning policies at the group level.

### 3. **Roles**
- Intended for AWS services, applications, or users needing temporary access.
- Assume roles via `sts:AssumeRole`.

### 4. **Policies**
- Defines permissions using JSON documents.
- Can be **AWS Managed**, **Customer Managed**, or **Inline**.

### 5. **Identity Providers (IdP)**
- Enables federated access via SAML, OpenID Connect, or AWS SSO.
- Useful for integrating with external authentication systems like Microsoft Entra ID (Azure AD).

### 6. **Access Keys**
- Used for programmatic access via AWS CLI or SDKs.
- Best practice: Use roles instead of access keys when possible.

### 7. **MFA (Multi-Factor Authentication)**
- Adds an extra layer of security by requiring a second authentication factor.

## IAM Best Practices
- **Follow the Principle of Least Privilege**: Grant only the minimum necessary permissions.
- **Use IAM Roles Instead of Access Keys**: Reduces risk from compromised credentials.
- **Enable MFA for Privileged Users**: Protects against unauthorized access.
- **Regularly Rotate Credentials**: Mitigates risks from leaked keys.
- **Monitor IAM Activities**: Use AWS CloudTrail for logging and auditing.
- **Use IAM Access Analyzer**: Identifies potential security risks and unused permissions.

## Common Use Cases
- **Granting Developers Read-Only Access**: Attach a read-only policy to a group for developers.
- **Granting an EC2 Instance S3 Access**: Assign an IAM role with an S3 policy to an EC2 instance.
- **Cross-Account Access**: Create a role in one AWS account that another account can assume.
- **Enforcing MFA for Admins**: Require MFA authentication for privileged IAM users.
- **Restricting Access Based on Conditions**: Use IAM policy conditions (e.g., allow access only from a specific IP range).

## Useful AWS-Managed Policies
- `AdministratorAccess`: Full access to all AWS resources.
- `PowerUserAccess`: Full access except for IAM & account settings.
- `ReadOnlyAccess`: Grants read-only permissions across AWS services.
- `AmazonS3FullAccess`: Full access to S3 buckets.
- `AWSLambdaBasicExecutionRole`: Allows logging to CloudWatch from Lambda.