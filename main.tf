resource "aws_kms_key" "default" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  key_usage               = var.key_usage
  is_enabled              = var.is_enabled
  enable_key_rotation     = var.enable_key_rotation
  tags                    = merge(var.tags, { "Name" = var.alias_name[0] })
}

resource "aws_kms_alias" "default" {
  for_each      = toset(var.alias_name)
  name          = "alias/${each.value}"
  target_key_id = aws_kms_key.default.key_id
}

## This is default policy that denies access outside of our organization with exception being Service access.
data "aws_iam_policy_document" "deny_not_our_organization" {
  statement {
    sid     = "EnforceIdentityPerimeter"
    effect  = "Deny"
    actions = ["kms:*"]

    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:ResourceOrgID"
      values   = [local.orgId]
    }

    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

data "aws_iam_policy_document" "macie_decrypt" {
  statement {
    sid     = "macie_role"
    effect  = "Allow"
    actions = ["kms:Decrypt"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["s3.*.amazonaws.com"]
    }
    condition {
      test     = "ArnEquals"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${local.accountId}:role/aws-service-role/macie.amazonaws.com/AWSServiceRoleForAmazonMacie"]
    }
  }
}

data "aws_iam_policy_document" "account_root_access" {
  statement {
    sid     = "account_root_access"
    actions = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${local.accountId}:root"]
    }
    resources = ["*"]
  }
}

## Here we create the default policy and we also add the root access

data "aws_iam_policy_document" "key_policy_default" {
  ## override takes precedence
  ## In here we also do a string replacement to add the ARN of itself to the policy. The user needs to use the keywork "$$$self_arn" to ensure this happens
  override_policy_documents = [replace(var.policy, "$$$self_arn", aws_kms_key.default.arn)]
  ## source will get overridden if there are any same SIDs
  source_policy_documents = [
    local.macie_policy,
    data.aws_iam_policy_document.deny_not_our_organization.json,
    data.aws_iam_policy_document.account_root_access.json
  ]
}

resource "aws_kms_key_policy" "default" {
  count  = var.attach_policy ? 1 : 0
  key_id = aws_kms_key.default.id
  policy = data.aws_iam_policy_document.key_policy_default.json
}