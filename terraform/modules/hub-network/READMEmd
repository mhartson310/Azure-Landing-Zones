# Hub Network Module

Deploys the hub network infrastructure for an Azure landing zone.

## What Gets Deployed

- **Hub VNet** with customizable address space
- **Gateway Subnet** for ExpressRoute/VPN connectivity
- **Azure Firewall Subnet** for centralized traffic inspection
- **Shared Services Subnet** for DNS, domain controllers, jump boxes
- **Azure Firewall** (optional, enabled by default)
- **Log Analytics Workspace** (optional, for monitoring)
- **Diagnostic Settings** for firewall logging

## Usage

### Basic Hub (No Firewall)

```hcl
module "hub_network" {
  source = "../../terraform/modules/hub-network"

  environment            = "prod"
  location               = "eastus2"
  hub_vnet_address_space = "10.0.0.0/16"
  deploy_firewall        = false
  
  common_tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

### Production Hub (With Firewall & Monitoring)

```hcl
module "hub_network" {
  source = "../../terraform/modules/hub-network"

  environment            = "prod"
  location               = "eastus2"
  hub_vnet_address_space = "10.0.0.0/16"
  
  deploy_firewall       = true
  firewall_sku_tier     = "Premium"  # or "Standard"
  
  deploy_log_analytics  = true
  log_retention_days    = 90
  
  common_tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    CostCenter  = "IT-Infrastructure"
  }
}
```

## Outputs

Use these outputs to connect spoke networks:

```hcl
# In spoke network module
module "spoke_finance" {
  source = "../../terraform/modules/spoke-network"
  
  hub_vnet_id         = module.hub_network.hub_vnet_id
  firewall_private_ip = module.hub_network.firewall_private_ip
  # ... other variables
}
```

## Cost Estimate

**Monthly cost (Standard Firewall):**
- Hub VNet: $0 (free)
- Azure Firewall Standard: $900-1,200
- Log Analytics: $100-300 (depends on ingestion)
- Storage (diagnostics): $20-50
- **Total: ~$1,100-1,600/month**

**Monthly cost (Premium Firewall):**
- Azure Firewall Premium: $1,400-1,800 (base + data)
- Other costs same as above
- **Total: ~$1,600-2,200/month**

## Requirements

- Terraform >= 1.6.0
- Azure Provider >= 3.0
- Azure subscription with appropriate permissions

## Notes

- **GatewaySubnet** and **AzureFirewallSubnet** names are Azure requirements - do not change
- Minimum subnet sizes: GatewaySubnet /27, AzureFirewallSubnet /26
- Firewall private IP is used in spoke UDRs to route traffic through firewall
