// Importing the Azure naming module to ensure resources have unique CAF compliant names.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.0"
}

# resource "azurerm_resource_group" "dep-rg" {
#   location = var.location
#   name     = "rg-complete-test"
# }

resource "azurerm_user_assigned_identity" "dep_uai" {
  name                = module.naming.user_assigned_identity.name_unique
  resource_group_name = module.resource_group.resource.name
  location            = module.resource_group.resource.location
}

module "resource_group" {
  source   = "../../"
  location = var.location
  name     = module.naming.resource_group.name_unique
  tags = {
    "hidden-title" = "This is visible in the resource name"
    Environment    = "Non-Prod"
    Role           = "DeploymentValidation"
  }
  lock = {
    kind = "CanNotDelete"
    name = "myCustomLockName"

  }
  role_assignments = {
    "roleassignment1" = {
      principal_id               = azurerm_user_assigned_identity.dep_uai.principal_id
      role_definition_id_or_name = "Reader"
    },
    "role_assignment2" = {
      role_definition_id_or_name       = "/providers/Microsoft.Authorization/roleDefinitions/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1" # Storage Blob Data Reader Role Guid 
      principal_id                     = azurerm_user_assigned_identity.dep_uai.principal_id
      skip_service_principal_aad_check = false
      condition_version                = "2.0"
      condition                        = <<-EOT
(
 (
  !(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND NOT SubOperationMatches{'Blob.List'})
 )
 OR 
 (
  @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:name] StringEquals 'blobs-example-container'
 )
)
EOT
    }
  }
}