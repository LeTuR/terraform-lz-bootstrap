resource "github_actions_variable" "azure_client_id_plan" {
  for_each = local.activated_features.environments ? {} : var.project_landing_zones

  repository    = local.repository.name
  variable_name = local.action_vars[each.key].azure_client_id_plan
  value         = var.managed_identity_client_ids[each.key][local.plan_key]
}

resource "github_actions_variable" "azure_client_id_apply" {
  for_each = local.activated_features.environments ? {} : var.project_landing_zones

  repository    = local.repository.name
  variable_name = local.action_vars[each.key].azure_client_id_apply
  value         = var.managed_identity_client_ids[each.key][local.plan_key]
}

resource "github_actions_variable" "azure_subscription_id" {
  for_each = local.activated_features.environments ? {} : var.project_landing_zones

  repository    = local.repository.name
  variable_name = local.action_vars[each.key].azure_subscription_id
  value         = var.project_landing_zones[each.key].azure_subscription_id
}

resource "github_actions_variable" "azure_tenant_id" {
  for_each = local.activated_features.environments ? {} : var.project_landing_zones

  repository    = local.repository.name
  variable_name = local.action_vars[each.key].azure_tenant_id
  value         = var.project_landing_zones[each.key].azure_tenant_id
}

resource "github_actions_variable" "backend_azure_resource_group_name" {
  for_each = local.activated_features.environments ? {} : var.project_landing_zones

  repository    = local.repository.name
  variable_name = local.action_vars[each.key].backend_azure_resource_group_name
  value         = var.project_landing_zones[each.key].backend_azure_resource_group_name
}

resource "github_actions_variable" "backend_azure_storage_account_name" {
  for_each = local.activated_features.environments ? {} : var.project_landing_zones

  repository    = local.repository.name
  variable_name = local.action_vars[each.key].backend_azure_storage_account_name
  value         = var.project_landing_zones[each.key].backend_azure_storage_account_name
}

resource "github_actions_variable" "backend_azure_storage_account_container_name" {
  for_each = local.activated_features.environments ? {} : var.project_landing_zones

  repository    = local.repository.name
  variable_name = local.action_vars[each.key].backend_azure_storage_account_container_name
  value         = var.project_landing_zones[each.key].backend_azure_storage_account_container_name
}
