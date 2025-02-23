# AWS ADFS

## Overview
AWS ADFS (Active Directory Federation Services) enables Single Sign-On (SSO) by federating authentication from Microsoft Active Directory to AWS. It allows enterprises to leverage existing credentials for secure access to AWS services.

---

## Key Components

### **1. Active Directory (AD)**
- Centralized identity and authentication service.
- Stores user credentials and security policies.

### **2. ADFS Server**
- Acts as an identity provider (IdP).
- Authenticates users against AD and issues security tokens.
- Uses SAML (Security Assertion Markup Language) for authentication.

### **3. AWS IAM (Identity & Access Management)**
- Manages AWS access permissions.
- Uses IAM roles for federated access.

### **4. SAML (Security Assertion Markup Language)**
- Standard protocol for identity federation.
- Enables SSO between ADFS and AWS.

### **5. AWS STS (Security Token Service)**
- Issues temporary security credentials for federated users.
- Works with IAM roles to grant access.

---

## **Setup Steps**

### **1. Configure ADFS Server**
- Install ADFS on a Windows Server.
- Add a relying party trust for AWS.
- Configure claim rules to pass SAML attributes.

### **2. Create IAM Roles for Federated Access**
- Define IAM roles with appropriate permissions.
- Establish trust relationships with ADFS.

### **3. Configure SAML in AWS**
- Enable SAML-based authentication in AWS IAM.
- Upload ADFS metadata XML.

### **4. Test Authentication Flow**
- Log in to AWS via ADFS.
- Verify user authentication and role assumption.

---

## **Use Cases**

- **SSO for Enterprise Users:** Allows employees to use corporate AD credentials for AWS access.
- **Centralized Identity Management:** Simplifies user access control using existing AD policies.
- **Multi-Account Federation:** Enables secure access across multiple AWS accounts.
- **Temporary Credentials:** Enhances security by issuing short-lived AWS access tokens.

---

## **Common Issues & Troubleshooting**

| Issue | Possible Solution |
|--------|------------------|
| ADFS login fails | Check AD user group memberships and claim rules. |
| Access denied in AWS | Verify IAM role mappings and SAML assertions. |
| Metadata import error | Ensure ADFS metadata XML is correctly formatted. |
| Expired tokens | Adjust session duration in AWS IAM settings. |

---

## **Additional Resources**
- [AWS ADFS Integration Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_saml.html)
- [Microsoft ADFS Documentation](https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/)
- [AWS STS](https://docs.aws.amazon.com/STS/latest/APIReference/Welcome.html)

---
