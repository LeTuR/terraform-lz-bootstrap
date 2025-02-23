output "backend_azure_resource_group_name" {
  value = module.resource_group_state.name
}

output "backend_azure_storage_account_name" {
  value = module.storage.name
}

output "backend_azure_storage_account_container_name" {
  value = local.state_container_name
}

output "managed_identity_client_ids" {
  value = { for key, identity in var.user_assigned_managed_identities : key => module.managed_identities[key].client_id }
}
