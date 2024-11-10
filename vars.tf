###############################################################
## Variables ##################################################
###############################################################
variable "alias_name" {
  type        = list(string)
  description = "(Required) The display name of the alias"
}

variable "description" {
  type        = string
  description = "(Optional) the description for the key. "
  default     = ""
}

variable "key_usage" {
  type        = string
  description = "(Optional) Specifies the intended use of the key. ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC. Defaults to ENCRYPT_DECRYPT"
  default     = "ENCRYPT_DECRYPT"
  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.key_usage)
    error_message = "The key usage must be ENCRYPT_DECRYPT, SIGN_VERIFY, or GENERATE_VERIFY_MAC."
  }
}

variable "deletion_window_in_days" {
  type        = string
  description = "(Optional) Duration in days after which the key is deleted after destruction of the resource, must be between 7 and 30 days"
  default     = "30"
}

variable "policy" {
  type        = string
  description = "(Optional) A valid policy JSON document. "
  default     = ""
}

variable "attach_policy" {
  type        = bool
  description = "(Optional) Defaults to 'true' for attaching a default policy, but you can override with 'false' if you don't want a default policy -- though you should still attach your own policy."
  default     = true
}

variable "is_enabled" {
  type        = bool
  description = "(Optional) Specifies whether the key is enabled"
  default     = true
}

variable "enable_key_rotation" {
  type        = bool
  description = "(Optional) Specifies whether key rotation is enabled"
  default     = true
}

variable "macie_access" {
  type        = bool
  description = "(Optional) Set to true if this KMS is used to encrypt S3 and needs to allow Macie to scan it.  Default value is 'true'.  Leaving it set to true won't hurt any non S3 use."
  default     = true
}

variable "tags" {
  description = "(Stifel Required) A mapping of tags to assign to the object."
  type        = map(string)
}