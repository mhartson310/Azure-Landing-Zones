# Single-Region Landing Zone Example

Complete hub-spoke landing zone deployed in a single Azure region.

## What Gets Deployed

**Hub Infrastructure:**
- Hub VNet (10.0.0.0/16)
- Azure Firewall (Standard or Premium)
- Gateway Subnet (for ExpressRoute/VPN)
- Shared Services Subnet
- Log Analytics Workspace
- Diagnostic logging

## Prerequisites

1. **Azure CLI** installed and authenticated
```bash
   az login
   az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

2. **Terraform** >= 1.6.0 installed
```bash
   terraform --version
```

3. **Azure Permissions**
   - Contributor role (minimum)
   - Or Owner role (for RBAC assignments)

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/mhartson310/Azure-Landing-Zones.git
cd Azure-Landing-Zones/examples/single-region
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the plan

```bash
terraform plan
```

### 4. Deploy

```bash
terraform apply
```

**Deploy time:** ~45-60 minutes (mostly waiting for Firewall deployment)

### 5. Get outputs

```bash
terraform output
```

## Customization

### Option 1: Using .tfvars file

Create `terraform.tfvars`:

```hcl
environment = "prod"
location    = "westus2"

# Use your own IP space
hub_vnet_address_space = "10.100.0.0/16"
gateway_subnet_address_space = "10.100.0.0/27"
firewall_subnet_address_space = "10.100.1.0/26"
shared_services_subnet_address_space = "10.100.2.0/24"

# Premium firewall for TLS inspection
firewall_sku_tier = "Premium"

# Custom tags
common_tags = {
  Environment = "Production"
  CostCenter  = "IT-Infrastructure"
  Owner       = "CloudTeam"
  ManagedBy   = "Terraform"
}
```

Then deploy:
```bash
terraform apply -var-file="terraform.tfvars"
```

### Option 2: Using command-line variables

```bash
terraform apply \
  -var="environment=nonprod" \
  -var="location=eastus2" \
  -var="firewall_sku_tier=Standard"
```

### Option 3: Modify variables.tf defaults

Edit `variables.tf` and change the `default` values.

## Configuration Options

### Deploy without Firewall (Cost Savings)

```hcl
# In terraform.tfvars
deploy_firewall = false
```

**Saves:** ~$900-1,200/month

### Deploy without Log Analytics

```hcl
# In terraform.tfvars
deploy_log_analytics = false
```

**Saves:** ~$100-300/month

### Use Premium Firewall (FedRAMP/High Security)

```hcl
# In terraform.tfvars
firewall_sku_tier = "Premium"
```

**Additional cost:** ~$500-600/month
**Benefits:** TLS inspection, IDPS, URL filtering

## Cost Estimate

### Standard Configuration
| Component | Monthly Cost |
|-----------|-------------|
| Hub VNet | $0 |
| Azure Firewall Standard | $900-1,200 |
| Log Analytics | $100-300 |
| Storage | $20-50 |
| **TOTAL** | **$1,020-1,550** |

### Minimal Configuration (no firewall)
| Component | Monthly Cost |
|-----------|-------------|
| Hub VNet | $0 |
| Log Analytics | $100-300 |
| Storage | $20-50 |
| **TOTAL** | **$120-350** |

## Destroy Resources

```bash
# Review what will be deleted
terraform plan -destroy

# Destroy all resources
terraform destroy
```

**Warning:** This deletes everything. Make sure you have backups if needed.

## Next Steps

After deploying the hub:

1. **Add spoke networks** - See [spoke-network module](../../terraform/modules/spoke-network/)
2. **Configure firewall rules** - See [firewall module](../../terraform/modules/firewall/)
3. **Set up VPN/ExpressRoute** - Deploy gateway in GatewaySubnet
4. **Enable Sentinel** - Connect to Log Analytics workspace
5. **Deploy workloads** - Create spoke VNets and peer to hub

## Troubleshooting

### Error: "authorization failed"

**Solution:** Ensure you have Contributor or Owner role on the subscription

```bash
az role assignment list --assignee $(az account show --query user.name -o tsv)
```

### Error: "Firewall deployment timeout"

**Solution:** Firewall takes 30-45 minutes. This is normal. Wait and retry.

### Error: "Address space conflict"

**Solution:** Change `hub_vnet_address_space` to avoid conflicts with existing networks

### Error: "Quota exceeded"

**Solution:** Request quota increase for your subscription
```bash
az vm list-usage --location eastus2 -o table
```

## Support

- 📖 [Complete Implementation Guide](https://mhartson.com/insights/azure-landing-zones)
- 📥 [Free Starter Kit](https://mhartson.com/resources/starter-kit)
- 💬 [Community](https://hartson-security-guild.circle.so)
- 🚀 [Professional Services](https://mhartson.com/consulting)

## Related Examples

- [Multi-Region Example](../multi-region/) - Hub in multiple regions
- [FedRAMP-Ready Example](../fedramp/) - Compliance-hardened configuration
