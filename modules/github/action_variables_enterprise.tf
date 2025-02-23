resource "github_actions_environment_variable" "azure_client_id_enterprise" {
  for_each = local.environments

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "AZURE_CLIENT_ID"
  value         = var.managed_identity_client_ids[each.key]
}

resource "github_actions_environment_variable" "azure_subscription_id" {
  for_each = local.environments

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "AZURE_SUBSCRIPTION_ID"
  value         = var.azure_subscription_id
}

resource "github_actions_environment_variable" "azure_tenant_id" {
  for_each = local.environments

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "AZURE_TENANT_ID"
  value         = var.azure_tenant_id
}

resource "github_actions_environment_variable" "backend_azure_resource_group_name" {
  for_each = local.environments

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "BACKEND_AZURE_RESOURCE_GROUP_NAME"
  value         = var.backend_azure_resource_group_name
}

resource "github_actions_environment_variable" "backend_azure_storage_account_name" {
  for_each = local.environments

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
  value         = var.backend_azure_storage_account_name
}

resource "github_actions_environment_variable" "backend_azure_storage_account_container_name" {
  for_each = local.environments

  repository    = local.repository_name
  environment   = github_repository_environment.this[each.key].environment
  variable_name = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"
  value         = var.backend_azure_storage_account_container_name
}
