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

## 2. Operational Ownership

| Activity | Accountable Owner | Supporting Team |
|---|---|---|
| Terraform module maintenance and releases | Platform Engineering | Azure Cloud Foundation |
| Reusable workflow maintenance and releases | Platform Engineering | Security |
| Deployment version visibility | Platform Engineering | Deployment Owners |
| Upgrade compatibility assessment | Platform Engineering | Deployment Owners |
| Application-specific upgrade scheduling | Deployment Owner | Platform Engineering |
| Deployment change execution | Deployment Owner | Platform Engineering |
| Shared module or workflow defect resolution | Platform Engineering | Deployment Owner |
| Deployment-specific configuration troubleshooting | Deployment Owner | Platform Engineering |
| Landing-zone networking and policy troubleshooting | Azure Cloud Foundation | Platform Engineering |
| Critical security upgrade coordination | Platform Engineering | Security and Deployment Owners |

### Upgrade Responsibility

Platform Engineering publishes supported module and workflow
versions, communicates compatibility and security implications,
and coordinates upgrades when necessary.

Deployment owners review and execute changes within their
deployment repositories, following the established approval
and environment-promotion process.

Publishing a new shared module version does not automatically
modify existing deployments.

### Current MVP Limitation

The platform does not yet maintain a centralized inventory
of module versions consumed by deployment repositories.

Until automated inventory is introduced, version visibility
requires inspection of deployment repository configuration.

## 3. Incident Routing and Escalation

### Initial Triage

The deployment owner begins triage using the failed GitHub Actions
run, Terraform error output, and deployment repository configuration.

The issue is routed according to the underlying failure domain,
not merely the tool where the error appeared.

### Failure Ownership

| Failure Domain | Primary Owner |
|---|---|
| Deployment-specific inputs or configuration | Deployment Owner |
| Shared Terraform module defect | Platform Engineering |
| Reusable GitHub Actions workflow defect | Platform Engineering |
| Azure networking or landing-zone configuration | Azure Cloud Foundation |
| Azure Policy enforcement or policy assignment | Azure Cloud Foundation |
| Platform-managed GitHub OIDC configuration | Platform Engineering, with Identity/Security support |

### Escalation Procedure

1. Record the affected deployment repository and workflow run.
2. Capture the relevant error without exposing credentials or secrets.
3. Identify whether the failure is deployment-specific or shared.
4. Route the incident to the responsible team.
5. Document the resolution and any required platform changes.
6. Retry through the approved deployment lifecycle.

### Operational Safeguards

- Do not bypass Azure Policy or GitHub approval controls.
- Do not manually edit Terraform state as a routine recovery method.
- Do not rerun destructive operations without reviewing their impact.
- Escalate failures affecting multiple deployments as potential
  shared-platform incidents.
