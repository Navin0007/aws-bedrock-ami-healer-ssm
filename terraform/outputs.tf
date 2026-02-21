output "ssm_read_policy_arn" {
  description = "Attach to any role that reads ami-healer SSM params"
  value       = aws_iam_policy.ssm_read.arn
}

output "ssm_write_policy_arn" {
  description = "Attach to roles that write ami-healer SSM params"
  value       = aws_iam_policy.ssm_write.arn
}

output "ssm_namespace" {
  description = "SSM namespace prefix"
  value       = "/${var.project_name}/"
}

output "namespace_doc_parameter_name" {
  description = "SSM parameter name for namespace documentation"
  value       = aws_ssm_parameter.namespace_doc.name
}

# ─── INFRA PARAMETER OUTPUTS ────────────────────────────────────────────────────

output "infra_ami_id_parameter" {
  description = "SSM parameter for latest working AMI ID"
  value = {
    name  = aws_ssm_parameter.infra_ami_id.name
    arn   = aws_ssm_parameter.infra_ami_id.arn
    value  = aws_ssm_parameter.infra_ami_id.value
  }
}

output "infra_asg_name_parameter" {
  description = "SSM parameter for ASG name"
  value = {
    name  = aws_ssm_parameter.infra_asg_name.name
    arn   = aws_ssm_parameter.infra_asg_name.arn
    value  = aws_ssm_parameter.infra_asg_name.value
  }
}

output "infra_launch_template_id_parameter" {
  description = "SSM parameter for launch template ID"
  value = {
    name  = aws_ssm_parameter.infra_launch_template_id.name
    arn   = aws_ssm_parameter.infra_launch_template_id.arn
    value  = aws_ssm_parameter.infra_launch_template_id.value
  }
}

output "infra_vpc_id_parameter" {
  description = "SSM parameter for VPC ID"
  value = {
    name  = aws_ssm_parameter.infra_vpc_id.name
    arn   = aws_ssm_parameter.infra_vpc_id.arn
    value  = aws_ssm_parameter.infra_vpc_id.value
  }
}

output "infra_private_subnet_ids_parameter" {
  description = "SSM parameter for private subnet IDs"
  value = {
    name  = aws_ssm_parameter.infra_private_subnet_ids.name
    arn   = aws_ssm_parameter.infra_private_subnet_ids.arn
    value  = aws_ssm_parameter.infra_private_subnet_ids.value
  }
}

output "infra_alb_dns_name_parameter" {
  description = "SSM parameter for ALB DNS name"
  value = {
    name  = aws_ssm_parameter.infra_alb_dns_name.name
    arn   = aws_ssm_parameter.infra_alb_dns_name.arn
    value  = aws_ssm_parameter.infra_alb_dns_name.value
  }
}
