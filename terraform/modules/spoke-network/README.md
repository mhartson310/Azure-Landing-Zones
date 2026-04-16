# Spoke Network Module

Deploys a spoke VNet with multi-tier architecture, NSGs, and peering to hub.

## Features

- **Multi-tier subnets** - Web, App, Data tiers
- **Network segmentation** - NSGs enforce tier-to-tier communication
- **Hub connectivity** - VNet peering with hub
- **Traffic inspection** - All traffic routed through hub firewall
- **Service endpoints** - For Azure PaaS services
- **Flexible configuration** - Enable/disable tiers as needed


## Architecture Overview

### Network Layout

| Component | CIDR | Purpose | Security |
|-----------|------|---------|----------|
| **Hub VNet** | 10.0.0.0/16 | Central connectivity | Azure Firewall for inspection |
| **Spoke VNet** | 10.X.0.0/16 | Workload isolation | Peered to hub only |
| └─ Web Subnet | 10.X.1.0/24 | Internet-facing apps | NSG: Allow 443, 80 from Internet |
| └─ App Subnet | 10.X.2.0/24 | Application logic | NSG: Allow from Web tier only |
| └─ Data Subnet | 10.X.3.0/24 | Databases | NSG: Allow SQL from App tier only |

### Traffic Routing

| Source | Destination | Path | Inspection |
|--------|-------------|------|------------|
| Internet | Web Tier | Internet → Firewall → Web | ✅ Inspected |
| Web Tier | App Tier | Web → App (direct) | ❌ Not inspected* |
| App Tier | Data Tier | App → Data (direct) | ❌ Not inspected* |
| Spoke A | Spoke B | Spoke A → Firewall → Spoke B | ✅ Inspected |
| Any Tier | Internet | Any → Firewall → Internet | ✅ Inspected |

*Within-VNet traffic is not inspected by firewall but is controlled by NSGs



# Spoke Network Architecture

```
┌────────────────────────────────────────────────────────────────────┐
│                         🌐 INTERNET                                │
└────────────────────────────┬───────────────────────────────────────┘
                             │
                             ▼
┌────────────────────────────────────────────────────────────────────┐
│                   🏢 HUB VNET (10.0.0.0/16)                        │
│                                                                    │ 
│        ┌──────────────────────────────────────────┐                │ 
│        │  🔥 Azure Firewall (10.0.1.4)            │                │
│        │  • Inspects all traffic                  │                │
│        │  • Spoke-to-spoke routing                │                │
│        │  • Internet egress                       │                │
│        └──────────────────────────────────────────┘                |
└────────────────────────────┬───────────────────────────────────────┘
                             │ VNet Peering
                             ▼
┌────────────────────────────────────────────────────────────────────┐
│               📦 SPOKE VNET (10.X.0.0/16)                          |
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  🌐 Web Tier Subnet (10.X.1.0/24)                            │  |
│  │  • Internet-facing applications                              │  │
│  │  NSG: ✅ HTTPS (443), HTTP (80) ❌ All other inbound        │  │
│  └────────────────────────┬─────────────────────────────────────┘  │
│                           │                                        │
│  ┌────────────────────────▼─────────────────────────────────────┐  │
│  │  ⚙️ App Tier Subnet (10.X.2.0/24)                           │   │
│  │  • Application logic and processing                          │  │
│  │  NSG: ✅ From Web tier only ❌ All other inbound            │  │
│  └────────────────────────┬─────────────────────────────────────┘  │
│                           │                                        │
│  ┌────────────────────────▼─────────────────────────────────────┐  │
│  │  🗄️ Data Tier Subnet (10.X.3.0/24)                          │   │
│  │  • Databases (SQL Server, MySQL, PostgreSQL)                 │  │
│  │  NSG: ✅ SQL ports from App only ❌ All other inbound       │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │  📋 Route Table (All Subnets)                                │  │
│  │  • 0.0.0.0/0 → 10.0.1.4 (Firewall)                           │  │
│  │  • Other Spoke VNets → 10.0.1.4 (Firewall)                   │  │
│  └──────────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────┘
```

     All subnets have User Defined Routes (UDRs):
     • Default route (0.0.0.0/0) → 10.0.1.4 (Firewall)
     • Other spokes → 10.0.1.4 (Firewall)


## Usage

### Basic Spoke (3-Tier)

```hcl
module "spoke_finance" {
  source = "../../terraform/modules/spoke-network"

  environment              = "prod"
  location                 = "eastus2"
  workload_name            = "finance"
  spoke_vnet_address_space = "10.1.0.0/16"

  # Subnets
  web_subnet_address_space  = "10.1.1.0/24"
  app_subnet_address_space  = "10.1.2.0/24"
  data_subnet_address_space = "10.1.3.0/24"

  # Hub connectivity
  hub_vnet_id              = module.hub_network.hub_vnet_id
  hub_vnet_name            = module.hub_network.hub_vnet_name
  hub_resource_group_name  = module.hub_network.resource_group_name
  firewall_private_ip      = module.hub_network.firewall_private_ip

  common_tags = {
    Environment = "Production"
    Workload    = "Finance"
  }
}
```

### Minimal Spoke (App Only)

```hcl
module "spoke_tools" {
  source = "../../terraform/modules/spoke-network"

  environment              = "prod"
  location                 = "eastus2"
  workload_name            = "devtools"
  spoke_vnet_address_space = "10.5.0.0/16"

  # Only app tier
  create_web_subnet  = false
  create_data_subnet = false
  app_subnet_address_space = "10.5.1.0/24"

  # Hub connectivity
  hub_vnet_id              = module.hub_network.hub_vnet_id
  hub_vnet_name            = module.hub_network.hub_vnet_name
  hub_resource_group_name  = module.hub_network.resource_group_name
  firewall_private_ip      = module.hub_network.firewall_private_ip

  common_tags = {
    Environment = "Production"
    Workload    = "DevTools"
  }
}
```

### Spoke with Routing to Other Spokes

```hcl
module "spoke_marketing" {
  source = "../../terraform/modules/spoke-network"

  environment              = "prod"
  location                 = "eastus2"
  workload_name            = "marketing"
  spoke_vnet_address_space = "10.2.0.0/16"

  web_subnet_address_space  = "10.2.1.0/24"
  app_subnet_address_space  = "10.2.2.0/24"
  data_subnet_address_space = "10.2.3.0/24"

  # Hub connectivity
  hub_vnet_id              = module.hub_network.hub_vnet_id
  hub_vnet_name            = module.hub_network.hub_vnet_name
  hub_resource_group_name  = module.hub_network.resource_group_name
  firewall_private_ip      = module.hub_network.firewall_private_ip

  # Route to other spokes via firewall
  other_spoke_address_spaces = {
    finance     = "10.1.0.0/16"
    engineering = "10.3.0.0/16"
  }

  common_tags = {
    Environment = "Production"
    Workload    = "Marketing"
  }
}
```

## Network Security

### Default NSG Rules

**Web Tier:**
- ✅ Allow HTTPS (443) from Internet
- ✅ Allow HTTP (80) from Internet
- ❌ Deny all other inbound

**App Tier:**
- ✅ Allow all from Web subnet only
- ❌ Deny all other inbound

**Data Tier:**
- ✅ Allow SQL ports (1433, 3306, 5432) from App subnet only
- ❌ Deny all other inbound

### Traffic Flow

All traffic is inspected by hub firewall:
- Spoke → Internet: Routes through firewall
- Spoke A → Spoke B: Routes through firewall
- Internet → Spoke: Through firewall (if allowed)

## Outputs

Key outputs for deploying workloads:

```hcl
# Deploy VMs/resources into subnets
resource "azurerm_network_interface" "web_vm" {
  subnet_id = module.spoke_finance.web_subnet_id
  # ...
}

# Reference NSGs for custom rules
resource "azurerm_network_security_rule" "custom" {
  network_security_group_name = module.spoke_finance.web_nsg_id
  # ...
}
```

## Cost

**Per spoke (monthly):**
- VNet: $0 (free)
- VNet peering: $10-50 (based on traffic)
- NSGs: $0 (free)
- Route tables: $0 (free)
- **Total: $10-50/month** (plus workload costs)

## Requirements

- Terraform >= 1.6.0
- Azure Provider >= 3.0
- Existing hub VNet deployed

## Notes

- Subnets use /24 by default (256 IPs each)
- Service endpoints enabled by default (Storage, SQL, KeyVault)
- Private endpoints enabled on data tier
- All outbound traffic routes through hub firewall


