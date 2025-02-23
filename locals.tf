locals {
  tenant_id = data.azurerm_client_config.current.tenant_id
}

locals {
  resource_names = { for key, value in var.project_landing_zones: key => module.resource_names[key].resource_name }
}

locals {
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  team_name = { for key, value in var.project_landing_zones: key => local.resource_names[key].version_control_system_team }
  environments = { for key, value in var.project_landing_zones: key => {
    plan = local.resource_names[key].version_control_system_environment_plan
      (local.plan_key) = local.resource_names[key].version_control_system_environment_plan
      (local.apply_key) = local.resource_names[key].version_control_system_environment_apply
    }
  }
}

locals {
  role_definitions = {
    owner = {
      name = "Owner"
    }
    reader = {
      name = "Reader"
    }
    storage_owner = {
      name = "Storage Blob Data Owner"
    }
    storage_reader = {
      name = "Storage Blob Data Reader"
    }
  }
 
  user_assigned_managed_identities = { 
    for key, value in var.project_landing_zones: key =>
    {
      (local.plan_key)  = local.resource_names[key].identity_plan_name
      (local.apply_key) = local.resource_names[key].identity_apply_name
    }
  }

  federated_credentials =  { 
    for key, value in var.project_landing_zones: key =>
    {
      for terraform_key in [local.plan_key, local.apply_key] : terraform_key => {
        federated_credential_name          = "${local.resource_names[key].user_assigned_managed_identity_federated_credentials_prefix}-${terraform_key}"
        federated_credential_issuer        = module.github.issuer
        user_assigned_managed_identity_key = terraform_key
        federated_credential_subject       = module.github.subjects[terraform_key]
      }
    }
  }

  managed_identity_client_ids = { 
    for key, value in var.project_landing_zones: key =>
    {
      (local.plan_key)  = module.azure[key].managed_identity_client_ids[local.plan_key]
      (local.apply_key) = module.azure[key].managed_identity_client_ids[local.apply_key]
    }
  }

  role_assignments_for_landing_zone = { 
    for key, value in var.project_landing_zones: key =>
    {
      (local.plan_key) = {
        role_definition                  = "reader"
        user_assigned_managed_identities = [local.plan_key]
      }
      (local.apply_key) = {
        role_definition                  = "owner"
        user_assigned_managed_identities = [local.apply_key]
      }
    }
  }

  role_assignments_for_landing_zone_state = {
    for key, value in var.project_landing_zones: key => 
    {
      (local.plan_key) = {
        role_definition                  = "storage_reader"
        user_assigned_managed_identities = [local.plan_key]
      }
      (local.apply_key) = {
        role_definition                  = "storage_owner"
        user_assigned_managed_identities = [local.apply_key]
      }
    }
  }
}

locals {
  github_project_landing_zones = {
    for key, project_landing_zone in var.project_landing_zones: key => {
      location                                     = project_landing_zone.location
      service_name                                 = project_landing_zone.service_name
      environment_name                             = project_landing_zone.environment_name
      azure_subscription_id                        = project_landing_zone.landing_zone_subscription_id
      azure_tenant_id                              = local.local.tenant_id
      backend_azure_resource_group_name            = module.azure[key].backend_azure_resource_group_name
      backend_azure_storage_account_name           = module.azure[key].backend_azure_storage_account_name
      backend_azure_storage_account_container_name = module.azure[key].backend_azure_storage_account_container_name
      root_module_folder_relative_path             = project_landing_zone.root_module_folder_relative_path

    }
  }
}