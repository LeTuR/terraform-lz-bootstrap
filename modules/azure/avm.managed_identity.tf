module "managed_identities" {
  source  = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version = "~>0.3"

  for_each = var.user_assigned_managed_identities

  name                = each.value
  location            = var.location
  resource_group_name = module.resource_group_identity.name
  enable_telemetry    = var.enable_telemetry
}

resource "azurerm_federated_identity_credential" "this" {
  for_each   = var.federated_credentials
  depends_on = [module.managed_identities]

  name                = each.value.federated_credential_name
  resource_group_name = module.resource_group_identity.name
  audience            = [local.audience]
  issuer              = each.value.federated_credential_issuer
  parent_id           = module.managed_identities[each.value.user_assigned_managed_identity_key].resource_id
  subject             = each.value.federated_credential_subject
}
