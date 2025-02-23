output "organization_url" {
  value = local.organization_url
}

output "subjects" {
  value = local.oidc_subjects
}

output "issuer" {
  value = "https://token.actions.githubusercontent.com"
}

output "organization_users" {
  value = data.github_organization.this.users
}

output "organization_plan" {
  value = data.github_organization.this.plan
}

output "repository_name" {
  value = local.repository_name
}
