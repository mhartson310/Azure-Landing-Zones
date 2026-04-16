# Azure Landing Zones - Production Terraform Modules

[![Terraform](https://img.shields.io/badge/Terraform-1.6+-623CE4?logo=terraform)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/Azure-Landing%20Zones-0078D4?logo=microsoft-azure)](https://azure.microsoft.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen.svg)](https://github.com/mhartson310/Azure-Landing-Zones)

Production-tested Terraform modules for deploying enterprise Azure landing zones. Based on 20+ real deployments for Fortune 500 companies and government agencies.

## 🎯 What This Is

**Real Terraform code** that deploys production-ready Azure landing zones following Microsoft's Cloud Adoption Framework (CAF) and enterprise best practices.

Not another "hello world" example. This is what I actually deploy for clients.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/mhartson310/Azure-Landing-Zones.git
cd Azure-Landing-Zones

# Deploy a single-region landing zone
cd examples/single-region
terraform init
terraform plan -var-file="production.tfvars"
terraform apply
```

**Deploy time:** 45-60 minutes for complete hub-spoke architecture

## 📦 What's Included

### Terraform Modules

- **[hub-network](terraform/modules/hub-network/)** - Hub VNet with firewall, gateway, shared services
- **[spoke-network](terraform/modules/spoke-network/)** - Spoke VNet with routing, NSGs, peering
- **[firewall](terraform/modules/firewall/)** - Azure Firewall with policies and rules
- **[policy](terraform/modules/policy/)** - Azure Policy baseline for governance
- **[management-groups](terraform/modules/management-groups/)** - Management group hierarchy

### Production Examples

- **[Single-Region](examples/single-region/)** - Hub + 3 spokes in one region
- **[Multi-Region](examples/multi-region/)** - Hub in 2 regions with global peering
- **[FedRAMP-Ready](examples/fedramp/)** - Compliance-hardened configuration

### Documentation

- **[Architecture Guide](docs/architecture-guide.md)** - Design decisions and patterns
- **[IP Planning](docs/ip-planning-guide.md)** - Address space strategy
- **[Deployment Checklist](docs/deployment-checklist.md)** - Step-by-step implementation
- **[Cost Estimation](docs/cost-estimation.md)** - Real-world pricing

## 🏗️ Architecture Overview
