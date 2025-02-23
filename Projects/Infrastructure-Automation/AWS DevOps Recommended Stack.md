# **AWS DevOps Recommended Stack**  

## **Overview**  
AWS provides a comprehensive DevOps toolset for **continuous integration (CI), continuous deployment (CD), infrastructure as code (IaC), monitoring, security, and automation**. This cheat sheet outlines the recommended AWS DevOps stack, covering key services, use cases, and best practices.

---

## **1. CI/CD Pipeline**  

✅ **AWS CodePipeline** – Automates code builds, tests, and deployments.  
✅ **AWS CodeBuild** – Fully managed build service to compile and test code.  
✅ **AWS CodeDeploy** – Automates deployments to EC2, Lambda, and on-prem servers.  
✅ **AWS CodeCommit** – Managed Git repository service for version control.  
✅ **AWS CodeArtifact** – Securely stores and manages software packages.  

🔹 **Use Case**: Automate application releases with CodePipeline, integrating CodeCommit, CodeBuild, and CodeDeploy.  

**Example CI/CD Pipeline:**  
1. **CodeCommit** → Store source code  
2. **CodeBuild** → Compile, test, and package  
3. **CodeDeploy** → Deploy to EC2, ECS, Lambda  
4. **CloudWatch + SNS** → Monitor & notify on deployment status  

---

## **2. Infrastructure as Code (IaC)**  

✅ **AWS CloudFormation** – Automate infrastructure deployment using YAML/JSON.  
✅ **AWS CDK (Cloud Development Kit)** – Write IaC in TypeScript, Python, or Java.  
✅ **Terraform (3rd Party)** – HashiCorp tool for multi-cloud IaC.  
✅ **AWS Systems Manager** – Automates operational tasks and manages configurations.  

🔹 **Use Case**: Use **CloudFormation** to define and deploy AWS infrastructure as code.  

**Example:** Deploy an EC2 instance using CloudFormation:  
```yaml
Resources:
  MyEC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t3.micro
      ImageId: ami-12345678
```

---

## **3. Containerization & Orchestration**  

✅ **Amazon ECS (Elastic Container Service)** – Fully managed container orchestration.  
✅ **AWS Fargate** – Serverless compute engine for containers.  
✅ **Amazon EKS (Elastic Kubernetes Service)** – Managed Kubernetes service.  
✅ **Amazon Elastic Container Registry (ECR)** – Private Docker image repository.  

🔹 **Use Case**: Use **EKS** for Kubernetes-based applications, or **ECS/Fargate** for serverless container workloads.  

**Example:** Deploy a containerized app on ECS:  
```json
{
  "containerDefinitions": [
    {
      "name": "my-app",
      "image": "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-app:latest",
      "memory": 512,
      "cpu": 256
    }
  ]
}
```

---

## **4. Monitoring & Logging**  

✅ **Amazon CloudWatch** – Monitor logs, metrics, and set alarms.  
✅ **AWS CloudTrail** – Track API calls for security and compliance.  
✅ **AWS X-Ray** – Distributed tracing for debugging microservices.  
✅ **AWS Config** – Tracks configuration changes across AWS resources.  
✅ **Amazon OpenSearch (Elasticsearch)** – Log analysis & search.  
✅ **AWS Security Hub** – Centralized security and compliance management.  

🔹 **Use Case**: Use **CloudWatch Logs** to monitor application health and set up alarms based on log patterns.  

---

## **5. Security & Compliance**  

✅ **AWS IAM (Identity & Access Management)** – Manage permissions & roles.  
✅ **AWS KMS (Key Management Service)** – Encrypt data with managed keys.  
✅ **AWS Secrets Manager** – Securely store API keys and credentials.  
✅ **AWS Shield** – Protect against DDoS attacks.  
✅ **AWS WAF (Web Application Firewall)** – Blocks malicious traffic.  
✅ **AWS GuardDuty** – Threat detection & continuous security monitoring.  

🔹 **Use Case**: Use **IAM roles** instead of static credentials and **AWS Secrets Manager** for managing API keys securely.  

---

## **6. Serverless & Event-Driven Automation**  

✅ **AWS Lambda** – Run serverless functions in response to events.  
✅ **Amazon EventBridge** – Route events across AWS services.  
✅ **Amazon SQS (Simple Queue Service)** – Decouple microservices with message queues.  
✅ **Amazon SNS (Simple Notification Service)** – Publish notifications via SMS, email, or Lambda.  
✅ **AWS Step Functions** – Automate workflows with state machines.  

🔹 **Use Case**: Automate AWS infrastructure updates using **Lambda + CloudFormation**.  

**Example:** Trigger Lambda on S3 file upload:  
```json
{
  "detail-type": ["Object Created"],
  "source": ["aws.s3"],
  "resources": ["arn:aws:s3:::my-bucket"]
}
```

---

## **7. Cost Optimization & Governance**  

✅ **AWS Cost Explorer** – Analyze cost and usage trends.  
✅ **AWS Budgets** – Set and track budget limits.  
✅ **AWS Trusted Advisor** – Recommendations for cost, performance, and security.  
✅ **AWS Compute Optimizer** – Recommends instance types based on workload.  
✅ **AWS Savings Plans & Reserved Instances** – Reduce EC2 and Lambda costs.  

🔹 **Use Case**: Use **Cost Explorer** to track spending and **Compute Optimizer** to reduce underutilized instances.  

---

## **8. DevOps Best Practices**  

✔ **Use CI/CD Pipelines** – Automate testing and deployments.  
✔ **Adopt Infrastructure as Code (IaC)** – Version control your infrastructure.  
✔ **Implement Observability** – Use CloudWatch, X-Ray, and OpenSearch.  
✔ **Follow Security Best Practices** – Use IAM roles, encrypt data, and enable GuardDuty.  
✔ **Optimize Costs** – Monitor usage and rightsizing resources with Trusted Advisor.  
✔ **Leverage Serverless & Containers** – Reduce management overhead with Lambda, ECS, and Fargate.  

---

## **Conclusion**  

🔹 **AWS provides a full DevOps toolchain** for automating software development, deployment, and monitoring.  
🔹 **Use CI/CD tools like CodePipeline, CodeBuild, and CodeDeploy** to streamline releases.  
🔹 **Leverage IaC with CloudFormation or Terraform** for scalable and repeatable infrastructure.  
🔹 **Monitor logs, metrics, and security events** with CloudWatch, X-Ray, and GuardDuty.  
🔹 **Optimize costs and resources** with AWS Cost Explorer and Compute Optimizer.  
