# Payments & Wallet (Stripe Issuing)

## Objective
Enable Autopilot purchases via controlled **virtual cards** when checkout APIs are absent; avoid storing user PANs; strict spend and merchant controls.

## Modes
- API checkout (merchant handles payment) → store order refs only
- Autopilot Wallet: issue single-use card with MCC/amount caps; real-time auth webhooks

## Integration Points
- **Consumes**: checkout intents from `checkout` service
- **Produces**: `payment.authorization` events; card metadata for audit
- **Security**: token vault; field-level encryption; secret rotation
- **Compliance**: minimize PCI scope (no PAN storage); logging redaction

## Phase Plan
### Phase 1
- **1A**: Stripe Issuing setup; funding source; auth webhook handler
- **1B**: Spend controls per user & order; attach agent run ID
- **1C**: Dispute & refund flow documentation; user statements

### Phase 2
- **2A**: Merchant category allow/deny per user guardrails
- **2B**: Budget snapshots, weekly/monthly caps
- **2C**: Alerts on declines or anomalies

### Phase 3
- **3A**: Tokenization upgrades (network tokens when available)
- **3B**: Split tenders; partial refunds automation
- **3C**: Ledger exports to warehouse

## Tests
- Unit: auth handlers, control logic
- E2E: simulate auth/settlement webhooks
- Security: secret scanning, redaction tests

## Risks
- User confusion if agent-as-MOR used → clear receipts & order linking
- Fraud/abuse → 2FA approvals for high-risk orders