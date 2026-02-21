terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Repo        = "aws-bedrock-ami-healer-ssm"
    }
  }
}

data "aws_caller_identity" "current" {}

# ─── SSM NAMESPACE PLACEHOLDER PARAMETERS ─────────────────────────────────────
# These document the SSM structure and serve as placeholders.
# Real values are written by the individual repos that own each parameter.
# Placeholders ensure the namespace exists and is documented.

resource "aws_ssm_parameter" "namespace_doc" {
  name  = "/${var.project_name}/_namespace"
  type  = "String"
  value = jsonencode({
    description = "SSM namespace for ami-healer cross-repo configuration",
    repos = {
      infra      = "params documented here, values written by infra pipeline after terraform apply",
      bedrock    = "writes /bedrock/* after terraform apply",
      lambda     = "writes /lambda/* after terraform apply",
      pipeline   = "writes /pipeline/* at runtime (Lambda execution)"
    }
  })
  description = "SSM namespace documentation"
  overwrite   = true
}

# ─── INFRA PIPELINE PARAMETERS ────────────────────────────────────────────────
# Bootstrapped here with placeholders.
# Real values written by infra pipeline after terraform apply.
# ignore_changes = [value] ensures terraform won't reset pipeline-managed values.

resource "aws_ssm_parameter" "infra_ami_id" {
  name        = "/${var.project_name}/infra/ami-id"
  type        = "String"
  value       = "placeholder"
  description = "Latest working AMI ID - written by AMI build pipeline after CVE scan"
  overwrite   = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "infra_asg_name" {
  name        = "/${var.project_name}/infra/asg-name"
  type        = "String"
  value       = "ami-healer-asg"
  description = "ASG name for ami-healer infra"
  overwrite   = true
}

resource "aws_ssm_parameter" "infra_launch_template_id" {
  name        = "/${var.project_name}/infra/launch-template-id"
  type        = "String"
  value       = "placeholder"
  description = "Launch template ID - written by infra pipeline after apply"
  overwrite   = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "infra_vpc_id" {
  name        = "/${var.project_name}/infra/vpc-id"
  type        = "String"
  value       = "placeholder"
  description = "VPC ID for ami-healer infra"
  overwrite   = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "infra_private_subnet_ids" {
  name        = "/${var.project_name}/infra/private-subnet-ids"
  type        = "StringList"
  value       = "placeholder"
  description = "Private subnet IDs - comma separated"
  overwrite   = true

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "infra_alb_dns_name" {
  name        = "/${var.project_name}/infra/alb-dns-name"
  type        = "String"
  value       = "placeholder"
  description = "ALB DNS name for ami-healer"
  overwrite   = true

  lifecycle {
    ignore_changes = [value]
  }
}

# ─── IAM POLICY: Read access to entire ami-healer SSM namespace ───────────────
# Attach this to any role that needs to read cross-repo config.
# Each repo's Lambda/EC2 role gets this via aws_iam_role_policy_attachment.

resource "aws_iam_policy" "ssm_read" {
  name        = "${var.project_name}-ssm-read-policy"
  description = "Read access to all ami-healer SSM parameters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "ReadAMIHealerParams"
      Effect = "Allow"
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ]
      Resource = "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/*"
    }]
  })
}

# ─── IAM POLICY: Write access for repos that publish parameters ───────────────

resource "aws_iam_policy" "ssm_write" {
  name        = "${var.project_name}-ssm-write-policy"
  description = "Write access to ami-healer SSM parameters"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "WriteAMIHealerParams"
      Effect = "Allow"
      Action = [
        "ssm:PutParameter",
        "ssm:DeleteParameter",
        "ssm:AddTagsToResource"
      ]
      Resource = "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/${var.project_name}/*"
    }]
  })
}
