# Azure Landing Zones — Terraform Reference

A focused Azure landing-zone implementation demonstrating **hub-and-spoke network design**, reusable Terraform modules, and infrastructure review before deployment.

> **Project status:** Reference implementation. No production deployment or live test result is claimed by this repository.

## Automated checks

[![Terraform checks](https://github.com/mhartson310/Azure-Landing-Zones/actions/workflows/terraform-validation.yml/badge.svg)](https://github.com/mhartson310/Azure-Landing-Zones/actions/workflows/terraform-validation.yml)

Terraform formatting, initialization, and validation run in GitHub Actions. **This does not prove Azure deployment or security-control operation.**

## What this demonstrates

- Infrastructure architecture decomposed into reusable hub and spoke modules
- Terraform composition through an example deployment
- Azure network design, configurable inputs, and output contracts
- A foundation for security controls, governance, and platform expansion

## Problem

Cloud teams need consistent platform and network foundations rather than one-off resources built in the portal.

## Architecture and trust boundaries

The example uses a hub-and-spoke pattern. Review network routing, segmentation, privileged access, and shared-service trust boundaries before adapting it to a real environment.

## Implementation

- [Single-region example](examples/single-region/README.md) and [Terraform entry point](examples/single-region/main.tf)
- [Hub network module](terraform/modules/hub-network)
- [Spoke network module](terraform/modules/spoke-network)

Review all input variables and expected cost before applying. The repository does **not** presently contain a complete enterprise landing-zone deployment covering every Cloud Adoption Framework capability.

## Threats and controls to evaluate

- Unintended connectivity or lateral movement between spokes
- Broad permissions on network administration
- Missing policy and resource-organization guardrails
- Incomplete logging or change detection

## Deployment and validation

Start with `terraform fmt -check`, `terraform init`, `terraform validate`, and `terraform plan` inside the example directory. Treat any successful local validation or Azure deployment as new evidence to document; none is asserted here.

## Monitoring

For security monitoring and response patterns, see the [Zero Trust reference architecture](https://github.com/mhartson310/Azure-Zero-Trust-Reference-Architectures) and [Sentinel detection library](https://github.com/mhartson310/Sentinel-KQL-Library).

## Portfolio connections

[Secure enterprise RAG](https://github.com/mhartson310/Azure-Secure-Enterprise-RAG) · [FedRAMP control patterns](https://github.com/mhartson310/FedRAMP-Azure-Toolkit) · [Azure cost optimization](https://github.com/mhartson310/Azure-Cost-Optimization-Toolkit)

**Implementation note:** Reference code is supplied as-is. Validate dependencies, security, budget, and Azure resource changes in a disposable environment before production use.
