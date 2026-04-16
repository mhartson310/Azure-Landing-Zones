output "resource_group_name" {
  description = "Hub network resource group name"
  value       = module.hub_network.resource_group_name
}

output "hub_vnet_id" {
  description = "Hub VNet ID"
  value       = module.hub_network.hub_vnet_id
}

output "hub_vnet_name" {
  description = "Hub VNet name"
  value       = module.hub_network.hub_vnet_name
}

output "firewall_private_ip" {
  description = "Azure Firewall private IP (use in spoke UDRs)"
  value       = module.hub_network.firewall_private_ip
}

output "firewall_public_ip" {
  description = "Azure Firewall public IP"
  value       = module.hub_network.firewall_public_ip
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = module.hub_network.log_analytics_workspace_id
}

output "deployment_summary" {
  description = "Deployment summary"
  value = {
    environment     = var.environment
    location        = var.location
    hub_vnet        = module.hub_network.hub_vnet_name
    firewall_ip     = module.hub_network.firewall_private_ip
    estimated_cost  = var.deploy_firewall ? "$1,400-2,000/month" : "$100-300/month"
  }
}
