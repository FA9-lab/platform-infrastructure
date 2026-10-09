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

## 4. Platform Release Management

### Independently Versioned Components

The Azure VM capability depends on two independently released
shared components:

1. Terraform VM module, maintained in platform-infrastructure.
2. Reusable GitHub Actions workflows, maintained in platform-workflows.

Each component has its own release history and compatibility
assessment.

### Release References

Production deployment repositories must reference immutable
Terraform module releases and controlled workflow releases.

Feature branches and moving branches such as main are not
approved production release references.

Terraform modules are referenced using release tags.
Reusable workflows should be referenced using immutable
commit SHAs, with versioned release tags used for discovery
and release documentation.

### Versioning Policy

Shared components follow semantic versioning:

- PATCH: Backward-compatible defect corrections.
- MINOR: Backward-compatible enhancements.
- MAJOR: Breaking changes requiring consumer action.

Version classification must consider deployment impact,
not only source-code compatibility.

A release that changes Terraform resource identity or causes
resource replacement requires explicit impact documentation,
even when the module input interface remains compatible.

### Release Requirements

Before publishing a shared component release:

1. Review the changes and compatibility implications.
2. Run appropriate automated validation.
3. Document expected infrastructure or execution impact.
4. Record any migration or rollback requirements.
5. Publish release notes and an immutable release reference.

### Consumer Upgrade Policy

Publishing a shared release does not automatically upgrade
existing deployment repositories.

Deployment owners adopt new versions through reviewed changes,
using the established Terraform Plan and Apply process.

Critical security releases may require coordinated upgrade
deadlines and escalation, but do not silently modify
deployment repositories.

### Current MVP Exceptions

Existing deployment repositories reference reusable workflows
through a mutable feature branch.

This is accepted for the lab but must be corrected before
production adoption.

The unreleased Terraform tag enhancement merged during Lab 8
requires validation before a new module release is published.

## 5. Reusable Workflow Release Management

### Current State

Generated deployment repositories currently reference reusable
GitHub Actions workflows using the mutable branch
`feature/deployment-repo-plan`.

This is a lab-only configuration and is not an approved
production release strategy.

### Target State

Platform Engineering publishes reviewed workflow releases
from the platform-workflows repository.

Each workflow release must:

1. Identify a specific reviewed Git commit.
2. Pass applicable workflow validation and testing.
3. Document compatibility with generated deployment repositories.
4. Include release notes and upgrade instructions.
5. Provide an immutable commit SHA for consumers.

### Consumer References

Production deployment repositories reference reusable workflows
using full Git commit SHAs.

Human-readable release tags are maintained for release discovery
and documentation.

Workflow upgrades require reviewed changes to the caller
repository. Publishing a new workflow release does not
automatically change existing caller references.

### Workflow Compatibility

A workflow release must assess changes to:

- Required workflow inputs and secrets.
- GitHub permissions and OIDC authentication.
- Terraform initialization and execution behavior.
- Plan, Apply, and Destroy lifecycle semantics.
- Expected outputs and failure handling.

Breaking changes require an explicit migration plan.

### Current Migration Requirement

Before production adoption, replace mutable workflow branch
references in generated deployment repositories and Backstage
skeleton workflows with references to reviewed release SHAs.

Existing lab repositories are not modified as part of this
documentation exercise.
