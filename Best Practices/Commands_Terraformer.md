# **Terraformer**  

## **Overview**  
Terraformer is a CLI tool that helps generate Terraform configuration and state files from existing cloud infrastructure. It enables infrastructure-as-code adoption by reverse-engineering deployed resources into Terraform files.  

🔹 **GitHub:** [GoogleCloudPlatform/terraformer](https://github.com/GoogleCloudPlatform/terraformer)  

---

## **1. Installation**  
### **Install Terraformer**  
- **Mac (Homebrew):**  
  ```sh
  brew install terraformer
  ```
- **Windows (Chocolatey):**  
  ```sh
  choco install terraformer
  ```
- **Linux:**  
  ```sh
  wget https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(latest_release)/terraformer-$(os)-amd64  
  chmod +x terraformer  
  mv terraformer /usr/local/bin/  
  ```

### **Verify Installation**  
```sh
terraformer --version
```

---

## **2. Supported Providers**  
Terraformer supports multiple cloud providers, including:  
✅ AWS  
✅ Azure  
✅ GCP  
✅ Kubernetes  
✅ GitHub  
✅ Cloudflare  

For the full list, run:  
```sh
terraformer providers
```

---

## **3. Basic Usage**  
### **1. Configure Credentials**  
Ensure your cloud provider credentials are set up:  
- **AWS:** `~/.aws/credentials`  
- **Azure:** `az login`  
- **GCP:** `gcloud auth application-default login`  

### **2. Generate Terraform Code for a Specific Service**  
```sh
terraformer import aws --resources=s3,ec2 --regions=us-east-1
```

### **3. Generate Terraform Code for All Resources in a Region**  
```sh
terraformer import aws --regions=us-east-1 --all
```

### **4. Specify an Output Directory**  
```sh
terraformer import aws --resources=ec2 --regions=us-east-1 --path-output=./generated
```

---

## **4. Terraformer Directory Structure**  
After running `terraformer import`, Terraformer generates the following structure:  
```
.
├── generated
│   ├── aws
│   │   ├── ec2
│   │   │   ├── instances.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   ├── terraform.tfstate
```
- `instances.tf` → Terraform configuration for imported resources  
- `variables.tf` → Automatically generated input variables  
- `outputs.tf` → Outputs for Terraform use  
- `terraform.tfstate` → Imported Terraform state  

---

## **5. Working with Imported Infrastructure**  
### **1. Initialize Terraform**  
```sh
cd generated/aws/ec2
terraform init
```

### **2. Plan the Imported Configuration**  
```sh
terraform plan
```

### **3. Apply Changes (if needed)**  
```sh
terraform apply
```

---

## **6. Import Multiple Services**  
To import multiple services at once:  
```sh
terraformer import aws --resources=vpc,subnet,security_group,ec2 --regions=us-east-1
```

To import **everything**:  
```sh
terraformer import aws --regions=us-east-1 --all
```

---

## **7. Filtering Resources**  
Use filters to refine the import process:  
```sh
terraformer import aws --resources=ec2 --regions=us-east-1 --filter="Name=instance-type;Value=t3.micro"
```
Filter by **multiple conditions**:  
```sh
terraformer import aws --resources=ec2 --regions=us-east-1 --filter="Name=tag:Environment;Value=prod"
```

---

## **8. Managing Terraform State**  
Since Terraformer generates Terraform state files, you can move them to remote storage (like S3) for better state management:  
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
Run:  
```sh
terraform init -migrate-state
```

---

## **9. Best Practices**  
✅ **Use Remote State:** Store generated `.tfstate` files in S3 or a backend  
✅ **Filter Resources:** Avoid unnecessary imports to keep Terraform clean  
✅ **Modularize Configuration:** Split resources into modules for better management  
✅ **Review Before Applying:** Always run `terraform plan` before `apply`  
✅ **Keep Terraformer Updated:** Providers and resources change frequently  

---

## **Conclusion**  
Terraformer simplifies the process of adopting Terraform by importing existing infrastructure into `.tf` files. It’s an excellent tool for migration, disaster recovery, and auditing cloud environments. 🚀