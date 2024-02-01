variables {
  name = "rg-test"
  role_assignments = {
    "role_assignment_test" = {
      role_definition_id_or_name = "acdd72a7-3385-48ef-bd42-f606fba81ae7"
      principal_id               = "a1542709-380b-49dd-bcde-a74351bc22cb"
    }
  }
  #azure_environment = "usgovernment"
  lock = {
    kind = "CanNotDelete"
    name = "myCustomLockName"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  use_cli                    = true
  environment                = startswith(var.location, "usgov") ? "usgovernment" : "public"
}


run "validate_lock_name_matches_input" {
  command = plan
  assert {
    condition     = azurerm_management_lock.this[0].name == "lock-rg-test" || azurerm_management_lock.this[0].name == var.lock.name
    error_message = "Lock name didn't match expected value"
  }
}

run "validate_lock_level_matches_input" {
  command = plan
  assert {
    condition     = contains(["CanNotDelete", "ReadOnly", "None"], var.lock.kind)
    error_message = "Lock name didn't match expected value"
  }
}

run "validate_lock_name_begins_with_prefix" {
  command = plan
  assert {
    condition     = azurerm_management_lock.this[0].name == var.lock.name || startswith(azurerm_management_lock.this[0].name, "lock-")
    error_message = "Lock name does not start with the correct prefix"
  }

  assert {
    condition     = length(azurerm_management_lock.this[0].name) <= 90 && length(azurerm_management_lock.this[0].name) >= 1
    error_message = "Lock name length "
  }

}

run "validate_lock_name_length" {
  command = plan
  assert {
    condition     = length(azurerm_management_lock.this[0].name) <= 90 && length(azurerm_management_lock.this[0].name) >= 1
    error_message = "Lock name length "
  }

}
