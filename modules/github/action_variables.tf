resource "github_actions_variable" "azure_client_id_basic" {
  for_each = local.azure_client_ids

  repository    = local.repository.name
  variable_name = each.value
  value         = var.managed_identity_client_ids[each.key]
}

resource "github_actions_variable" "azure_subscription_id" {
  repository    = local.repository.name
  variable_name = "AZURE_SUBSCRIPTION_ID"
  value         = var.azure_subscription_id
}

resource "github_actions_variable" "azure_tenant_id" {
  repository    = local.repository.name
  variable_name = "AZURE_TENANT_ID"
  value         = var.azure_tenant_id
}

resource "github_actions_variable" "backend_azure_resource_group_name" {
  repository    = local.repository.name
  variable_name = "BACKEND_AZURE_RESOURCE_GROUP_NAME"
  value         = var.backend_azure_resource_group_name
}

resource "github_actions_variable" "backend_azure_storage_account_name" {
  repository    = local.repository.name
  variable_name = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
  value         = var.backend_azure_storage_account_name
}

resource "github_actions_variable" "backend_azure_storage_account_container_name" {
  repository    = local.repository.name
  variable_name = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"
  value         = var.backend_azure_storage_account_container_name
}
