# Backend Core Services (Python / FastAPI)

## Objective
Modular, observable microservices for agent planning, discovery, normalization, ranking, checkout, orders, fraud, notifications.

## Services & Purpose
- **agent**: plan tool calls; enforce guardrails; action ledger (replay); *Phase 1 evaluation: LangGraph vs custom orchestration*
- **discovery**: SERP + crawl; HTML → structured JSON via extractors
- **normalize**: canonical product schema; taxonomy; dedupe
- **offer**: score & rank (price, ship/tax, ETA, returns, trust); explainers
- **checkout**: decide path (API/DEEPLINK/HEADLESS); orchestrate carts/orders
- **integrations**: house vendor clients; webhook receivers
- **headless**: job API to run Browserless/Apify scripts; trace artifacts
- **orders**: aggregate order refs; normalize tracking; returns assistance
- **payments**: wallet proxy for Stripe Issuing (authorize/capture/limits)
- **fraud**: rules signals; 2FA approval on risky autopilot
- **notifications**: email/push with idempotent handlers

## Integration Points
- DB: Postgres, Redis
- Search: OpenSearch; pgvector
- Object store: HTML snapshots, headless traces, receipts
- Event bus: Kafka topics listed in ARCHITECTURE.md
- External vendors: connectors (see INTEGRATIONS.md), payments, tracking

## Phase Plan
### Phase 1
- **1A**: agent, discovery, normalize, offer (MVP paths, JSON schemas)
- **1B**: checkout (API + deeplink), integrations: Violet + eBay + Shopify-per-store; payments issuing proxy
- **1C**: orders (tracking via aggregator), notifications; allowlisted headless runner (demo sites)
- **1D**: LangChain evaluation (PoC agent orchestration with LangGraph; performance benchmark vs custom implementation)

### Phase 2
- **2A**: Integrations: Firmly; BigCommerce; connector webhooks
- **2B**: Returns workflow; price alerts; richer explainability
- **2C**: Fraud features (velocity, device signals); 2FA approvals

### Phase 3
- **3A**: Workflow engine (Temporal) for long-running orders
- **3B**: Advanced ranking experiments; counterfactuals
- **3C**: Email receipt ingestion (opt-in) → order linking

## Tests
- Pytest with ≥90% on extractors & pricing math
- Property-based tests (Hypothesis) for parsers & totals
- Pact tests for each connector client
- Temporal/Persistence replay tests (when added)

## Risks
- Crawl variability → hybrid extraction with strict schemas
- External API quotas → rate limiting & backoff