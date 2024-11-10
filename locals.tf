locals {
  orgId      = data.aws_organizations_organization.current.id
  accountId  = data.aws_caller_identity.current.account_id
  regionName = data.aws_region.current.name

  ## local that contains a policy json or empty string
  macie_policy = var.macie_access ? data.aws_iam_policy_document.macie_decrypt.json : ""
}