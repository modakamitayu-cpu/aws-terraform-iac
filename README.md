# AWS Terraform Application Stack

This project provisions a modular AWS application stack for the supplied Terraform assignment.

## Architecture

- VPC spanning two Availability Zones
- Two public subnets for the Application Load Balancer and NAT Gateway
- Two private subnets for backend compute
- Internet Gateway for public subnet egress
- NAT Gateway so private EC2 instances can reach the internet without public IPs
- Application Load Balancer listening on HTTP/80
- Backend EC2 instance in a private subnet
- Backend Security Group allows HTTP only from the ALB Security Group
- SSM IAM role for administrative access without opening SSH
- Separate encrypted gp3 EBS data volume attached to the backend EC2 instance
- AWS Data Lifecycle Manager policy creates daily snapshots of the data volume
- Optional Auto Scaling Group across private subnets for the bonus requirement
- Separate dev/prod tfvars

## Folder Structure

```text
.
├── environments/
│   ├── dev.tfvars
│   └── prod.tfvars
├── modules/
│   ├── alb/
│   ├── backup/
│   ├── compute/
│   ├── network/
│   └── security/
├── locals.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── variables.tf
└── versions.tf
```

## Prerequisites

1. Terraform >= 1.6
2. AWS CLI installed and authenticated
3. AWS permissions to create VPC, EC2, EBS, ELBv2, Auto Scaling, IAM and DLM resources

Example authentication:

```bash
aws configure
aws sts get-caller-identity
```

## Deploy Dev

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan -var-file=environments/dev.tfvars
terraform apply -var-file=environments/dev.tfvars
```

After apply, open the `alb_dns_name` output in a browser.

## Deploy Prod

The provided prod tfvars enables the optional Auto Scaling Group.

```bash
terraform plan -var-file=environments/prod.tfvars
terraform apply -var-file=environments/prod.tfvars
```

## Destroy

```bash
terraform destroy -var-file=environments/dev.tfvars
```

or

```bash
terraform destroy -var-file=environments/prod.tfvars
```

## Secondary Disk Retention

The secondary disk is modeled as a standalone `aws_ebs_volume` and attached using `aws_volume_attachment`. Therefore, deleting or replacing the EC2 instance itself does not automatically delete the EBS volume.

A full `terraform destroy` intentionally destroys Terraform-managed resources, including the EBS volume. If the requirement is to preserve the volume even during a full Terraform destroy, add an operational retention process or temporarily remove the volume from Terraform state before destroy.

## Daily Snapshot Schedule

The data volume is tagged with `DLMBackup=<project>-<environment>-daily`. AWS Data Lifecycle Manager creates a snapshot every 24 hours at 03:00 UTC. Retention is controlled by `snapshot_retention_count`.

## Security Notes

- Backend EC2 has no public IP.
- Port 22 is not opened.
- Administration uses AWS Systems Manager Session Manager.
- Backend HTTP/80 is accepted only from the ALB Security Group.
- IMDSv2 is required.
- Root and data EBS volumes are encrypted.

## Environment Strategy

This sample uses separate tfvars files for `dev` and `prod`. In a real team setup, also use a remote backend such as S3 with state locking and separate state per environment/account.

## Bonus ASG Behavior

When `enable_asg = true`, Terraform creates a launch template and Auto Scaling Group across both private subnets and registers it with the same ALB target group. The standalone EC2 instance is retained to satisfy the base requirement for a backend VM with a separately attached retained data disk.

## Assumptions

- HTTP is used because the assignment explicitly asks for HTTP. Production applications should normally use HTTPS with ACM certificates.
- One NAT Gateway is used to keep the lab simple and cost-conscious. A production HA design would normally use one NAT Gateway per AZ.
- The ASG nodes are stateless; the retained secondary EBS data volume is attached only to the standalone backend instance.
