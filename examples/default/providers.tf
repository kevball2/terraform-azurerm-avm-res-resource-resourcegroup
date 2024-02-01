terraform {
  required_version = ">= 1.5.2"
  required_providers {
    # TODO: Ensure all required providers are listed here.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  use_cli                    = true
  environment                = startswith(var.location, "usgov") ? "usgovernment" : "public"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}