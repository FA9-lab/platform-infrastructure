# Azure Linux VM — Day-2 Operating Model

**Capability:** Azure Linux Virtual Machine
**Owner:** Platform Engineering
**Status:** MVP

## 1. Operating Principles

1. Each generated deployment repository owns an independent
   Terraform root, remote state, and infrastructure lifecycle.

2. Platform Engineering owns the reusable Terraform module
   and shared GitHub Actions workflows.

3. Deployment repositories pin their Terraform module versions.
   Publishing a new module version does not automatically
   upgrade existing deployments.

4. Infrastructure changes are reviewed through the deployment
   repository's established GitHub workflow.

5. Azure Cloud Foundation owns landing-zone governance,
   networking foundations, and subscription-level controls.

6. Platform upgrades must account for compatibility,
   environment sequencing, and recovery from failure.
