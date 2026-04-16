terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Hub Network
module "hub_network" {
  source = "../../terraform/modules/hub-network"

  environment            = var.environment
  location               = var.location
  hub_vnet_address_space = var.hub_vnet_address_space
  
  # Subnets
  gateway_subnet_address_space         = var.gateway_subnet_address_space
  firewall_subnet_address_space        = var.firewall_subnet_address_space
  shared_services_subnet_address_space = var.shared_services_subnet_address_space
  
  # Optional components
  deploy_firewall      = var.deploy_firewall
  firewall_sku_tier    = var.firewall_sku_tier
  deploy_log_analytics = var.deploy_log_analytics
  log_retention_days   = var.log_retention_days
  
  common_tags = var.common_tags
}
