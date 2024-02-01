variable "location" {
  type        = string
  default     = "usgovvirginia"
  description = "Required. The Azure region for deployment of the this resource."
}

variable "lock" {
  type = object({
    kind = optional(string, "None")
    name = optional(string, null)
  })
  default     = {}
  description = <<DESCRIPTION
  Controls the Resource Lock configuration for this resource. The following properties can be specified:
  
  - `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"`, `\"ReadOnly\" and `\"None\"`.
  - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
  
  Example Input:

  ```terraform
  lock = {
      kind = "CanNotDelete"|"ReadOnly"|"None"
      name = "lock-<name>"
    }
  }
  ```
  DESCRIPTION
  validation {
    condition     = contains(["CanNotDelete", "ReadOnly", "None"], var.lock.kind)
    error_message = "Lock kind must be either `\"CanNotDelete\"` or `\"ReadOnly\"`."
  }
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
Optional. A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - (Required) The ID or name of the role definition to assign to the principal.
- `principal_id` - (Required) The ID of the principal to assign the role to.
- `description` - (Optional) The description of the role assignment.
- `skip_service_principal_aad_check` - (Optional) If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - (Optional) The condition which will be used to scope the role assignment.
- `condition_version` - (Optional) The version of the condition syntax. Valid values are '2.0'.
- `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created. NOTE:
this field is only used in cross tenant scenario.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Example Input:
``` terraform
role_assignments = {
  "role_assignment1" = {
    role_definition_id_or_name = "Reader"
    principal_id = "2ab98150-aa97-489a-b080-ab5b92e128c3"
    
  },
"role_assignment2" = {
  role_definition_id_or_name = "b24988ac-6180-42a0-ab88-20f7382dd24c"
  principal_id = "912cd0d5-4089-4e4f-9aa2-c9d92451accc"
  skip_service_principal_aad_check = true | false
  condition_version = "2.0"
  condition = <<-EOT
(
(
  !(ActionMatches{'Microsoft.Authorization/roleAssignments/write'})
)
OR 
(
  @Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId]
ForAnyOfAnyValues:GuidEquals {912cd0d5-4089-4e4f-9aa2-c9d92451accc}

)
)
AND
(
(
  !(ActionMatches{'Microsoft.Authorization/roleAssignments/delete'})
)
OR 
(
  @Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId]
ForAnyOfAnyValues:GuidEquals {912cd0d5-4089-4e4f-9aa2-c9d92451accc}

)
)
EOT  
  }
}
DESCRIPTION
}

# tflint-ignore: terraform_unused_declarations
variable "tags" {
  type        = map(any)
  default     = {}
  description = "Optional. The map of tags to be applied to the resource"
}
