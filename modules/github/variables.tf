variable "repository_name" {
  description = "The name of the infrastructure GitHub repository."
  type        = string
}

variable "repository_exists" {
  description = "Set if the repository already exists"
  type        = bool
  default     = false
}

variable "organization_name" {
  description = "The name of the GitHub organization."
  type        = string
}

variable "environments" {
  description = "Set Github environments"
  type        = map(string)
}

variable "team_name" {
  description = "Set Github team name"
  type        = string
}

variable "approvers" {
  description = "Set Github apply approvers"
  type        = list(string)
}

variable "private_repository" {
  description = <<DESCRIPTION
Set Github private repository. 
When using a free plan, public repositories are required to get all the deployment features such
as deployment protection rules and environments.
  DESCRIPTION
  type        = bool
  default     = true
}

variable "require_signed_commits" {
  description = "Enforce signed commits for security"
  type        = bool
  default     = true
}

variable "managed_identity_client_ids" {
  description = "Set managed identity client ids"
  type        = map(string)
}

variable "azure_subscription_id" {
  description = "Set Azure subscription id"
  type        = string
}

variable "azure_tenant_id" {
  description = "Set Azure tenant id"
  type        = string
}

variable "backend_azure_resource_group_name" {
  description = "Set backend Azure resource group name"
  type        = string
}

variable "backend_azure_storage_account_name" {
  description = "Set backend Azure storage account name"
  type        = string
}

variable "backend_azure_storage_account_container_name" {
  description = "Set backend Azure storage account container name"
  type        = string
}

variable "root_module_folder_relative_path" {
  type    = string
  default = "."
}

variable "service_name" {
  description = "The name of the landing zone service."
  type        = string
}

variable "environment_name" {
  description = "The name of the environment."
  type        = string
}
