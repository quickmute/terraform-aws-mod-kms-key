output "key_arn" {
  description = "The amazon resource name of the key"
  value       = aws_kms_key.default.arn
}

output "key_id" {
  description = "The globally unique identifier for the key"
  value       = aws_kms_key.default.key_id
}
output "alias" {
  description = "The amazon resource name of the key alias"
  value       = aws_kms_alias.default
}

