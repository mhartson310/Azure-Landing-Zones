variable "environment" {
  description = "Environment name (prod, nonprod, dev)"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "eastus2"
}

variable "hub_vnet_address_space" {
  description = "Hub VNet address space"
  type        = string
  default     = "10.0.0.0/16"
}

variable "gateway_subnet_address_space" {
  description = "Gateway subnet address space"
  type        = string
  default     = "10.0.0.0/27"
}

variable "firewall_subnet_address_space" {
  description = "Firewall subnet address space"
  type        = string
  default     = "10.0.1.0/26"
}

variable "shared_services_subnet_address_space" {
  description = "Shared services subnet address space"
  type        = string
  default     = "10.0.2.0/24"
}

variable "deploy_firewall" {
  description = "Deploy Azure Firewall"
  type        = bool
  default     = true
}

variable "firewall_sku_tier" {
  description = "Azure Firewall SKU (Standard or Premium)"
  type        = string
  default     = "Standard"
}

variable "deploy_log_analytics" {
  description = "Deploy Log Analytics workspace"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Log Analytics retention in days"
  type        = number
  default     = 90
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "Azure-Landing-Zone"
  }
}
