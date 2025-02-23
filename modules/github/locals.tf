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
  action_var_azure_client_id = "AZURE_CLIENT_ID"
  action_var_azure_subscription_id = "AZURE_SUBSCRIPTION_ID"
  action_var_azure_tenant_id = "AZURE_TENANT_ID"
  action_var_backend_azure_resource_group_name = "BACKEND_AZURE_RESOURCE_GROUP_NAME"
  action_var_backend_azure_storage_account_name = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
  action_var_backend_azure_storage_account_container_name = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"

  # Set multiple client ids only for basic github action
  azure_client_ids = {
    (local.plan_key)  = "AZURE_CLIENT_ID_PLAN"
    (local.apply_key) = "AZURE_CLIENT_ID_APPLY"
  }

  runner_name = "ubuntu-latest"

  pipeline_target_folder = ".github/workflows"
  pipeline_option        = local.activated_features.environments && local.activated_features.deployment_protection_rule ? "enterprise" : "basic"
  pipeline_folder_path   = "${path.module}/actions/${local.pipeline_option}/workflows"
  pipeline_files = {
    for file in fileset(local.pipeline_folder_path, "**/*") :
    "${local.pipeline_target_folder}/${file}" => {
      content = templatefile("${local.pipeline_folder_path}/${file}",
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
        }
      )
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
