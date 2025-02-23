locals {
  organization_url = startswith(lower(var.organization_name), "https://") || startswith(lower(var.organization_name), "http://") ? var.organization_name : "https://github.com/${var.organization_name}"
}

locals {
  plan_key  = "plan"
  apply_key = "apply"
}

locals {
  org_plan = data.github_organization.this.plan

  free_plan = "free"
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

  # Set variables to setup different environment for the CI/CD pipeline in the case of basic pipeline.
  action_vars_format = {
    azure_client_id_plan                         = "AZURE_CLIENT_ID_PLAN_{{service_name}}_{{environment_name}}"
    azure_client_id_apply                        = "AZURE_CLIENT_ID_APPLY_{{service_name}}_{{environment_name}}"
    azure_client_id                              = "AZURE_CLIENT_ID_{{service_name}}_{{environment_name}}"
    azure_subscription_id                        = "AZURE_SUBSCRIPTION_ID_{{service_name}}_{{environment_name}}"
    azure_tenant_id                              = "AZURE_TENANT_ID_{{service_name}}_{{environment_name}}"
    backend_azure_resource_group_name            = "BACKEND_AZURE_RESOURCE_GROUP_NAME_{{service_name}}_{{environment_name}}"
    backend_azure_storage_account_name           = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME_{{service_name}}_{{environment_name}}"
    backend_azure_storage_account_container_name = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME_{{service_name}}_{{environment_name}}"
  }

  action_vars = { for key, value in local.action_vars_format : key => upper(replace(replace(value,
    "{{service_name}}", var.service_name),
    "{{environment_name}}", var.environment_name))
  }

  runner_name = "ubuntu-latest"

  pipeline_target_folder = ".github/workflows"
  pipeline_option        = local.activated_features.environments && local.activated_features.deployment_protection_rule ? "enterprise" : "basic"
  pipeline_folder_path   = "${path.module}/actions/${local.pipeline_option}/workflows"
  pipeline_files = {
    for file in fileset(local.pipeline_folder_path, "**/*") :
    file == "cd.yaml" ?
    "${local.pipeline_target_folder}/cd-${var.service_name}-${var.environment_name}.yaml" :
    file == "ci.yaml" ?
    "${local.pipeline_target_folder}/ci-${var.service_name}-${var.environment_name}.yaml" :
    "${local.pipeline_target_folder}/${file}" => {
      content = local.pipeline_option == "basic" ? templatefile("${local.pipeline_folder_path}/${file}",
        {
          root_module_folder_relative_path             = var.root_module_folder_relative_path
          organization_name                            = var.organization_name
          repository_name_templates                    = var.repository_name
          runner_name                                  = local.runner_name
          azure_tenant_id                              = local.action_vars.azure_tenant_id
          azure_subscription_id                        = local.action_vars.azure_subscription_id
          azure_client_id_apply                        = local.action_vars.azure_client_id_apply
          azure_client_id_plan                         = local.action_vars.azure_client_id_plan
          backend_azure_resource_group_name            = local.action_vars.backend_azure_resource_group_name
          backend_azure_storage_account_name           = local.action_vars.backend_azure_storage_account_name
          backend_azure_storage_account_container_name = local.action_vars.backend_azure_storage_account_container_name
          ci_template_path                             = "${local.pipeline_target_folder}/${local.ci_template_file_name}"
          cd_template_path                             = "${local.pipeline_target_folder}/${local.cd_template_file_name}"
        }) : templatefile("${local.pipeline_folder_path}/${file}",
        {
          root_module_folder_relative_path             = var.root_module_folder_relative_path
          organization_name                            = var.organization_name
          repository_name_templates                    = var.repository_name
          runner_name                                  = local.runner_name
          environment_name_plan                        = var.environments[local.plan_key]
          environment_name_apply                       = var.environments[local.plan_key]
          backend_azure_storage_account_container_name = var.backend_azure_storage_account_name
          ci_template_path                             = "${local.pipeline_target_folder}/${local.ci_template_file_name}"
          cd_template_path                             = "${local.pipeline_target_folder}/${local.cd_template_file_name}"
      })
    }
  }
}

locals {
  claim_keys = local.activated_features.environments ? ["repository", "environment", "job_workflow_ref"] : ["repository", "job_workflow_ref"]

  repository_claim_structure = "${var.organization_name}/${var.repository_name}/%s@refs/heads/main"

  ci_template_file_name = "ci-template.yaml"
  cd_template_file_name = "cd-template.yaml"

  oidc_subjects_basic = {
    (local.plan_key)  = "repo:${var.organization_name}/${var.repository_name}:job_workflow_ref:${format(local.repository_claim_structure, "${local.pipeline_target_folder}/${local.ci_template_file_name}")}",
    (local.apply_key) = "repo:${var.organization_name}/${var.repository_name}:job_workflow_ref:${format(local.repository_claim_structure, "${local.pipeline_target_folder}/${local.cd_template_file_name}")}",
  }

  oidc_subjects_enterprise = {
    (local.plan_key)  = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[local.plan_key]}:job_workflow_ref:${format(local.repository_claim_structure, "${local.pipeline_target_folder}/${local.ci_template_file_name}")}",
    (local.apply_key) = "repo:${var.organization_name}/${var.repository_name}:environment:${var.environments[local.apply_key]}:job_workflow_ref:${format(local.repository_claim_structure, "${local.pipeline_target_folder}/${local.cd_template_file_name}")}",
  }


  oidc_subjects = local.activated_features.environments ? local.oidc_subjects_enterprise : local.oidc_subjects_basic
}
