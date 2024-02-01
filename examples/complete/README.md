<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-ecm-res-resource-resourcegroup

This module is used to deploy an Azure Resource Group

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.5.2)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.71.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.71.0)

## Resources

The following resources are used by this module:

- [azurerm_user_assigned_identity.dep-uai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: Required. The Azure region for deployment of the this resource.

Type: `string`

Default: `"usgovvirginia"`

### <a name="input_lock"></a> [lock](#input\_lock)

Description:   Controls the Resource Lock configuration for this resource. The following properties can be specified:

  - `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"`, `\"ReadOnly\" and `\"None\"`.
  - `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.  

  Example Input:

  ````terraform
  lock = {
      kind = "CanNotDelete"|"ReadOnly"|"None"
      name = "lock-<name>"
    }
  }
```

Type:

```hcl
object({
    kind = optional(string, "None")
    name = optional(string, null)
  })
```

Default: `{}`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: Optional. A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

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
```

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: Optional. The map of tags to be applied to the resource

Type: `map(any)`

Default: `{}`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: 0.4.0

### <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Footer Data
<!-- END_TF_DOCS -->