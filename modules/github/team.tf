locals {
  approvers = [for user in data.github_organization.this.users : user.login if contains(var.approvers, user.email)]
}

resource "github_team" "this" {
  name        = var.team_name
  description = "Approvers for the Landing Zone Terraform Apply"
  privacy     = "closed"
}

resource "github_team_membership" "this" {
  for_each = { for approver in local.approvers : approver => approver }
  team_id  = github_team.this.id
  username = each.key
  role     = "member"
}

resource "github_team_repository" "this" {
  team_id    = github_team.this.id
  repository = local.repository_name
  permission = "push"
}
