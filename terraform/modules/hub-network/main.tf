terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Resource Group
resource "azurerm_resource_group" "hub_network" {
  name     = "rg-${var.environment}-${var.location}-hub-network"
  location = var.location
  tags     = var.common_tags
}

# Hub Virtual Network
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${var.environment}-${var.location}-hub-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_network.name
  address_space       = [var.hub_vnet_address_space]
  
  tags = merge(
    var.common_tags,
    {
      "Network-Type" = "Hub"
      "Criticality"  = "High"
    }
  )
}

# Gateway Subnet (for ExpressRoute/VPN)
resource "azurerm_subnet" "gateway" {
  name                 = "GatewaySubnet"  # Must be exactly this name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.gateway_subnet_address_space]
}

# Azure Firewall Subnet
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"  # Must be exactly this name
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.firewall_subnet_address_space]
}

# Shared Services Subnet
resource "azurerm_subnet" "shared_services" {
  name                 = "snet-${var.environment}-${var.location}-shared-services"
  resource_group_name  = azurerm_resource_group.hub_network.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [var.shared_services_subnet_address_space]
  
  private_endpoint_network_policies_enabled = false
}

# Azure Firewall Public IP
resource "azurerm_public_ip" "firewall" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "pip-${var.environment}-${var.location}-firewall-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_network.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

# Azure Firewall
resource "azurerm_firewall" "hub" {
  count               = var.deploy_firewall ? 1 : 0
  name                = "afw-${var.environment}-${var.location}-hub-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_network.name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.firewall_sku_tier
  
  ip_configuration {
    name                 = "firewall-ip-config"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall[0].id
  }
  
  tags = var.common_tags
}

# Log Analytics Workspace (for monitoring)
resource "azurerm_log_analytics_workspace" "hub" {
  count               = var.deploy_log_analytics ? 1 : 0
  name                = "log-${var.environment}-${var.location}-hub"
  location            = var.location
  resource_group_name = azurerm_resource_group.hub_network.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.common_tags
}

# Diagnostic Settings for Firewall
resource "azurerm_monitor_diagnostic_setting" "firewall" {
  count                      = var.deploy_firewall && var.deploy_log_analytics ? 1 : 0
  name                       = "diag-firewall"
  target_resource_id         = azurerm_firewall.hub[0].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.hub[0].id

  enabled_log {
    category = "AzureFirewallApplicationRule"
  }

  enabled_log {
    category = "AzureFirewallNetworkRule"
  }

  metric {
    category = "AllMetrics"
  }
}
