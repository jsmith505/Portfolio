# AD FS and self-signed certificate

## Overview
This guide walks through configuring **Active Directory Federation Services (AD FS)** with **AWS Identity and Access Management (IAM)** to enable **Active Directory users** and **groups** to access the **AWS Management Console** using **Security Assertion Markup Language (SAML)** for **federated single sign-on (SSO).**

## Objectives
By completing this setup, you will:
- Install and configure AD FS on a Windows Server.
- Enable federated access to the AWS Management Console using an existing Active Directory.
- Create and map IAM roles to federated users.
- Allow federated users to securely access AWS resources.

## Prerequisites
To follow this guide, you should be familiar with:
- Basic Windows Server administration.
- Federated identity concepts and identity providers (IdPs).
- **SAML, LDAP, Active Directory, and IAM.**

## Estimated Time
- **~60 minutes** (includes **10 minutes** for environment deployment).

## Icons and Their Meaning
- **🔷 Command:** A command you need to run.
- **✅ Expected Output:** Verify command results.
- **💡 Note:** Helpful tips or guidance.
- **✔ Task Complete:** Completion of a step.

## Starting the Lab
1. Click **Start Lab** at the top of the page.
   > ⚠ Wait for AWS services to be provisioned before continuing.
2. Click **Open Console** to sign in automatically.
   > ⚠ **Do not change the AWS Region** unless instructed.

## Common Sign-In Errors
**Error:** Clicking **Start Lab** does nothing.
- Disable any **popup or script blockers**.
- Refresh the page and try again.

## Lab Environment
This lab sets up:
- A **VPC** with an **Internet Gateway**, **public subnet**, and **private subnet**.
- A **NAT Gateway** for private subnet internet access.
- Two **EC2 instances**:
  - **Domain Controller** (DC) with **Active Directory (AD)**.
  - **AD FS Server** for federation.

## AD FS Federated Authentication Flow
1. User browses to AD FS sample site:
   ```
   https://Fully.Qualified.Domain.Name.Here/adfs/ls/IdpInitiatedSignOn.aspx
   ```
2. **AD FS authenticates** against Active Directory.
3. Browser receives a **SAML assertion**.
4. Browser sends **SAML assertion** to AWS sign-in:
   ```
   https://signin.aws.amazon.com/saml
   ```
5. User is **redirected** to the AWS Management Console.

---

# Tasks

## Task 1: Create Active Directory Groups and Users

### 1.1 Connect to the Domain Controller
1. Open **AWS Systems Manager** → **Fleet Manager**.
2. Select **DC Node** → Click **Node Actions → Connect → Connect with Remote Desktop**.
3. Use:
   - **Username:** `administrator`
   - **Password:** *(Copy from AWS Console)*
4. Click **Connect**.

### 1.2 Create a Group for Read-Only EC2 Access
1. Open **Active Directory Users and Computers**.
2. Right-click **mydomain.local** → **New → Group**.
3. Set:
   - **Group Name:** `AWS-View-EC2`
4. Click **OK**.
5. Right-click **AWS-View-EC2** → **Properties → Members → Add**.
6. Enter `Administrator` → **Check Names** → **OK** → **OK**.

### 1.3 Create a Group for Read-Only S3 Access
1. Repeat **Steps 1-6** but use:
   - **Group Name:** `AWS-View-S3`

### 1.4 Create an AD FS Service Account User
1. Right-click **mydomain.local** → **New → User**.
2. Set:
   - **First Name:** `ADFSSVC`
   - **User Logon Name:** `ADFSSVC`
3. Click **Next**.
4. Uncheck **User must change password at next logon**.
5. Set **Password**: `Mypa$$word123`
6. Click **Next → Finish**.

✅ **Task Complete:** AD Groups and users created.

---

## Task 2: Join the AD FS Instance to the Domain

### 2.1 Connect to the AD FS Instance
1. Open **Fleet Manager → Remote Desktop**.
2. Click **Add Connection → Select ADFS** → **Add**.
3. Use:
   - **Username:** `administrator`
   - **Password:** *(Copy from AWS Console)*
4. Click **Connect**.

✅ **Task Complete:** AD FS instance joined to the domain.

---

## Task 3: Configure AD FS for AWS SAML Authentication

### 3.1 Install AD FS Role
1. Open **Server Manager** on the AD FS server.
2. Click **Manage → Add Roles and Features**.
3. Select **Role-based or feature-based installation** → Click **Next**.
4. Select the AD FS server → Click **Next**.
5. Check **Active Directory Federation Services** → Click **Next**.
6. Click **Next → Next → Install**.
7. Once installed, click **Close**.

### 3.2 Configure AD FS
1. Open **Server Manager** → Click **Flag → Configure the federation service**.
2. Select **Create the first federation server in a federation farm** → Click **Next**.
3. Select the **ADFSSVC** account created earlier → Click **Next**.
4. Click **Next → Configure**.
5. Click **Close** when done.

✅ **Task Complete:** AD FS installed and configured.

---

## Additional Resources
- [AWS AD FS Integration Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers.html)
- [NICE DCV for Secure Remote Desktop](https://www.nice-dcv.com/)

---

# Task 3: Adding the Web Server Role and Creating a Self-Signed Certificate on AD FS

## Task 3.1: Connecting to the AD FS Instance
1. Wait 2 minutes for the AD FS instance to restart.
2. Reconnect to the AD FS instance with the following credentials:
   - **Username**: `mydomain\administrator`
   - **Password**: Use the `AdministratorPassword` value provided in the instructions.

## Task 3.2: Adding the Web Server Role
3. On the AD FS instance (IP address `10.0.0.15`), open **Server Manager**.
   - Note: It may take 10–15 seconds for Server Manager to load completely.
4. If a window appears saying *Try Windows Admin Center and Azure Arc today*, close it.
5. Select **Add roles and features**.
6. On the **Before You Begin** page, choose **Next**.
7. On the **Select Installation Type** page, choose **Next**.
8. On the **Select Destination Server** page, choose **Next**.
9. On the **Select Server Roles** page, select **Web Server (IIS)**.
10. In the pop-up window **Add features that are required for Web Server (IIS)?**, choose **Add Features**.
11. Choose **Next**.
12. On the **Select Features** page, choose **Next**.
13. On the **Web Server Role (IIS)** page, choose **Next**.
14. On the **Select Role Services** page, choose **Next**.
15. On the **Confirm Installation Selections** page, choose **Install**.
16. Wait for the installation to complete, then choose **Close**.

## Task 3.3: Creating a Self-Signed Certificate
17. In the **Server Manager** window, go to **Tools > Internet Information Services (IIS) Manager**.
18. In the navigation pane, select **ADFSSERVER**.
19. Open (double-click) **Server Certificates**.
   - Note: You may need to scroll down to find **Server Certificates**.
20. In the **Actions** pane, select **Create Self-Signed Certificate**.
21. In the **Create Self-Signed Certificate** window, configure:
   - **Friendly Name**: `adfs`
   - **Certificate Store**: `Web Hosting`
22. Choose **OK**.
23. In the **Server Certificates** list, right-click the `adfs` certificate and choose **Export**.
24. In the **Export Certificate** window, configure:
   - **Export to**: `C:\Users\administrator.mydomain\Desktop\adfs.pfx`
   - **Password**: `Mypa$$word123`
   - **Confirm Password**: `Mypa$$word123`
25. Choose **OK**.
26. Close the **Internet Information Services (IIS) Manager** window.

### Task Complete
You have successfully added the Web Server role to the AD FS server and created a self-signed certificate.