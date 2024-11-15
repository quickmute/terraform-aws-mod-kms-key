# terraform-aws-mod-kms-key


## Best Practices - KMS Resource Policy

- As a best practice, the kms key policy should not include IAM policy permissions that are specific to an application execution role. This future-proofs scenarios where more than one runtime application utilizes the same kms key. For instance, if more than one application publishes to the same SQS queue that is encrypted via kms.

- Unless you specifically turn off policy attachment, this will add 2 policies (in addition to the one you pass in)
  - Policy to deny access outside of org
  - Policy to allow access to account itself (this is default policy and it defers the permission to anyone in this account that has IAM Role Policy to do this)

## Self Reference

If you wish you pass in a policy that references itself, then use the string keyword "$$$self_arn" to have it replaced with the arn of the KMS itself during run. 