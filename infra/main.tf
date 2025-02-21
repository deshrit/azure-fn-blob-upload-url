terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.2.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "91d629ce-8ce3-4016-b8ca-fd4d9af5ac31"
}

# Existing resource group
data "azurerm_resource_group" "rg" {
  name = "deshrit-playground"
}

# Random string
resource "random_id" "rng" {
  keepers = {
    first = "${timestamp()}"
  }
  byte_length = 4
}

# Storage account
resource "azurerm_storage_account" "sa" {
  name                     = "dsa${random_id.rng.hex}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Service plan
resource "azurerm_service_plan" "sp" {
  name                = "dsp${random_id.rng.hex}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# Application insight
resource "azurerm_application_insights" "ai" {
  name                = "dai${random_id.rng.hex}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "web"
}

# Function app
resource "azurerm_linux_function_app" "fa" {
  name                = "dfa${random_id.rng.hex}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  service_plan_id            = azurerm_service_plan.sp.id

  site_config {
    application_stack {
      python_version = "3.11"
    }
    application_insights_connection_string = azurerm_application_insights.ai.connection_string
    application_insights_key               = azurerm_application_insights.ai.instrumentation_key
  }
}

# Storage container
resource "azurerm_storage_container" "sc" {
  name                  = "dsc${random_id.rng.hex}"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}
