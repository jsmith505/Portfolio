# AWS Storage

## Overview
AWS provides a variety of storage services designed to meet different use cases, including object storage, block storage, file storage, and archival solutions. This cheat sheet summarizes the key AWS storage services and their common use cases.

---

## 1. **Amazon S3 (Simple Storage Service)**
### **Type:** Object Storage
### **Use Cases:**
- Storing and retrieving any amount of data (images, videos, backups, logs)
- Static website hosting
- Big data analytics and data lakes
- Data archiving with lifecycle policies
- Media streaming and content distribution

### **Key Features:**
- Scalable, highly durable (99.999999999% durability)
- Various storage classes (Standard, IA, One Zone-IA, Glacier, Glacier Deep Archive)
- Object-level versioning, encryption, and access control

---

## 2. **Amazon EBS (Elastic Block Store)**
### **Type:** Block Storage
### **Use Cases:**
- Attachable storage for EC2 instances (like a hard drive)
- Running databases and transactional applications
- High-performance workloads requiring low-latency disk access

### **Key Features:**
- SSD (gp3, gp2, io1, io2) and HDD (st1, sc1) options
- Snapshots for backups and disaster recovery
- Encryption and high availability across Availability Zones

---

## 3. **Amazon EFS (Elastic File System)**
### **Type:** Managed File Storage (NFS)
### **Use Cases:**
- Shared storage for multiple EC2 instances
- Content management systems, web hosting
- Data analytics and machine learning workflows

### **Key Features:**
- Scalable, fully managed NFS file system
- Supports multiple EC2 instances simultaneously
- Performance and cost-optimized modes

---

## 4. **Amazon FSx**
### **Type:** Managed File Storage (Windows & Lustre)
### **Use Cases:**
- Windows-based applications needing SMB protocol support (FSx for Windows)
- High-performance computing and machine learning (FSx for Lustre)
- Enterprise workloads requiring native Windows file shares

### **Key Features:**
- Fully managed Windows file system with Active Directory integration
- High-speed Lustre storage for performance-intensive workloads
- Integration with S3 for data tiering

---

## 5. **AWS Storage Gateway**
### **Type:** Hybrid Storage
### **Use Cases:**
- Extending on-premises storage to AWS cloud
- Backup and disaster recovery
- File sharing between cloud and on-premises environments

### **Key Features:**
- File Gateway (NFS/SMB to S3)
- Volume Gateway (iSCSI-based block storage with snapshots to S3)
- Tape Gateway (virtual tape library for backups)

---

## 6. **Amazon S3 Glacier & Glacier Deep Archive**
### **Type:** Archival Storage
### **Use Cases:**
- Long-term data retention
- Regulatory compliance and archival
- Backup storage for infrequent access

### **Key Features:**
- Extremely low-cost storage
- Retrieval options: Expedited, Standard, and Bulk
- Lifecycle policies for automated data transitions

---

## 7. **AWS Backup**
### **Type:** Backup & Disaster Recovery
### **Use Cases:**
- Centralized backup management across AWS services
- Compliance-driven backup retention
- Automated backup schedules and policies

### **Key Features:**
- Supports EC2, EBS, RDS, DynamoDB, EFS, and FSx
- Incremental backups to save costs
- Policy-driven backup automation

---

## **Choosing the Right AWS Storage**
| **Use Case**                 | **Recommended Service** |
|------------------------------|------------------------|
| Object storage (scalable, unstructured data) | Amazon S3 |
| Block storage (EC2 volumes, databases) | Amazon EBS |
| Shared file storage (NFS) | Amazon EFS |
| Windows file system | Amazon FSx for Windows |
| High-performance file storage | Amazon FSx for Lustre |
| Hybrid storage (on-prem to cloud) | AWS Storage Gateway |
| Long-term archival | Amazon S3 Glacier |
| Centralized backups | AWS Backup |

---

## **Conclusion**
AWS provides multiple storage solutions tailored to different needs. When choosing a service, consider factors such as access patterns, latency requirements, and cost efficiency.

For more details, refer to [AWS Storage Services](https://aws.amazon.com/products/storage/).

