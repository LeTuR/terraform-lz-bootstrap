module "resource_group_state" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "~>0.2"

  name             = var.resource_group_state_name
  location         = var.location
  enable_telemetry = var.enable_telemetry
}

module "resource_group_identity" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "~>0.2"

  name             = var.resource_group_identity_name
  location         = var.location
  enable_telemetry = var.enable_telemetry

}
