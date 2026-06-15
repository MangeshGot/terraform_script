# Jenkins Agent on EKS

This project provisions the AWS networking and EKS resources needed to run Jenkins agents on Amazon EKS.

The Terraform code builds the EKS foundation in three stages:

1. A dedicated VPC with public and private subnets, an internet gateway, a NAT gateway, and route tables.
2. IAM roles for the EKS control plane and worker nodes.
3. An EKS cluster plus a managed node group that runs in the private subnets.

## Architecture Walkthrough

The layout is designed so the EKS control plane can be reached through the cluster endpoint, while worker nodes stay inside private subnets.

Key parts:

* The VPC is created with CIDR `192.168.0.0/24`.
* Two public subnets host the internet gateway path and the NAT gateway.
* Two private subnets host the EKS worker nodes.
* The cluster is configured with both public and private endpoint access.
* The node group uses on-demand instances and scales between 1 and 3 nodes.

## What Terraform Creates

### 1. VPC and Networking

The file [vpc_creation.tf](vpc_creation.tf) creates:

* the VPC
* two public subnets
* two private subnets
* the internet gateway
* the NAT gateway
* public and private route tables
* route table associations

This gives the EKS cluster the network path it needs for both public access and private outbound connectivity.

### 2. IAM Roles

The file [jenkins_agent_on_eks.tf](jenkins_agent_on_eks.tf) creates:

* an EKS control plane role with the `AmazonEKSClusterPolicy`
* a worker node role with the standard EKS worker, CNI, and ECR read-only policies

These roles allow AWS to manage the cluster and the worker nodes securely.

### 3. EKS Cluster and Node Group

The same file creates:

* the EKS cluster named `jenkins-eks-cluster`
* a managed node group named `jenkins-eks-node-group`
* outputs for the cluster endpoint and cluster name

The worker nodes are intended to run Jenkins-related workloads in the private subnets, keeping them off the public internet.

## Deployment Walkthrough

### 1. Configure Variables

Update [terraform.tfvars](terraform.tfvars) with your AWS credentials, region, and CIDR blocks.

Example values already provided in the file:

```hcl
aws_region = "us-east-1"
eks_vpc_cidr_block = "192.168.0.0/24"
```

### 2. Initialize Terraform

Run:

```bash
terraform init
```

This downloads the AWS provider and prepares the working directory.

### 3. Review the Plan

Run:

```bash
terraform plan
```

Check that Terraform will create the VPC, subnets, IAM roles, EKS cluster, and node group.

### 4. Create the Infrastructure

Run:

```bash
terraform apply
```

Confirm the apply when prompted. Terraform will provision the full EKS foundation.

### 5. Verify the Outputs

After the apply finishes, use the outputs to confirm the cluster name and endpoint:

```bash
terraform output
```

You should see:

* `eks_cluster_name`
* `eks_cluster_endpoint`

### 6. Connect Jenkins to EKS

Once the cluster exists, Jenkins can use the EKS worker nodes as the execution layer for agent workloads.

At a high level, the next Jenkins-side steps are:

* configure Jenkins credentials with access to the AWS account and EKS cluster
* connect Jenkins to the cluster using the Kubernetes integration or your preferred agent strategy
* point builds to run on the EKS-backed agent nodes

## Cleanup

When you no longer need the environment, remove all created resources:

```bash
terraform destroy
```

This prevents unnecessary AWS charges.

## Notes

* The node group is placed in private subnets for better isolation.
* The NAT gateway allows private nodes to reach external package repositories and AWS services.
* The cluster endpoint is enabled for both public and private access to simplify initial administration.

# Jenkins Installation on Minikube

If you deployed Jenkins on Minikube instead of EKS, use the following commands and notes.

## Execution Steps

1. Start Minikube:

```bash
minikube start
```

2. Switch kubectl to the Minikube cluster:

```bash
kubectl config use-context minikube
```

3. Add the Jenkins Helm repository:

```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

4. Install Jenkins into a namespace:

```bash
kubectl create namespace jenkins
helm install jenkins jenkins/jenkins -n jenkins -f jenkins-values.yaml
kubectl apply -f jenkins-deployment.yaml
kubectl apply -f jenkins-service.yaml
```

5. Verify the Jenkins pod and service:

```bash
kubectl get pods -n jenkins
kubectl get svc -n jenkins
```

6. Access Jenkins from your local machine:

```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

Then open:

```text
http://localhost:8080
```

You can also use Minikube directly:

```bash
minikube service jenkins -n jenkins --url
```

# Jenkins Installation on EKS
## Excutions Step
1. Run terraform apply. (This will take roughly 15 to 20 minutes as AWS provisions the underlying control plane).
2. Once Terraform completes successfully, link your local terminal to the new cluster so you can issue Kubernetes commands:

```bash
aws eks update-kubeconfig --region us-east-1 --name jenkins-eks-cluster
```
3. Verify your nodes are up and running safely in the private subnets:
```bash
kubectl get nodes
```
### Step 1: Install Helm Locally
If you don't have Helm installed on your local machine yet, run these commands in your terminal:
```bash
HELM_BUILDKITE_APT_KEY_ID="DDF78C3E6EBB2D2CC223C95C62BA89D07698DBC6"

sudo apt-get install curl gpg apt-transport-https --yes

curl -fsSL https://packages.buildkite.com/helm-linux/helm-debian/gpgkey > "${TMPDIR:-/tmp}/helm.gpg"

# Ensure that the key ID matches to prevent a repository compromise from establishing an attacker controlled key
if [ "$(gpg --show-keys --with-colons "${TMPDIR:-/tmp}/helm.gpg" | awk -F: '$1 == "fpr" {print $10}' | head -n 1)" != "${HELM_BUILDKITE_APT_KEY_ID}" ]; then echo "ERROR: Unexpected Helm APT key ID: potential key compromise"; exit 1; fi

cat "${TMPDIR:-/tmp}/helm.gpg" | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://packages.buildkite.com/helm-linux/helm-debian/any/ any main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update
sudo apt-get install helm
```
### Step 2: Add the Official Jenkins Helm Repository
Tell Helm where to find the official, secure Jenkins blueprints:
```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
```
### Step 3 : Extract default configuration
extracts the default configuration settings of the Jenkins Helm chart and saves them into a local file named jenkins-values.yaml

```bash
helm show values jenkins/jenkins > jenkins-values.yaml 
```
### Step 4 : Extract default configuration
open jenkins-values.yaml and set admin password by searching admin change blank text as "P0ssw0rd" 
```bash
  admin:
    # -- Admin username created as a secret if `controller.admin.createSecret` is true
    username: "admin"
    # -- Admin password created as a secret if `controller.admin.createSecret` is true
    # @default -- <random password>
    password:"P0ssw0rd"
```
### Step 5 : Expand StorageClass
run following "ALLOWVOLUMEEXPANSION" is true or not 
```bash
kubectl get sc
```
if its false run following command
```bash
kubectl patch storageclass gp2 -p '{"allowVolumeExpansion": true}'
```
