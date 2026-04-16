output "resource_group_name" {
  description = "Spoke network resource group name"
  value       = azurerm_resource_group.spoke_network.name
}

output "resource_group_id" {
  description = "Spoke network resource group ID"
  value       = azurerm_resource_group.spoke_network.id
}

output "spoke_vnet_id" {
  description = "Spoke VNet resource ID"
  value       = azurerm_virtual_network.spoke.id
}

output "spoke_vnet_name" {
  description = "Spoke VNet name"
  value       = azurerm_virtual_network.spoke.name
}

output "spoke_vnet_address_space" {
  description = "Spoke VNet address space"
  value       = azurerm_virtual_network.spoke.address_space
}

output "web_subnet_id" {
  description = "Web subnet ID"
  value       = var.create_web_subnet ? azurerm_subnet.web[0].id : null
}

output "app_subnet_id" {
  description = "App subnet ID"
  value       = var.create_app_subnet ? azurerm_subnet.app[0].id : null
}

output "data_subnet_id" {
  description = "Data subnet ID"
  value       = var.create_data_subnet ? azurerm_subnet.data[0].id : null
}

output "web_nsg_id" {
  description = "Web tier NSG ID"
  value       = var.create_web_subnet ? azurerm_network_security_group.web[0].id : null
}

output "app_nsg_id" {
  description = "App tier NSG ID"
  value       = var.create_app_subnet ? azurerm_network_security_group.app[0].id : null
}

output "data_nsg_id" {
  description = "Data tier NSG ID"
  value       = var.create_data_subnet ? azurerm_network_security_group.data[0].id : null
}

output "route_table_id" {
  description = "Route table ID"
  value       = azurerm_route_table.spoke.id
}

output "peering_spoke_to_hub_id" {
  description = "Spoke-to-Hub peering ID"
  value       = azurerm_virtual_network_peering.spoke_to_hub.id
}

output "peering_hub_to_spoke_id" {
  description = "Hub-to-Spoke peering ID"
  value       = azurerm_virtual_network_peering.hub_to_spoke.id
}
