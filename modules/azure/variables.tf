variable "subscription_id" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_identity_name" {
  type = string
}

variable "resource_group_state_name" {
  type = string
}

variable "user_assigned_managed_identities" {
  type = map(string)
}

variable "role_assignments_for_landing_zone" {
  type = map(object({
    role_definition                    = string
    users                              = optional(list(string), [])
    groups                             = optional(list(string), [])
    app_registration                   = optional(list(string), [])
    system_assigned_managed_identities = optional(list(string), [])
    user_assigned_managed_identities   = optional(list(string), [])
    any_principals                     = optional(list(string), [])
  }))
  default = {}
}

variable "role_assignments_for_landing_zone_state" {
  type = map(object({
    role_definition                    = string
    users                              = optional(list(string), [])
    groups                             = optional(list(string), [])
    app_registration                   = optional(list(string), [])
    system_assigned_managed_identities = optional(list(string), [])
    user_assigned_managed_identities   = optional(list(string), [])
    any_principals                     = optional(list(string), [])
  }))
  default = {}
}

variable "role_definitions" {
  type = map(object({
    name = string
  }))
  default = {}
}

variable "federated_credentials" {
  type = map(object(
    {
      federated_credential_name          = string
      federated_credential_issuer        = string
      federated_credential_subject       = string
      user_assigned_managed_identity_key = string
    },
  ))
  default = {}
}

variable "enable_telemetry" {
  type    = bool
  default = true
}
