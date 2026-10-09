# Azure Linux VM — Platform Capability Contract

**Capability:** Azure Linux Virtual Machine  
**Contract version:** 1.0  
**Owner:** Platform Engineering  
**Status:** MVP

## 1. Purpose

Provide a standardized, self-service Azure Linux VM deployment
through the Internal Developer Platform (IDP).

Consumers request infrastructure through Backstage. The platform
generates a dedicated GitHub deployment repository that manages
the infrastructure lifecycle through Terraform and GitHub Actions.

## 2. Consumer Inputs

| Input | Required | Description |
|---|---|---|
| application | Yes | Application or workload name |
| environment | Yes | Deployment environment: dev, test, or prod |
| requestId | Yes | Request or change identifier |
| region | Yes | Azure deployment region |
| resourceGroup | Yes | Target Azure resource group |
| subnetId | Yes | Existing Azure subnet resource ID |
| vmSize | Yes | Azure VM SKU |
| adminSshPublicKey | Yes | SSH public key for administrative access |

Supported regions and VM SKUs are currently defined by the
Backstage template.

## 3. Platform-Generated Values

The platform generates and manages:

- A unique six-character deployment ID.
- A canonical deployment name.
- A dedicated GitHub deployment repository.
- Terraform configuration referencing a pinned capability version.
- GitHub Actions workflows for infrastructure lifecycle operations.
- A unique Terraform remote-state key.

These implementation details are not supplied by the consumer.

## 4. Deployment Outputs

The initial Backstage request returns a link to the generated
GitHub deployment repository.

Infrastructure execution results are available through GitHub
Actions and Terraform outputs.

The MVP does not currently provide a unified deployment-status
interface in Backstage.

## 5. Supported Lifecycle Operations

| Operation | Current Interface |
|---|---|
| Request deployment | Backstage Scaffolder |
| Provision infrastructure | GitHub Actions Apply workflow |
| Review infrastructure changes | Pull request and Terraform Plan |
| Apply approved changes | Merge to main |
| Upgrade capability version | Update pinned Terraform module reference |
| Plan decommission | GitHub Actions Decommission Plan |
| Decommission infrastructure | GitHub Actions Decommission workflow |

Initial provisioning currently requires a repository change
to initiate the existing PR-based Plan and merge-based Apply
sequence. Automatic initial provisioning is a planned enhancement.

## 6. Versioning and Compatibility

The platform distinguishes between:

1. **Capability contract version:** The consumer-facing inputs,
   outputs, and lifecycle expectations.
2. **Terraform module version:** The implementation of Azure
   resources, pinned by each deployment repository.
3. **Workflow version:** The reusable GitHub Actions implementation
   referenced by generated deployment repositories.

A Terraform module release does not automatically change the
consumer-facing capability contract.

Breaking changes to required inputs, their meanings, or
documented lifecycle behavior require a contract compatibility
review and an explicit migration strategy.

## 7. Ownership Boundaries

| Component | Owner | Responsibility |
|---|---|---|
| Backstage capability interface | Platform Engineering | Request experience and template |
| Generated deployment repository | Deployment owner | Deployment configuration and change history |
| Reusable GitHub workflows | Platform Engineering | Terraform execution and lifecycle automation |
| Terraform VM module | Platform Engineering | Standardized VM implementation |
| Azure landing zone | Azure Cloud Foundation | Subscriptions, networking, policy, and cloud governance |

## 8. Current MVP Limitations

- Azure resource selections use static template options or
  consumer-provided resource identifiers.
- Enterprise identity-based authorization is not implemented.
- Initial provisioning is not automatically triggered by Backstage.
- Deployment status is viewed through GitHub Actions.
- Resource eligibility is not dynamically resolved from a
  governed Azure inventory.

These are documented limitations, not guarantees of future
implementation details.
