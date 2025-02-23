
variable "repository_name" {
  description = "The name of the infrastructure GitHub repository."
  type        = string
}

variable "organization_name" {
  description = "The name of the GitHub organization."
  type        = string
}

variable "environments" {
  description = "Set Github environments"
  type        = map(map(string))
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

variable "repository_exists" {
  description = "If repository already exists, set to true."
  type        = bool
  default     = false
}

variable "require_signed_commits" {
  description = "Enforce signed commits for security"
  type        = bool
  default     = true
}

variable "managed_identity_client_ids" {
  description = "Set managed identity client ids"
  type        = map(map(string))
}

variable "project_landing_zones" {
  description = "Project landing zones."
  type = map(object({
    location                                     = string
    service_name                                 = string
    environment_name                             = string
    azure_subscription_id                        = string
    azure_tenant_id                              = string
    backend_azure_resource_group_name            = string
    backend_azure_storage_account_name           = string
    backend_azure_storage_account_container_name = string
    root_module_folder_relative_path             = string
  }))
}
