# **Terraform**  

## **Overview**  
Terraform is an Infrastructure as Code (IaC) tool that allows you to define, provision, and manage cloud infrastructure declaratively.  

---

## **1. Installation & Setup**  
### **Install Terraform**  
- **Mac (Homebrew):**  
  ```sh
  brew install terraform
  ```
- **Windows (Chocolatey):**  
  ```sh
  choco install terraform
  ```
- **Linux (APT-based):**  
  ```sh
  sudo apt-get install terraform
  ```

### **Verify Installation**  
```sh
terraform version
```

---

## **2. Terraform Workflow**  
### **1. Write Configuration (`.tf` files)**  
Example:
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name"
  acl    = "private"
}
```

### **2. Initialize Terraform**  
```sh
terraform init
```

### **3. Plan Deployment**  
```sh
terraform plan
```

### **4. Apply Changes**  
```sh
terraform apply
```

### **5. Destroy Resources**  
```sh
terraform destroy
```

---

## **3. Essential Commands**  
| Command | Description |
|---------|-------------|
| `terraform init` | Initializes Terraform and downloads provider plugins |
| `terraform plan` | Shows what changes Terraform will make |
| `terraform apply` | Creates or updates resources |
| `terraform destroy` | Deletes all resources in the configuration |
| `terraform fmt` | Formats `.tf` files |
| `terraform validate` | Checks `.tf` syntax for errors |
| `terraform state list` | Lists all managed resources in the state file |
| `terraform state show <resource>` | Shows details of a specific resource |
| `terraform import <resource> <id>` | Imports existing infrastructure into Terraform |
| `terraform output` | Displays output variables |
| `terraform refresh` | Syncs state with real-world infrastructure |

---

## **4. Providers & Modules**  
### **Define a Provider (AWS Example)**  
```hcl
provider "aws" {
  region = "us-east-1"
}
```

### **Use Modules for Reusability**  
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.0"
  cidr = "10.0.0.0/16"
}
```

---

## **5. State Management**  
### **Use Remote State (AWS S3 Example)**
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
```

---

## **6. Variables & Outputs**  
### **Define Variables (`variables.tf`)**
```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

### **Use Variables in Configuration**
```hcl
resource "aws_instance" "my_instance" {
  instance_type = var.instance_type
}
```

### **Define Output Variables**
```hcl
output "instance_ip" {
  value = aws_instance.my_instance.public_ip
}
```

---

## **7. Conditional Logic & Loops**  
### **Use Conditionals**
```hcl
resource "aws_instance" "example" {
  instance_type = var.is_production ? "t3.large" : "t3.micro"
}
```

### **Use Loops (For Each)**
```hcl
resource "aws_s3_bucket" "buckets" {
  for_each = toset(["dev", "prod"])
  bucket   = "my-bucket-${each.value}"
}
```

---

## **8. Best Practices**  
✅ **Use Remote State** with S3 + DynamoDB locking  
✅ **Organize Code** into modules for reusability  
✅ **Use Version Control** (Git) for Terraform configurations  
✅ **Apply Least Privilege** when managing IAM permissions  
✅ **Regularly Review & Cleanup** unused resources  

---

## **Conclusion**  
Terraform is a powerful tool for managing cloud infrastructure declaratively. Follow best practices and use modules, remote state, and variables to make your configurations scalable and maintainable. 🚀