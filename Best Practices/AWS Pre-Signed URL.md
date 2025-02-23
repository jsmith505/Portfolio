# **AWS Pre-Signed URL**  

## **Overview**  
A **Pre-Signed URL** in AWS allows temporary access to private objects in **Amazon S3** or enables limited-time API actions in **AWS services like API Gateway and CloudFront**. These URLs are signed with **temporary credentials** and expire after a set duration.

---

## **Key Use Cases**  

✅ **Grant temporary access to S3 objects** without modifying bucket policies.  
✅ **Enable secure file downloads/uploads** without exposing AWS credentials.  
✅ **Restrict access to API Gateway endpoints** with signed requests.  
✅ **Generate one-time, expiring links** for controlled file sharing.  
✅ **Use with CloudFront Signed URLs** for distributing private content globally.  

---

## **How Pre-Signed URLs Work**  

1. A user (or backend service) **generates a signed URL** using AWS SDKs or CLI.  
2. The URL contains **authentication details**, including a signature, expiration time, and permissions.  
3. The recipient **accesses the URL** within the allowed time frame.  
4. AWS verifies the signature and **grants or denies access** based on validity.  

---

## **Generating Pre-Signed URLs for S3**  

### **Using AWS CLI**
```sh
aws s3 presign s3://your-bucket-name/your-file.txt --expires-in 3600
```
*(Creates a URL valid for 1 hour.)*

### **Using AWS SDK (Python - Boto3)**
```python
import boto3
from botocore.exceptions import NoCredentialsError

s3_client = boto3.client('s3')

try:
    url = s3_client.generate_presigned_url(
        'get_object',
        Params={'Bucket': 'your-bucket-name', 'Key': 'your-file.txt'},
        ExpiresIn=3600  # 1 hour
    )
    print("Pre-Signed URL:", url)
except NoCredentialsError:
    print("AWS credentials not found.")
```

---

## **Pre-Signed URL Use Cases & Permissions**  

| **Use Case** | **S3 Permission Required** |
|-------------|----------------------------|
| Generate URL for file download | `s3:GetObject` |
| Generate URL for file upload | `s3:PutObject` |
| Generate URL for deleting a file | `s3:DeleteObject` |
| Generate URL for listing objects | `s3:ListBucket` |

**IAM Policy Example** *(Allow a user to generate Pre-Signed URLs for `get_object` and `put_object`)*
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::your-bucket-name/*"
    }
  ]
}
```

---

## **Expiration & Security Considerations**  

🔹 **Expiration Time** – Default is 15 minutes; can be set up to 7 days (depending on credentials).  
🔹 **Restrict Access** – Use IAM roles and bucket policies to limit Pre-Signed URL usage.  
🔹 **Limit Actions** – Pre-Signed URLs only allow the specific action (GET, PUT, DELETE).  
🔹 **Monitor Usage** – Use AWS CloudTrail and S3 Access Logs to track who accessed files.  
🔹 **Rotate URLs Frequently** – Avoid long-lived URLs; refresh URLs on every request if necessary.  

---

## **Alternatives to Pre-Signed URLs**  

| **Alternative** | **When to Use** |
|---------------|----------------|
| **S3 Signed Cookies** | If you need to grant multiple file access with a single signature. |
| **CloudFront Signed URLs** | If distributing private content over a CDN globally. |
| **IAM Role with Temporary Credentials** | If Pre-Signed URLs are too limiting and you need broader access control. |

---

## **Key Takeaways**  

✔ **Great for temporary access** to S3 objects without exposing credentials.  
✔ **Expires automatically**, ensuring short-lived, controlled access.  
✔ **Only grants limited permissions** (GET, PUT, DELETE) on specific objects.  
✔ **Use CloudTrail logs** to track Pre-Signed URL usage and prevent abuse.  
✔ **Restrict URL generation permissions** to trusted IAM roles and applications.  
