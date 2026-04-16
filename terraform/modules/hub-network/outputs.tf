output "resource_group_name" {
  description = "Hub network resource group name"
  value       = azurerm_resource_group.hub_network.name
}

output "resource_group_id" {
  description = "Hub network resource group ID"
  value       = azurerm_resource_group.hub_network.id
}

output "hub_vnet_id" {
  description = "Hub VNet resource ID"
  value       = azurerm_virtual_network.hub.id
}

output "hub_vnet_name" {
  description = "Hub VNet name"
  value       = azurerm_virtual_network.hub.name
}

output "hub_vnet_address_space" {
  description = "Hub VNet address space"
  value       = azurerm_virtual_network.hub.address_space
}

output "gateway_subnet_id" {
  description = "Gateway subnet ID"
  value       = azurerm_subnet.gateway.id
}

output "firewall_subnet_id" {
  description = "Firewall subnet ID"
  value       = azurerm_subnet.firewall.id
}

output "shared_services_subnet_id" {
  description = "Shared services subnet ID"
  value       = azurerm_subnet.shared_services.id
}

output "firewall_id" {
  description = "Azure Firewall resource ID"
  value       = var.deploy_firewall ? azurerm_firewall.hub[0].id : null
}

output "firewall_private_ip" {
  description = "Azure Firewall private IP address (for UDRs in spoke networks)"
  value       = var.deploy_firewall ? azurerm_firewall.hub[0].ip_configuration[0].private_ip_address : null
}

output "firewall_public_ip" {
  description = "Azure Firewall public IP address"
  value       = var.deploy_firewall ? azurerm_public_ip.firewall[0].ip_address : null
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = var.deploy_log_analytics ? azurerm_log_analytics_workspace.hub[0].id : null
}

output "log_analytics_workspace_name" {
  description = "Log Analytics workspace name"
  value       = var.deploy_log_analytics ? azurerm_log_analytics_workspace.hub[0].name : null
}
