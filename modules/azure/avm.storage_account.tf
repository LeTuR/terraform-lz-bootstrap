module "storage" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "~>0.5"

  account_replication_type      = var.account_replication_type
  account_tier                  = var.account_tier
  account_kind                  = var.account_kind
  location                      = var.location
  name                          = substr(var.storage_account_name, 0, min(24, length(var.storage_account_name)))
  https_traffic_only_enabled    = var.https_traffic_only_enabled
  resource_group_name           = module.resource_group_state.name
  min_tls_version               = var.min_tls_version
  shared_access_key_enabled     = var.shared_access_key_enabled
  public_network_access_enabled = var.public_network_access_enabled
  
  network_rules = {
    bypass = [
      "AzureServices"
    ]
  }
  managed_identities = {
    system_assigned = true
  }

  containers = {
    "tfstate" = {
      name = local.state_container_name
    }
  }
  enable_telemetry = var.enable_telemetry
}
