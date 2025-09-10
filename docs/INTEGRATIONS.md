# Integrations (Direct Merchant APIs)

## Objective
API-first checkout coverage via stable vendors and platform partners; minimize scraping reliance.

## Phase-1 Vendors
- **Violet**: unified checkout across many platforms
- **eBay Buy APIs**: browse, cart, checkout
- **Shopify** (per-store app): Storefront checkout sessions
- **BigCommerce** (per-store): Storefront/GraphQL carts & checkout
- (Phase 2) **Firmly**: real-time merchant integration hub

## Connector Design
- Standardized interface: `createCart`, `setShipping`, `applyPromo`, `quoteTotals`, `placeOrder`, `webhookParse`
- Error taxonomy mapped to BFF errors (insufficient inventory, address invalid, payment required)
- Secrets via Vault/KMS; per-merchant config in Postgres

## Webhooks
- Order created/updated, shipment created, cancellation, refund
- Verify signatures; idempotency keys; DLQ on failure

## Phase Plan
### Phase 1
- **1A**: Violet + eBay connector clients + sandbox tests
- **1B**: Shopify per-store app flow; app install UX; store tokens
- **1C**: BigCommerce connector; common cart model + mapping

### Phase 2
- **2A**: Firmly onboarding; webhook ingestion
- **2B**: Capability registry (per domain): API/DEEPLINK/HEADLESS
- **2C**: Order edits (if supported), split shipments

### Phase 3
- **3A**: Additional marketplaces; SLA monitors per connector
- **3B**: Auto-retry & circuit breakers
- **3C**: Contract test suites nightly + sandbox drift checks

## Tests
- Pact/contract tests against mocked vendor endpoints
- Live sandbox tests gated by secrets
- Replay runner for webhook payloads

## Risks
- Store installation churn → monitoring & re-auth flows
- Different tax/ship models → normalization layer