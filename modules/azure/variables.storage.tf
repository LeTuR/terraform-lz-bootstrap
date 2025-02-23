variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
  nullable    = false
}

variable "account_replication_type" {
  description = "The type of replication to use for the storage account."
  type        = string
  default     = "GZRS"
  nullable    = false
}

variable "account_tier" {
  description = "The tier to use for the storage account."
  type        = string
  default     = "Standard"
  nullable    = false
}

variable "account_kind" {
  description = "The kind of account to create."
  type        = string
  default     = "StorageV2"
  nullable    = false
}

variable "https_traffic_only_enabled" {
  description = "Boolean flag which forces HTTPS if enabled."
  type        = bool
  default     = true
  nullable    = false
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account."
  type        = string
  default     = "TLS1_2"
  nullable    = false
}

variable "shared_access_key_enabled" {
  description = "Boolean flag which enables shared access key for the storage account."
  type        = bool
  default     = false
  nullable    = false
}

variable "public_network_access_enabled" {
  description = "Boolean flag which allows public access to the storage account."
  type        = bool
  default     = true
  nullable    = false
}
