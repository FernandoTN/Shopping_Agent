# Shopping Agent — System Architecture

## Holistic Objective (project-wide)
Deliver a seamless, agent-powered shopping experience: the user prompts, we search, normalize, compare, and either guide the user (Assist) or execute purchases (Autopilot) via **direct merchant APIs first**, with a **policy-aware headless fallback**. We keep orders, tracking, payments, and guardrails centralized and auditable.

## High-level Components
- **Frontends**: Web (Next.js) and Mobile (React Native)
- **GraphQL BFF**: Client-optimized API, aggregation, and streaming of agent events
- **Core Services** (FastAPI):
  - Agent Orchestrator, Discovery, Normalize, Offer Ranking
  - Checkout Orchestrator, Integrations, Headless Runner
  - Payments & Wallet, Orders & Tracking, Fraud, Notifications
- **Platform**: Data layer, Observability, Security, QA frameworks
- **Infra**: IaC (Terraform), K8s, GitHub Actions, Helm, Feature Flags

## Integration Spine (how everything connects)
- **Clients ↔ BFF**: GraphQL over HTTPS + WebSockets for live agent steps
- **BFF ↔ Services**: gRPC/HTTP (internal), JSON schemas; idempotent POST for actions
- **Services ↔ Data**: Postgres (OLTP), Redis (cache), OpenSearch (text), pgvector (semantic), S3 (artifacts)
- **Services ↔ External Vendors**:
  - Direct Checkout: Violet, Firmly, eBay, Shopify (per-store), BigCommerce
  - Headless: Browserless/Apify
  - Payments: Stripe Issuing
  - Tracking: EasyPost/Shippo

## Events (Kafka/Redpanda core topics)
- `agent.run.started/finished`
- `offer.evaluated`
- `checkout.path.selected` (API | DEEPLINK | HEADLESS)
- `order.created/updated`
- `payment.authorization`
- `tracking.update`

## Non-Functional Targets
- Availability 99.9% core APIs; p95 Prompt→first offers ≤ 4s
- Strong observability (OTEL) with SLO burn alerts
- Security: OIDC, tokenization, PII field encryption, allowlisted headless domains

## Phase Roadmap Overview
- **Phase 1**: API-first integrations (Violet/eBay/Shopify-per-store), minimal headless fallback, Stripe Issuing for Autopilot on guest checkout.
- **Phase 2**: Broaden merchant coverage (Firmly + more stores), robust connector contract-tests, deeper order lifecycle automation.
- **Phase 3**: Payments tokenization upgrades, standards alignment, scale infra, advanced fraud & experimentation.

See component playbooks for details.