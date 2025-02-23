variable "project_landing_zones" {
  description = "Project landing zones."
  type = map(object({
    location                         = string
    service_name                     = string
    environment_name                 = string
    landing_zone_subscription_id     = string
    root_module_folder_relative_path = optional(string, ".")
  }))
}

variable "postfix_number" {
  description = "Used to build up the default resource names (e.g. rg-terraform-dev-francecentral-<postfix_number>)"
  type        = number
  default     = 1
  nullable    = false
}

variable "github_personal_access_token" {
  description = "The personal access token for GitHub."
  type        = string
  sensitive   = true
  nullable    = false
}

variable "github_organization_name" {
  description = "The name of your GitHub organization. This is the section of the url after 'github.com'. E.g. enter 'my-org' for 'https://github.com/my-org'"
  type        = string
  nullable    = false
}

variable "github_approvers" {
  description = "The list of GitHub users or teams that can approve the apply workflow."
  type        = list(string)
  nullable    = false
}

variable "github_private_repository" {
  description = "Set GitHub private repository. When using a free plan, public repositories are required to get all the deployment features such as deployment protection rules and environments."
  type        = bool
  default     = true
  nullable    = false
}

variable "github_repository_exists" {
  description = "If repository already exists, set to true."
  type        = bool
  default     = false
  nullable    = false
}

variable "github_require_signed_commits" {
  description = "Enforce signed commits for security"
  type        = bool
  default     = true
  nullable    = false
}

variable "github_root_module_folder_relative_path" {
  description = "Set root module folder"
  type        = string
  default     = "."
  nullable    = false
}

variable "enable_telemetry" {
  description = "Enable telemetry."
  type        = bool
  default     = true
  nullable    = false
}
