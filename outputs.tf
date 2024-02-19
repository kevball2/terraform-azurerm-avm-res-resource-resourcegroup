# Module owners should include the full resource via a 'resource' output
output "resource" {
  description = "This is the full output for the resource group."
  value       = azurerm_resource_group.this
}

output "name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.this.name
}

output "resource_id" {
  description = "The resource Id of the resource group"
  value       = azurerm_resource_group.this.id
}
