# Security & Compliance

## Objective
Protect users and partners: least privilege, encrypted data, compliance-by-design, and transparent audit trails.

## Controls
- OIDC auth; JWT rotation; device binding for Autopilot
- Secrets in Vault/KMS; key rotation
- PII classification; field encryption; log redaction
- Headless allowlist; no evasion techniques
- RBAC/ABAC for admin surfaces

## Phase Plan
### Phase 1
- **1A**: Threat model; security headers; dependency scanning
- **1B**: Secret handling; logging redaction; audit trails for agent actions
- **1C**: DPA & privacy notice; consent for email scraping (if enabled)

### Phase 2
- **2A**: SAST/DAST pipelines; bug bounty prep
- **2B**: Hardening guides; CIS benchmarks
- **2C**: Data retention policies & automated purge jobs

### Phase 3
- **3A**: PCI-SAQ posture review; payments repo split if needed
- **3B**: SOC2 program groundwork
- **3C**: Vendor risk reviews

## Tests
- Security unit tests (authz, ABAC)
- ZAP/DAST scans in CI
- Secret scanner enforced pre-merge

## Risks
- TOS missteps → policy gates & reviews
- Over-collection of data → minimization & opt-ins