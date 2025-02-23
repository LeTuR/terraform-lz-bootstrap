resource "github_repository_environment" "this" {
  for_each   = local.activated_features.environments ? var.environments : {}
  depends_on = [github_team_repository.this]

  environment = each.value
  repository  = local.repository_name

  dynamic "reviewers" {
    for_each = each.key == local.apply_key && length(var.approvers) > 0 ? [1] : []
    content {
      teams = [
        github_team.this.id
      ]
    }
  }

  dynamic "deployment_branch_policy" {
    for_each = each.key == local.apply_key ? [1] : []
    content {
      protected_branches     = true
      custom_branch_policies = false
    }
  }
}
