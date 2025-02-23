# AWS Audit Cheat Sheet

## IAM Audit
### Review User Permissions
1. Open **IAM** in the AWS Management Console.
2. Navigate to **Access management** > **Users**.
3. Select a user to view details.
4. Review the **Summary** and **Security credentials** tab:
   - **Access Keys**: Check creation date and active status.
   - **Signing Certificates**: Review certificates.
   - **Console Password**: Ensure strong password policies.
   - **MFA (Multi-Factor Authentication)**: Verify MFA setup.

### Run IAM Policy Simulator
1. Open the **IAM Policy Simulator**.
2. Select a user.
3. Choose **Identity and Access Management** service.
4. Select actions to test (e.g., `DeleteGroup`, `DeleteRolePolicy`).
5. Click **Run Simulation**.
6. Review the results:
   - **Implicitly Denied**: Indicates missing permissions.

## EC2 Security Audit
### Review Running Instances
1. Open **EC2** in the AWS Management Console.
2. Navigate to **Instances**.
3. Identify key instances (e.g., Web Server, Bastion Host, SQL Server).

### Review Security Groups
#### Web Server Security Group
1. Navigate to **Security Groups**.
2. Select `WebServerSG`.
3. Review **Inbound Rules**:
   - Allow: `80 (HTTP)`, `443 (HTTPS)`, `3389 (RDP - Bastion Only)`.
   - Ensure `3389` is restricted.

#### Bastion Host Security Group
1. Select `BastionSG`.
2. Review **Inbound & Outbound Rules**:
   - **Inbound**: Should allow access only from trusted IPs.
   - **Outbound**: Restrict unnecessary access.

#### SQL Server Security Group
1. Select `SQLSG`.
2. Review **Inbound Rules**:
   - Only allow traffic from specific security groups.
3. Review **Outbound Rules**:
   - Ensure restricted communication to necessary services.

## VPC Security Audit
### Review VPC Configurations
1. Open **VPC** in the AWS Management Console.
2. Navigate to **Your VPCs** and review the configurations.
3. Check **Subnets**:
   - Ensure proper segregation of public and private subnets.
4. Check **Network ACLs**:
   - Review inbound/outbound rules for restrictive access.

## CloudWatch Audit
### Review Performance Metrics
1. Open **CloudWatch** in the AWS Management Console.
2. Navigate to **Metrics** > **EC2**.
3. Review key metrics:
   - CPU Utilization
   - Disk I/O
   - Network Traffic

## CloudTrail Audit
### Review Raw Logs
1. Open **S3** in the AWS Management Console.
2. Navigate to the **CloudTrail** log bucket.
3. Inspect logs for unauthorized activity.
4. Use **Athena** or **CloudTrail Insights** for deeper analysis.

## Collecting Audit Evidence
- Capture IAM settings and Policy Simulator outputs.
- Document EC2 security group configurations.
- Maintain CloudWatch and CloudTrail logs for compliance reviews.

---
### Notes
- **MFA** should be enforced for all users.
- **IAM Policies** should follow the principle of **least privilege**.
- **Security Groups** should restrict access to necessary services only.
- **CloudTrail Logs** should be stored securely with access logging enabled.
- **CloudWatch Alerts** should be configured for critical metrics.

