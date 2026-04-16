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

variable "workload_name" {
  description = "Workload identifier (e.g., finance, marketing, web)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.workload_name))
    error_message = "Workload name must be lowercase alphanumeric with hyphens only."
  }
}

variable "spoke_vnet_address_space" {
  description = "Address space for spoke VNet (e.g., 10.1.0.0/16)"
  type        = string

  validation {
    condition     = can(cidrhost(var.spoke_vnet_address_space, 0))
    error_message = "Must be a valid CIDR block."
  }
}

# Subnet Configuration
variable "create_web_subnet" {
  description = "Create web/frontend subnet"
  type        = bool
  default     = true
}

variable "web_subnet_address_space" {
  description = "Address space for web subnet"
  type        = string
  default     = ""
}

variable "create_app_subnet" {
  description = "Create app/logic subnet"
  type        = bool
  default     = true
}

variable "app_subnet_address_space" {
  description = "Address space for app subnet"
  type        = string
  default     = ""
}

variable "create_data_subnet" {
  description = "Create data/database subnet"
  type        = bool
  default     = true
}

variable "data_subnet_address_space" {
  description = "Address space for data subnet"
  type        = string
  default     = ""
}

variable "service_endpoints" {
  description = "Service endpoints to enable on subnets"
  type        = list(string)
  default     = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
}

# Hub Connectivity
variable "hub_vnet_id" {
  description = "Hub VNet resource ID"
  type        = string
}

variable "hub_vnet_name" {
  description = "Hub VNet name"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Hub resource group name"
  type        = string
}

variable "firewall_private_ip" {
  description = "Azure Firewall private IP (for UDRs)"
  type        = string
}

variable "use_remote_gateway" {
  description = "Use hub VPN/ExpressRoute gateway"
  type        = bool
  default     = false
}

variable "hub_has_gateway" {
  description = "Hub has VPN/ExpressRoute gateway deployed"
  type        = bool
  default     = false
}

# Routing to Other Spokes
variable "other_spoke_address_spaces" {
  description = "Map of other spoke VNets (name => CIDR) for routing through firewall"
  type        = map(string)
  default     = {}
}

variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
