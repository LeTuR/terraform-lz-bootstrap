locals {
  audience = "api://AzureADTokenExchange"
}

locals {
  state_container_name = "tfstate"
}

locals {
  role_assignments_for_subscriptions = {
    landing_zone = {
      subscription_id  = var.subscription_id
      role_assignments = var.role_assignments_for_landing_zone
    }
  }
  role_assignments_for_resources = {
    landing_zone_state = {
      resource_name       = module.storage.name
      resource_group_name = var.resource_group_state_name
      role_assignments    = var.role_assignments_for_landing_zone_state
    }
  }
}
