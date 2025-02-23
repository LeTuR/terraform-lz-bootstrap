variable "resource_names" {
  type        = map(string)
  description = "Override the default names for resources."
  default = {
    resource_group_identity_name                                = "rg-{{service_name}}-{{environment_name}}-identity-{{azure_location}}-{{postfix_number}}"
    resource_group_state_name                                   = "rg-{{service_name}}-{{environment_name}}-state-{{azure_location}}-{{postfix_number}}"
    identity_plan_name                                          = "id-{{service_name}}-{{environment_name}}-plan-{{azure_location}}-{{postfix_number}}"
    identity_apply_name                                         = "id-{{service_name}}-{{environment_name}}-apply-{{azure_location}}-{{postfix_number}}"
    user_assigned_managed_identity_federated_credentials_prefix = "{{service_name}}-{{environment_name}}-{{azure_location}}-{{postfix_number}}"
    storage_account_state_name                                  = "sto{{service_name}}{{environment_name}}state{{azure_location_short}}{{postfix_number}}{{random_string}}"
    version_control_system_repository_infra                     = "{{service_name}}-infra"
    version_control_system_repository_templates                 = "{{service_name}}-{{environment_name}}-templates"
    version_control_system_environment_plan                     = "{{service_name}}-{{environment_name}}-plan"
    version_control_system_environment_apply                    = "{{service_name}}-{{environment_name}}-apply"
    version_control_system_team                                 = "{{service_name}}-{{environment_name}}-approvers"
  }
}
