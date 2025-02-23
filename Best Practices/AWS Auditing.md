# AWS Audit

## **Overview**
AWS auditing ensures security, compliance, and operational efficiency by tracking user activity, resource changes, and security events.

## **Key AWS Audit Services**

### **1. AWS CloudTrail**  
- **Purpose**: Tracks API calls and user activity.
- **Use Cases**:
  - Investigate security incidents.
  - Monitor changes to AWS resources.
  - Detect unauthorized access.
- **Best Practices**:
  - Enable CloudTrail for all regions.
  - Store logs in an S3 bucket with encryption.
  - Integrate with AWS CloudWatch for real-time monitoring.

### **2. AWS Config**  
- **Purpose**: Tracks configuration changes and compliance.
- **Use Cases**:
  - Audit changes to AWS resources.
  - Ensure compliance with security standards.
  - Identify misconfigurations.
- **Best Practices**:
  - Enable AWS Config for all AWS accounts.
  - Use Config Rules for automated compliance checks.
  - Store configuration snapshots in S3.

### **3. AWS Security Hub**  
- **Purpose**: Centralized security and compliance management.
- **Use Cases**:
  - Aggregate findings from AWS security tools.
  - Automate security checks.
  - Monitor compliance frameworks (CIS, PCI DSS, etc.).
- **Best Practices**:
  - Enable Security Hub for all AWS accounts.
  - Integrate with AWS Config and CloudTrail.
  - Automate remediation using AWS Lambda.

### **4. Amazon GuardDuty**  
- **Purpose**: Detects threats and anomalies.
- **Use Cases**:
  - Identify compromised IAM credentials.
  - Detect unusual network traffic.
  - Monitor EC2 instances for suspicious behavior.
- **Best Practices**:
  - Enable GuardDuty in all AWS regions.
  - Automate response with AWS Lambda.
  - Regularly review and investigate alerts.

### **5. AWS IAM Access Analyzer**  
- **Purpose**: Identifies over-permissive access policies.
- **Use Cases**:
  - Detect unintended external access to AWS resources.
  - Audit IAM roles and permissions.
  - Reduce risk of privilege escalation.
- **Best Practices**:
  - Review findings regularly.
  - Restrict IAM policies following the principle of least privilege.
  - Use service control policies (SCPs) for governance.

## **Best Practices for AWS Auditing**
- **Enable multi-region CloudTrail logs.**
- **Use AWS Organizations for centralized security and compliance management.**
- **Regularly review IAM roles and policies.**
- **Automate compliance checks with AWS Config and Security Hub.**
- **Monitor logs using Amazon CloudWatch and AWS Lambda for real-time alerts.**
- **Store logs in an immutable S3 bucket with versioning and encryption.**

## **Common Use Cases**
| **Use Case** | **Service** |
|-------------|------------|
| Track user activity | AWS CloudTrail |
| Detect security threats | Amazon GuardDuty |
| Ensure compliance | AWS Security Hub, AWS Config |
| Audit IAM permissions | IAM Access Analyzer |
| Investigate resource changes | AWS Config, AWS CloudTrail |
| Monitor network security | VPC Flow Logs, Amazon GuardDuty |

---