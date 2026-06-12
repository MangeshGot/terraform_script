# Secure Two-Tier Jenkins Architecture on AWS 🚀

This repository contains the Terraform infrastructure-as-code (IaC) to automatically provision a secure, highly decoupled Jenkins CI/CD environment on Amazon Web Services (AWS). 

Instead of running Jenkins on a single exposed server, this architecture separates the orchestration "brain" (Controller) from the execution "muscle" (Agent) using public and private subnets, ensuring that workload execution remains completely isolated from the open internet.

## 🏗️ Architecture Overview

![AWS Architecture Diagram](./architecture-diagram.png) *(Note: Add your PlantUML diagram to the repo and ensure the file name matches this link!)*

### Key Infrastructure Components:
* **Custom VPC (`192.168.0.0/24`):** A fully isolated network environment.
* **Public Subnet (DMZ):** Hosts the **Jenkins Controller**, which is accessible via the internet (Port 8080) for UI access and webhook triggers.
* **Private Subnet (Secure Zone):** Hosts the **Jenkins Agent**. It has no public IP address and cannot be accessed directly from the internet.
* **NAT Gateway:** Positioned in the public subnet to allow the private Jenkins Agent to securely pull down package updates (like Java/Git) and external dependencies without exposing itself to inbound internet traffic.
* **Strict Security Groups:** * Controller: Accepts inbound HTTP (8080) and SSH (22).
  * Agent: Accepts inbound SSH (22) **only** from the Controller's Security Group, plus internal ICMP for VPC-level network diagnostics.

## 🛠️ Prerequisites

Before you can deploy this infrastructure, you need the following installed on your local machine:
* [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.0.0+)
* [AWS CLI](https://aws.amazon.com/cli/) (Configured with an IAM user possessing necessary EC2/VPC permissions)
* An existing AWS EC2 Key Pair (e.g., `ketan`) generated in your deployment region.

> **🔒 Security Note:** Do not hardcode your AWS Access Keys in `terraform.tfvars`. This project is designed to pull credentials securely from your local AWS CLI configuration profile or dynamically via HashiCorp Vault.

## 🚀 Deployment Instructions

### 1. Initialize Terraform
Download the required AWS provider plugins:
```bash
terraform init