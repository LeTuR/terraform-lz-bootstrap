resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

module "resource_names" {
  source = "./modules/resource_names"

  for_each = var.project_landing_zones

  postfix_number   = var.postfix_number
  azure_location   = each.value.location
  environment_name = each.value.environment_name
  service_name     = each.value.service_name
  resource_names   = var.resource_names
}

module "github" {
  source = "./modules/github"

  project_landing_zones       = local.github_project_landing_zones
  organization_name           = var.github_organization_name
  repository_name             = local.resource_names.version_control_system_repository_infra
  approvers                   = var.github_approvers
  team_name                   = local.team_name
  require_signed_commits      = var.github_require_signed_commits
  environments                = local.environments
  private_repository          = var.github_private_repository
  managed_identity_client_ids = local.managed_identity_client_ids
}

module "azure" {
  for_each = var.project_landing_zones
  source   = "./modules/azure"

  location                                = each.value.location
  subscription_id                         = each.value.landing_zone_subscription_id
  resource_group_state_name               = local.resource_names[each.key].resource_group_state_name
  resource_group_identity_name            = local.resource_names[each.key].resource_group_identity_name
  storage_account_name                    = local.resource_names[each.key].storage_account_state_name
  user_assigned_managed_identities        = local.user_assigned_managed_identities[each.key]
  role_assignments_for_landing_zone       = local.role_assignments_for_landing_zone[each.key]
  role_assignments_for_landing_zone_state = local.role_assignments_for_landing_zone_state[each.key]
  role_definitions                        = local.role_definitions
  federated_credentials                   = local.federated_credentials[each.key]
  enable_telemetry                        = var.enable_telemetry
}
