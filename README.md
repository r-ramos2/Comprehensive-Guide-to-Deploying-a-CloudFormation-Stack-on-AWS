# Comprehensive Guide to Deploying a CloudFormation Stack on AWS

## Table of Contents
1. [Overview](#overview)
2. [Benefits of Infrastructure as Code](#benefits-of-infrastructure-as-code)
3. [Prerequisites](#prerequisites)
4. [Deploying the Stack Using AWS CloudFormation](#deploying-the-stack-using-aws-cloudformation)
   - [Step-by-Step Instructions](#step-by-step-instructions)
   - [CloudFormation Template Reference](#cloudformation-template-reference)
5. [Automated Setup Using Terraform](#automated-setup-using-terraform)
   - [Terraform Configuration Reference](#terraform-configuration-reference)
6. [Manual Setup Using AWS CLI](#manual-setup-using-aws-cli)
7. [Monitoring and Management](#monitoring-and-management)
8. [Clean Up](#clean-up)
9. [Security Best Practices](#security-best-practices)
10. [Error Handling and Troubleshooting Tips](#error-handling-and-troubleshooting-tips)
11. [Conclusion](#conclusion)
12. [References](#references)
13. [Terraform File](#terraform-file)
14. [CloudFormation YAML File](#cloudformation-yaml-file)

---

## Overview
This guide provides three different ways to deploy a **LAMP stack (Linux, Apache, MySQL, PHP)** on **AWS**: using **AWS CloudFormation**, **Terraform**, and the **AWS CLI**. Each method will deploy the same infrastructure for consistency, ensuring you can manage the stack in a uniform way regardless of the deployment method.

<img width="738" alt="Screen Shot 2024-10-11 at 7 05 44 PM" src="https://github.com/user-attachments/assets/1c5b49f8-2d88-481f-84c4-a384274f468a">

*Architecture Diagram*

---

## Benefits of Infrastructure as Code
- **Consistency**: Allows for predictable and repeatable deployments.
- **Automation**: Simplifies the setup process and reduces manual errors.
- **Version Control**: Enables tracking and auditing changes to infrastructure.
- **Cost Management**: Easily estimate and control infrastructure costs.

---

## Prerequisites
- An **AWS account** with permissions for EC2, RDS, VPC, and CloudFormation services. Ensure the IAM user has the following permissions:
  - `cloudformation:*`
  - `ec2:*`
  - `rds:*`
  - `vpc:*`
- Basic knowledge of AWS services, especially EC2 and IAM.
- Existing **SSH key pair** for accessing the EC2 instances.
- **CloudFormation** or **Terraform** installed (for respective sections).
- Recommended region: **us-east-1** (adjust as necessary).

---

### Deploying the Stack Using AWS CloudFormation

**Step-by-Step Instructions:**

1. **Open AWS CloudFormation**: Open AWS CloudFormation in a separate tab.
2. **Create a Stack**: Click on **Create Stack**.
3. **Prepare Template**: Under **Prerequisite - prepare template**, choose **Use a sample template**.
4. **Select a Sample Template**: Choose a template under the **SIMPLE** category (e.g., LAMP Stack). Optionally click **View in designer** to see a preview, then click **Next**.
5. **Configure Stack Details**: Enter the following details:
   - **Stack name**: (e.g., My-LAMP-Stack-123456).
   - **DBName**: Desired database name.
   - **Password**: A strong password for your database.
   - **DBUser**: (e.g., "admin").
   - **Instance Type**: Select `t2.small` (or your preferred instance type).
   - **Key Name**: Choose an existing key pair for SSH access.
   - Click **Next**.
6. **Configure Stack Options**: Configure as needed or leave defaults, then click **Next**.
7. **Review and Create**: Review the details and click **Create stack**.
8. **Wait for Completion**: Monitor until the status is **CREATE_COMPLETE**.
9. **Access the Web Application**: In the **Outputs** tab, open the **Website URL** to view the LAMP application.

### CloudFormation Template Reference
The template `main.yaml` provisions an EC2 instance with a LAMP stack installed. See the full file contents in the **CloudFormation YAML File** section at the end of this guide.

---

## Automated Setup Using Terraform

### Terraform Configuration
1. **Install Terraform**: Ensure that Terraform is installed on your machine. Follow the [installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli) if needed.
2. **Download the Terraform Configuration File**: The Terraform configuration file `main.tf` provisions the same EC2 instance and LAMP stack as CloudFormation.
3. **Deploy with Terraform**:
   - Initialize Terraform by running:
     ```bash
     terraform init
     ```
   - Plan the deployment to preview changes:
     ```bash
     terraform plan
     ```
   - Apply the configuration to provision the resources:
     ```bash
     terraform apply
     ```
4. **Access Your Application**: After deployment, retrieve the public IP of the instance from Terraform’s output and open it in a browser to access the LAMP application.

---

## Manual Setup Using AWS CLI

### Instructions
1. **Launch EC2 Instance**: Use the following command to launch an EC2 instance with Amazon Linux 2:
   ```bash
   aws ec2 run-instances --image-id ami-0abcdef1234567890 --instance-type t2.small --key-name my-key --security-groups default
   ```
2. **Install LAMP Stack**:
   - SSH into your EC2 instance:
     ```bash
     ssh -i ~/.ssh/my-key.pem ec2-user@<public-ip>
     ```
   - Once connected, run these commands to install the LAMP stack:
     ```bash
     sudo yum update -y
     sudo yum install -y httpd mariadb-server php php-mysqlnd
     sudo systemctl start httpd
     sudo systemctl enable httpd
     sudo systemctl start mariadb
     sudo systemctl enable mariadb
     ```

---

## Monitoring and Management
- **Amazon CloudWatch**: Use CloudWatch to monitor CPU usage, disk I/O, and set up alarms.
- **AWS Systems Manager**: Manage EC2 instances remotely with Systems Manager for easier patching, automation, and auditing.
- **AWS Config**: Monitor resource configurations and changes for compliance and governance.

---

## Clean Up

### CloudFormation Stack
1. Navigate to CloudFormation, select the stack, and delete it.

### Terraform Resources
1. In the Terraform directory, run:
   ```bash
   terraform destroy
   ```

### AWS CLI Resources
1. Terminate the EC2 instance via CLI:
   ```bash
   aws ec2 terminate-instances --instance-ids <instance-id>
   ```

---

## Security Best Practices
- **IAM Permissions**: Assign the minimum required permissions to users and roles.
- **Security Groups**: Limit inbound traffic to trusted IP addresses for SSH and HTTP access.
- **Encryption**: Use SSL/TLS for web traffic and enable encryption for any RDS instances.
- **Regular Audits**: Perform regular security audits to ensure compliance with best practices.
- **Multi-Factor Authentication (MFA)**: Enable MFA for IAM users to enhance security.

---

## Error Handling and Troubleshooting Tips
- **CloudFormation Stack Fails**: Check the Events tab in the CloudFormation console for error messages indicating why the stack creation failed.
- **Cannot Access the Application**: Ensure that the security group allows inbound traffic on port 80 (HTTP) or 443 (HTTPS).
- **Database Connection Issues**: Verify the database endpoint and ensure that the RDS instance is publicly accessible if required.
- **Common Errors**:
  - **Timeouts**: If the stack creation times out, check for resource limits or configuration issues.
  - **Permission Denied**: Ensure the IAM user has the necessary permissions.

---

## Conclusion
This guide provides three methods to deploy a **LAMP stack** on **AWS**: CloudFormation, Terraform, and AWS CLI. Each approach is aligned to deploy the same stack, ensuring consistency across deployment strategies. Choose the one that best suits your workflow and requirements.

---

## References
1. [AWS CloudFormation Documentation](https://docs.aws.amazon.com/cloudformation/index.html)
2. [Terraform Documentation](https://www.terraform.io/docs/index.html)
3. [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/index.html)
4. [AWS CLI Documentation](https://docs.aws.amazon.com/cli/index.html)
5. [AWS Security Best Practices](https://docs.aws.amazon.com/general/latest/gr/aws-security-best-practices.html)
6. [AWS Systems Manager Documentation](https://docs.aws.amazon.com/systems-manager/index.html)
