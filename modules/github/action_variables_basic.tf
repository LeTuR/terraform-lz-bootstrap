resource "github_actions_variable" "azure_client_id_plan_basic" {
  repository    = local.repository_name
  variable_name = local.action_vars.azure_client_id_plan
  value         = var.managed_identity_client_ids[local.plan_key]
}

resource "github_actions_variable" "azure_client_id_apply_basic" {
  repository    = local.repository_name
  variable_name = local.action_vars.azure_client_id_apply
  value         = var.managed_identity_client_ids[local.apply_key]
}

resource "github_actions_variable" "azure_subscription_id_basic" {
  repository    = local.repository_name
  variable_name = local.action_vars.azure_subscription_id
  value         = var.azure_subscription_id
}

resource "github_actions_variable" "azure_tenant_id_basic" {
  repository    = local.repository_name
  variable_name = local.action_vars.azure_tenant_id
  value         = var.azure_tenant_id
}

resource "github_actions_variable" "backend_azure_resource_group_name_basic" {
  repository    = local.repository_name
  variable_name = local.action_vars.backend_azure_resource_group_name
  value         = var.backend_azure_resource_group_name
}

resource "github_actions_variable" "backend_azure_storage_account_name_basic" {
  repository    = local.repository_name
  variable_name = local.action_vars.backend_azure_storage_account_name
  value         = var.backend_azure_storage_account_name
}

resource "github_actions_variable" "backend_azure_storage_account_container_name_basic" {
  repository    = local.repository_name
  variable_name = local.action_vars.backend_azure_storage_account_container_name
  value         = var.backend_azure_storage_account_container_name
}
