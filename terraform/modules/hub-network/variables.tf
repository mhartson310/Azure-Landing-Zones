variable "environment" {
  description = "Environment name (prod, nonprod, dev, staging)"
  type        = string
  
  validation {
    condition     = contains(["prod", "nonprod", "dev", "staging"], var.environment)
    error_message = "Environment must be one of: prod, nonprod, dev, staging."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "hub_vnet_address_space" {
  description = "Address space for hub VNet (e.g., 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition     = can(cidrhost(var.hub_vnet_address_space, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "gateway_subnet_address_space" {
  description = "Address space for GatewaySubnet (min /27 required)"
  type        = string
  default     = "10.0.0.0/27"
}

variable "firewall_subnet_address_space" {
  description = "Address space for AzureFirewallSubnet (min /26 required)"
  type        = string
  default     = "10.0.1.0/26"
}

variable "shared_services_subnet_address_space" {
  description = "Address space for shared services subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "deploy_firewall" {
  description = "Deploy Azure Firewall in hub"
  type        = bool
  default     = true
}

variable "firewall_sku_tier" {
  description = "Azure Firewall SKU tier (Standard or Premium)"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Standard", "Premium"], var.firewall_sku_tier)
    error_message = "Firewall SKU must be Standard or Premium."
  }
}

variable "deploy_log_analytics" {
  description = "Deploy Log Analytics workspace for monitoring"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Log Analytics retention in days"
  type        = number
  default     = 90
  
  validation {
    condition     = var.log_retention_days >= 30 && var.log_retention_days <= 730
    error_message = "Retention must be between 30 and 730 days."
  }
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
