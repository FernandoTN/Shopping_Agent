# Infrastructure, CI/CD & Release

## Objective
Reliable, reproducible environments and pipelines; fast, safe deploys with canaries and rollbacks.

## Infra
- Terraform (VPC, K8s, DBs, Redis, Search, Object storage)
- Helm charts per service; Kustomize overlays
- Env tiers: dev, staging, prod; feature flags

## CI/CD
- GitHub Actions: matrix builds (JS/TS, Python), caching
- Pipelines: lint → unit → contract → e2e → build → deploy (canary → full)
- Pact broker verify job gates merges on connector schema drift
- Playwright traces and headless artifacts saved as CI outputs

## Phase Plan
### Phase 1
- **1A**: Dev env bootstrap scripts; secrets wiring
- **1B**: Basic CI (lint/test) + preview deploys for web
- **1C**: Staging cluster; blue/green deploy BFF; feature flags

### Phase 2
- **2A**: Full CD to services with Argo Rollouts canary
- **2B**: Migrations automation (pre-deploy shadow)
- **2C**: Load tests & chaos in staging on schedule

### Phase 3
- **3A**: Multi-region DR; backups & restore drills
- **3B**: SBOM & supply-chain security (SLSA levels)
- **3C**: Cost budgets & alerts

## Risks
- Drift between envs → infra as code only; no manual changes
- Migration downtime → zero-downtime playbooks, shadow tables