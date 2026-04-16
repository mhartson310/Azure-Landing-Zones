terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Resource Group for Spoke
resource "azurerm_resource_group" "spoke_network" {
  name     = "rg-${var.environment}-${var.location}-spoke-${var.workload_name}"
  location = var.location
  tags     = var.common_tags
}

# Spoke Virtual Network
resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-${var.environment}-${var.location}-spoke-${var.workload_name}-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke_network.name
  address_space       = [var.spoke_vnet_address_space]

  tags = merge(
    var.common_tags,
    {
      "Network-Type" = "Spoke"
      "Workload"     = var.workload_name
    }
  )
}

# Web/Frontend Subnet
resource "azurerm_subnet" "web" {
  count                = var.create_web_subnet ? 1 : 0
  name                 = "snet-${var.environment}-${var.location}-${var.workload_name}-web"
  resource_group_name  = azurerm_resource_group.spoke_network.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.web_subnet_address_space]
  service_endpoints    = var.service_endpoints
}

# App/Logic Subnet
resource "azurerm_subnet" "app" {
  count                = var.create_app_subnet ? 1 : 0
  name                 = "snet-${var.environment}-${var.location}-${var.workload_name}-app"
  resource_group_name  = azurerm_resource_group.spoke_network.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.app_subnet_address_space]
  service_endpoints    = var.service_endpoints
}

# Data/Database Subnet
resource "azurerm_subnet" "data" {
  count                = var.create_data_subnet ? 1 : 0
  name                 = "snet-${var.environment}-${var.location}-${var.workload_name}-data"
  resource_group_name  = azurerm_resource_group.spoke_network.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [var.data_subnet_address_space]
  service_endpoints    = var.service_endpoints
  
  # Data tier typically needs private endpoints
  private_endpoint_network_policies_enabled = false
}

# Network Security Group - Web Tier
resource "azurerm_network_security_group" "web" {
  count               = var.create_web_subnet ? 1 : 0
  name                = "nsg-${var.environment}-${var.location}-${var.workload_name}-web"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke_network.name

  # Allow HTTPS from internet (typical for web tier)
  security_rule {
    name                       = "AllowHTTPSInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Allow HTTP (if needed, typically redirect to HTTPS)
  security_rule {
    name                       = "AllowHTTPInbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Deny all other inbound by default
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.common_tags
}

# Network Security Group - App Tier
resource "azurerm_network_security_group" "app" {
  count               = var.create_app_subnet ? 1 : 0
  name                = "nsg-${var.environment}-${var.location}-${var.workload_name}-app"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke_network.name

  # Allow from web tier only
  security_rule {
    name                       = "AllowFromWebTier"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.create_web_subnet ? var.web_subnet_address_space : "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Deny all other inbound
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.common_tags
}

# Network Security Group - Data Tier
resource "azurerm_network_security_group" "data" {
  count               = var.create_data_subnet ? 1 : 0
  name                = "nsg-${var.environment}-${var.location}-${var.workload_name}-data"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke_network.name

  # Allow from app tier only
  security_rule {
    name                       = "AllowFromAppTier"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["1433", "3306", "5432"]  # SQL Server, MySQL, PostgreSQL
    source_address_prefix      = var.create_app_subnet ? var.app_subnet_address_space : "VirtualNetwork"
    destination_address_prefix = "*"
  }

  # Deny all other inbound
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.common_tags
}

# Associate NSGs with Subnets
resource "azurerm_subnet_network_security_group_association" "web" {
  count                     = var.create_web_subnet ? 1 : 0
  subnet_id                 = azurerm_subnet.web[0].id
  network_security_group_id = azurerm_network_security_group.web[0].id
}

resource "azurerm_subnet_network_security_group_association" "app" {
  count                     = var.create_app_subnet ? 1 : 0
  subnet_id                 = azurerm_subnet.app[0].id
  network_security_group_id = azurerm_network_security_group.app[0].id
}

resource "azurerm_subnet_network_security_group_association" "data" {
  count                     = var.create_data_subnet ? 1 : 0
  subnet_id                 = azurerm_subnet.data[0].id
  network_security_group_id = azurerm_network_security_group.data[0].id
}

# Route Table - Force traffic through hub firewall
resource "azurerm_route_table" "spoke" {
  name                = "rt-${var.environment}-${var.location}-${var.workload_name}"
  location            = var.location
  resource_group_name = azurerm_resource_group.spoke_network.name

  # Default route to internet via firewall
  route {
    name                   = "RouteToFirewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }

  # Routes to other spokes via firewall
  dynamic "route" {
    for_each = var.other_spoke_address_spaces
    content {
      name                   = "RouteToSpoke-${route.key}"
      address_prefix         = route.value
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = var.firewall_private_ip
    }
  }

  tags = var.common_tags
}

# Associate Route Table with Subnets
resource "azurerm_subnet_route_table_association" "web" {
  count          = var.create_web_subnet ? 1 : 0
  subnet_id      = azurerm_subnet.web[0].id
  route_table_id = azurerm_route_table.spoke.id
}

resource "azurerm_subnet_route_table_association" "app" {
  count          = var.create_app_subnet ? 1 : 0
  subnet_id      = azurerm_subnet.app[0].id
  route_table_id = azurerm_route_table.spoke.id
}

resource "azurerm_subnet_route_table_association" "data" {
  count          = var.create_data_subnet ? 1 : 0
  subnet_id      = azurerm_subnet.data[0].id
  route_table_id = azurerm_route_table.spoke.id
}

# VNet Peering - Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${var.workload_name}-to-hub"
  resource_group_name       = azurerm_resource_group.spoke_network.name
  virtual_network_name      = azurerm_virtual_network.spoke.name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_remote_gateway
}

# VNet Peering - Hub to Spoke (requires hub resource group info)
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-${var.workload_name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.spoke.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.hub_has_gateway
  use_remote_gateways          = false
}
