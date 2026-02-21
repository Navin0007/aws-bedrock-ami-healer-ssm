output "ssm_read_policy_arn" {
  description = "Attach to any role that reads ami-healer SSM params"
  value       = aws_iam_policy.ssm_read.arn
}

output "ssm_write_policy_arn" {
  description = "Attach to roles that write ami-healer SSM params"
  value       = aws_iam_policy.ssm_write.arn
}

output "ssm_namespace" {
  value = "/${var.project_name}/"
}
