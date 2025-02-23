module "role_assignments" {
  source  = "Azure/avm-res-authorization-roleassignment/azurerm"
  version = "~>0.2"

  user_assigned_managed_identities_by_display_name = var.user_assigned_managed_identities
  role_assignments_for_subscriptions               = local.role_assignments_for_subscriptions
  role_assignments_for_resources                   = local.role_assignments_for_resources
  role_definitions                                 = var.role_definitions
  enable_telemetry                                 = var.enable_telemetry

  depends_on = [module.managed_identities, module.storage]
}
