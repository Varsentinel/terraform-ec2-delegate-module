# Terraform AWS EC2 Infrastructure

A Terraform module for provisioning AWS infrastructure including VPC, subnet, internet gateway, route table, and EC2 instance.

## Overview

This module creates a basic AWS infrastructure setup with:
- VPC with custom CIDR block
- Public subnet
- Internet gateway
- Route table with internet access
- EC2 instance running Ubuntu 24.04 LTS

## Prerequisites

- Terraform >= 1.13
- AWS CLI configured with appropriate credentials
- AWS account with necessary permissions

## Resources Created

- `aws_vpc` - Virtual Private Cloud
- `aws_subnet` - Public subnet
- `aws_internet_gateway` - Internet gateway for public access
- `aws_route_table` - Route table with default route to internet gateway
- `aws_instance` - EC2 instance with Ubuntu AMI

## Usage

1. Clone the repository:
```bash
git clone <repository-url>
cd terraform-aws-ec2
```

2. Create a `.tfvars` file or use the provided `dev.tfvars`:
```bash
cp dev.tfvars terraform.tfvars
```

3. Initialize Terraform:
```bash
terraform init
```

4. Review the execution plan:
```bash
terraform plan -var-file="dev.tfvars"
```

5. Apply the configuration:
```bash
terraform apply -var-file="dev.tfvars"
```

## Variables

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `region` | string | AWS region to deploy resources | - |
| `instance_type` | string | EC2 instance type | - |
| `ami_name` | string | Name pattern for Ubuntu AMI | `ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*` |
| `name` | string | Name tag for the EC2 instance | - |
| `cidr_block` | string | VPC CIDR block | - |
| `subnet_cidr_block` | string | Public subnet CIDR block | - |
| `vpc_name` | string | Name tag for the VPC | - |

## Example Configuration

```hcl
region             = "ap-southeast-1"
instance_type      = "t3.micro"
cidr_block         = "172.16.0.0/16"
subnet_cidr_block  = "172.16.1.0/24"
vpc_name           = "my-vpc"
name               = "my-ec2-instance"
```

## Outputs
- VPC ID
- Subnet ID
- EC2 instance ID
- EC2 public IP

## License

See [LICENSE](LICENSE) file for details.