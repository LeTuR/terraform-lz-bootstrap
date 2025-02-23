locals {
  organization_url = startswith(lower(var.organization_name), "https://") || startswith(lower(var.organization_name), "http://") ? var.organization_name : "https://github.com/${var.organization_name}"
}

locals {
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  org_plan = data.github_organization.this.plan

  free_plan       = "free"
  team_plan       = "team"
  enterprise_plan = "enterprise"
}

locals {
  primary_approver     = length(var.approvers) > 0 ? var.approvers[0] : ""
  default_commit_email = coalesce(local.primary_approver, "demo@microsoft.com")
}

locals {
  repo_visibility = var.private_repository ? "private" : "public"

  activated_features = {
    environments               = local.org_plan == local.free_plan && var.private_repository ? false : true
    deployment_protection_rule = local.org_plan == local.free_plan && var.private_repository ? false : true
  }

  environments = local.activated_features.environments ? var.environments : {}

  # Define pipeline variables
  action_vars_default = {
    azure_client_id                              = "AZURE_CLIENT_ID_{{environment_name}}"
    azure_client_id_plan                         = "AZURE_CLIENT_ID_PLAN_{{environment_name}}"
    azure_client_id_apply                        = "AZURE_CLIENT_ID_APPLY_{{environment_name}}"
    azure_subscription_id                        = "AZURE_SUBSCRIPTION_ID_{{environment_name}}"
    azure_tenant_id                              = "AZURE_TENANT_ID_{{environment_name}}"
    backend_azure_resource_group_name            = "BACKEND_AZURE_RESOURCE_GROUP_NAME_{{environment_name}}"
    backend_azure_storage_account_name           = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME_{{environment_name}}"
    backend_azure_storage_account_container_name = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME_{{environment_name}}"
  }

  action_vars = {
    for key, value in var.project_landing_zones : key => {
      for action_key, action_value in local.action_vars_default : action_key => 
         local.activated_features.environments ? 
          trimsuffix(action_value, "_{{environment_name}}") :
          replace(action_value, "{{environment_name}}", upper(value.environment_name))
    }
  }

  # Set multiple client ids only for basic github action

  runner_name = "ubuntu-latest"

  pipeline_target_folder    = ".github/workflows"
  pipeline_option           = local.activated_features.environments && local.activated_features.deployment_protection_rule ? "enterprise" : "basic"
  pipeline_folder_path      = "${path.module}/actions/${local.pipeline_option}/workflows"
  ci_pipeline_template_file = "${local.pipeline_folder_path}/ci-template.yaml"
  cd_pipeline_template_file = "${local.pipeline_folder_path}/cd-template.yaml"
  ci_pipeline_file          = "${local.pipeline_folder_path}/ci.yaml"
  cd_pipeline_file          = "${local.pipeline_folder_path}/cd.yaml"

  pipeline_file_targets = {
    for key, value in var.project_landing_zones :
    key => {
      ci-template = "${local.pipeline_target_folder}/ci-template.yaml"
      cd-template = "${local.pipeline_target_folder}/ci-template.yaml"
      ci          = "${local.pipeline_target_folder}/ci-${key}.yaml"
      cd          = "${local.pipeline_target_folder}/cd-${key}.yaml"
    }
  }

  pipeline_files_content = merge([
    for key, value in var.project_landing_zones : {
      for target_file_key, target_file_value in local.pipeline_file_targets[key] : target_file_value => {
        content = templatefile(local.ci_pipeline_template_file, {
          root_module_folder_relative_path             = value.root_module_folder_relative_path
          organization_name                            = var.organization_name
          repository_name_templates                    = var.repository_name
          runner_name                                  = local.runner_name
          environment_name_plan                        = var.environments[key][local.plan_key]
          environment_name_apply                       = var.environments[key][local.apply_key]
          azure_subscription_id                        = local.action_vars[key].azure_subscription_id
          azure_tenant_id                              = local.action_vars[key].azure_tenant_id
          backend_azure_resource_group_name            = local.action_vars[key].backend_azure_resource_group_name
          backend_azure_storage_account_name           = local.action_vars[key].backend_azure_storage_account_name
          backend_azure_storage_account_container_name = local.action_vars[key].backend_azure_storage_account_name
        })
      }
    }
  ]...)
}

locals {
  claim_keys = local.activated_features.environments ? ["repository", "environment", "job_workflow_ref"] : ["repository", "job_workflow_ref"]

  repository_claim_structure = "${var.organization_name}/${var.repository_name}/%s@refs/heads/main"

  ci_template_file_name = "ci-template.yaml"
  cd_template_file_name = "cd-template.yaml"

  oidc_subjects_basic = { for key, value in var.project_landing_zones : key =>
    {
      (local.plan_key)  = "repo:${var.organization_name}/${var.repository_name}:job_workflow_ref:${format(local.repository_claim_structure, "${local.pipeline_target_folder}/${local.ci_template_file_name}")}",
      (local.apply_key) = "repo:${var.organization_name}/${var.repository_name}:job_workflow_ref:${format(local.repository_claim_structure, "${local.pipeline_target_folder}/${local.cd_template_file_name}")}",
    }
  }

  oidc_subjects_enterprise = { for key, value in var.project_landing_zones : key =>
    {
      (local.plan_key)  = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[key][local.plan_key]}:job_workflow_ref:${format(local.repository_claim_structure, "${local.pipeline_target_folder}/${local.ci_template_file_name}")}",
      (local.apply_key) = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[key][local.apply_key]}:job_workflow_ref:${format(local.repository_claim_structure, "${local.pipeline_target_folder}/${local.cd_template_file_name}")}",
    }
  }

  oidc_subjects = local.activated_features.environments ? local.oidc_subjects_enterprise : local.oidc_subjects_basic
}
