## Project Context — Objective & Architecture (Quick Start)

**Main Objective.** Deliver a seamless, agent-powered shopping experience: the user prompts, we search, normalize, compare, and either guide the user (Assist) or execute purchases (Autopilot) via **direct merchant APIs first**, with a **policy‑aware headless fallback**. We keep orders, tracking, payments, and guardrails centralized and auditable.

**What “seamless” means in practice**
- API-first checkout via merchant/platform connectors (Violet, eBay Buy, Shopify per‑store, BigCommerce); fall back to deep‑links; last resort: allowlisted headless automation.
- Guardrails: budgets, allowed merchants, spend caps, risk-based approvals.
- One consistent Orders hub with tracking/returns across all paths.
- Full observability (OTEL), strict security (OIDC, secrets/KMS, PII redaction), and test‑first development.

**System at a glance**
- **Clients:** Web (Next.js) and Mobile (React Native) with shared design system.
- **API Edge:** GraphQL BFF (persisted queries, WS events).
- **Core Services (FastAPI):** Agent Orchestrator, Discovery/Extraction, Catalog Normalizer, Offer Ranking, Checkout Orchestrator, Integrations, Headless Runner, Payments & Wallet, Orders & Tracking, Fraud, Notifications.
- **Checkout Paths (priority):** API → Deep‑link → Headless (Browserless/Apify).
- **Payments:** Stripe Issuing virtual cards for Autopilot guest flows; future network tokens.
- **Data Platform:** Postgres, Redis, OpenSearch, pgvector, S3/GCS, Warehouse.
- **Observability & Events:** OTEL traces/logs/metrics; Kafka/Redpanda topics for runs, orders, payments, tracking.
- **Security & Governance:** OIDC, allowlisted headless domains, policy gates, PCI‑minimized, SOC2-ready.

**Key flows**
1. **Prompt → Offers:** search/crawl → extract → normalize → compare & rank (with explainers and citations).
2. **Cart → Checkout:** Universal cart; Orchestrator chooses **API/DEEPLINK/HEADLESS**; Autopilot uses Payments service; Assist hands off gracefully.
3. **Post‑purchase:** Orders/Tracking aggregation; Returns/RMA; notifications.
4. **Quality loop:** Contract tests for connectors, E2E for each path, dashboards & SLOs, canaries & rollbacks.

_For deeper context, see `docs/ARCHITECTURE.md` and the component playbooks listed below._

# TODO — Program Roadmap & Execution Guide

**Purpose.** This document is the *single source of truth* for “what’s next.”  
It translates the architecture and component playbooks into a phased, cross‑functional plan with clear sub‑phases, owners, dependencies, acceptance criteria, and links to the relevant deep‑dive docs for context.

> **How to use this file**
> - Before starting any task, **read the referenced playbook(s)** to understand context and interfaces.
> - Track progress with the checkboxes below; open a GitHub Issue for each task and link back here.
> - Keep statuses up to date (🔴 planned, 🟡 in progress, 🟢 done, ⚠️ blocked).
> - Treat each **Sub‑Phase** as a milestone with a go/no‑go review.

**Key references (read as needed while executing):**  
- `docs/ARCHITECTURE.md` — system overview, integration spine, NFRs  
- `docs/FRONTEND.md` — Web app scope & phases  
- `docs/MOBILE.md` — React Native app scope & phases  
- `docs/BFF_API.md` — GraphQL facade, schema, contracts  
- `docs/BACKEND_SERVICES.md` — Python services & responsibilities  
- `docs/INTEGRATIONS.md` — Vendor connectors (Violet, eBay, Shopify, BigCommerce, Firmly)  
- `docs/HEADLESS_RUNNER.md` — Browserless/Apify fallback, policy gates  
- `docs/PAYMENTS_WALLET.md` — Stripe Issuing, spend controls  
- `docs/DATA_PLATFORM.md` — DB schemas, indexes, DQ  
- `docs/OBSERVABILITY_SRE.md` — OTEL, SLOs, dashboards, runbooks  
- `docs/SECURITY_COMPLIANCE.md` — AuthZ, secrets, PII, policies  
- `docs/INFRA_CICD.md` — Terraform/K8s, CI/CD, canaries, rollbacks

---

## Legend & Conventions

- Status: 🔴 planned · 🟡 in progress · 🟢 done · ⚠️ blocked  
- Owner: `@github-handle` (assign one DRI per sub‑phase)  
- Links: Always consult the listed **Playbooks** before coding.

---

## Phase 0 — Foundation & Bootstrap (weeks 0–2)

> **Goal:** Ship a working monorepo skeleton, CI basics, security & observability baselines so teams can implement Phase‑1 features safely.  
> **Read first:** `ARCHITECTURE.md`, `INFRA_CICD.md`, `SECURITY_COMPLIANCE.md`, `OBSERVABILITY_SRE.md`

### 0A. Monorepo & Toolchain
Status: 🔴 Owner: @tbd  
Playbooks: `ARCHITECTURE.md`, `INFRA_CICD.md`

- [ ] Create monorepo structure under `/apps`, `/services`, `/platform`, `/infra`, `/docs` (Owner) — Links: `ARCHITECTURE.md#Monorepo folder layout`
- [ ] Configure **pnpm** workspaces (JS/TS) and **Poetry** templates (Python) (Owner)
- [ ] Add **CODEOWNERS**, PR templates, issue templates, labels/milestones (Owner)
- [ ] Pre‑commit hooks: lint/format/secret‑scan (Owner)

**Exit / Acceptance**
- Repo boots locally via `make bootstrap` and `make dev`.
- Sample service and app build green in CI.

---

### 0B. Security Baseline
Status: 🔴 Owner: @tbd  
Playbooks: `SECURITY_COMPLIANCE.md`

- [ ] OIDC auth skeleton (web + BFF), JWT verification middleware (Owner)
- [ ] Secrets management stub (Vault/KMS integration; dev env secrets strategy) (Owner)
- [ ] PII taxonomy & log‑redaction utilities wired (Owner)

**Exit**
- Authn round‑trip demonstrated in dev; secrets pulled via approved mechanism; logs show no raw PII.

---

### 0C. Observability Baseline
Status: 🔴 Owner: @tbd  
Playbooks: `OBSERVABILITY_SRE.md`

- [ ] OTEL SDK in BFF and one Python service; traces visible in Grafana (Owner)
- [ ] Base dashboards: latency, error rate, request volume (Owner)
- [ ] SLOs drafted: BFF availability, search latency (Owner)

**Exit**
- End‑to‑end trace from web → BFF → service visible; SLO alert routes configured.

---

### 0D. Infra & CI/CD Bootstrap
Status: 🔴 Owner: @tbd  
Playbooks: `INFRA_CICD.md`

- [ ] Terraform scaffold + remote state; dev K8s cluster (Owner)
- [ ] GitHub Actions: lint, unit test, build caches; artifact storage (Owner)
- [ ] Helm chart skeleton per service; dev namespace deploy (Owner)

**Exit**
- CI green on a sample change; dev env auto‑deploy works.

---

## Phase 1 — API‑First MVP w/ Policy‑Aware Fallback (weeks 2–10)

> **Goal:** Deliver a usable MVP: discovery → compare → **API checkout** (Violet/eBay/Shopify‑per‑store) with **headless fallback** behind flags, Stripe Issuing for Autopilot in guest flows, and unified tracking.  
> **Read before each sub‑phase:** referenced playbooks for context & interfaces.

### 1A. Frontend MVP (Web)
Status: 🔴 Owner: @tbd  
Playbooks: `FRONTEND.md`, `BFF_API.md`

- [ ] Prompt/chat canvas with streamed agent events & citations (Owner) — Links: `FRONTEND.md#Phase 1`
- [ ] Results grid + comparison table + **capability badges** (API/DEEPLINK/HEADLESS) (Owner)
- [ ] Universal cart UI; guardrails panel (budget, merchants allowlist, Autopilot toggle) (Owner)
- [ ] Playwright E2E for Assist (deeplink) and API checkout paths (Owner)

**Exit**
- User can run a prompt → see offers → add to cart → checkout via API or deeplink.

---

### 1B. GraphQL BFF (Schema & Streaming)
Status: 🔴 Owner: @tbd  
Playbooks: `BFF_API.md`

- [ ] Implement schema: `searchOffers`, `buildComparison`, `cart`, `checkout`, `orders`, `merchantCapabilities` (Owner)
- [ ] WebSocket event stream for agent action updates (Owner)
- [ ] Persisted queries + rate limits; Redis response cache (Owner)

**Exit**
- Frontend consumes only BFF; schema snapshot locked; basic rate‑limit in place.

---

### 1C. Core Services (Agent, Discovery, Normalize, Offer)
Status: 🔴 Owner: @tbd  
Playbooks: `BACKEND_SERVICES.md`, `DATA_PLATFORM.md`

- [ ] **agent**: tool graph orchestrating search→extract→normalize→rank; action ledger persisted (Owner)
- [ ] **discovery**: SERP + crawl; HTML snapshots to S3; extraction to strict JSON (Owner)
- [ ] **normalize**: canonical product schema, taxonomy map, dedupe (Owner)
- [ ] **offer**: scoring (price+ship/tax+ETA+returns+trust) + explainers (Owner)
- [ ] Unit/property tests ≥90% for extractors + pricing math (Owner)

**Exit**
- For a test prompt, the pipeline returns ≥5 normalized offers within 12s p95.

---

### 1D. Integrations — **Violet & eBay** (plus Shopify per‑store)
Status: 🔴 Owner: @tbd  
Playbooks: `INTEGRATIONS.md`

- [ ] **Violet** connector: cart → shipping → totals → place order; sandbox E2E (Owner)
- [ ] **eBay Buy** connector: browse/cart/order; sandbox E2E (Owner)
- [ ] **Shopify per‑store**: app install flow + Storefront checkout session (Owner)
- [ ] Pact/contract tests for each connector; error taxonomy mapping (Owner)

**Exit**
- At least one real order (sandbox/prod test) succeeds via each API path.

---

### 1E. Checkout Orchestrator & Paths
Status: 🔴 Owner: @tbd  
Playbooks: `BACKEND_SERVICES.md`, `INTEGRATIONS.md`, `BFF_API.md`

- [ ] Decide path per merchant: **API → Deeplink → Headless**; persist choice (Owner)
- [ ] Universal cart model (per‑merchant) & totals; idempotent order submission (Owner)
- [ ] Error handling: inventory changed, address invalid, payment required (Owner)

**Exit**
- Orchestrator selects best path; retries/circuit breakers in place.

---

### 1F. Payments & Wallet (Stripe Issuing)
Status: 🔴 Owner: @tbd  
Playbooks: `PAYMENTS_WALLET.md`

- [ ] Stripe Issuing setup, funding source, auth webhook handler (Owner)
- [ ] Single‑use card per order with spend caps & merchant rules (flag‑gated) (Owner)
- [ ] E2E test: guest checkout (headless) using virtual card (Owner)

**Exit**
- Autopilot payment available for allowlisted merchants; logs redact PAN fully.

---

### 1G. Orders & Tracking
Status: 🔴 Owner: @tbd  
Playbooks: `BACKEND_SERVICES.md`, `DATA_PLATFORM.md`

- [ ] Persist external order refs (Violet/eBay/Shopify); status polling/webhooks (Owner)
- [ ] Carrier tracking via EasyPost/Shippo; normalized events to user (Owner)
- [ ] Notifications for placed/shipped/out‑for‑delivery (Owner)

**Exit**
- Orders hub shows end‑to‑end states; push/email notifications delivered.

---

### 1H. Headless Runner (Allowlisted)
Status: 🔴 Owner: @tbd  
Playbooks: `HEADLESS_RUNNER.md`

- [ ] Browserless integration; canonical “guest checkout” script (Owner)
- [ ] Screenshot & trace artifacts to S3; admin **allowlist UI** (Owner)
- [ ] Pause‑for‑human on CAPTCHA/2FA; fall back to deeplink (Owner)

**Exit**
- At least 3 allowlisted sites run to completion in staging; policy gate enforced.

---

### 1I. Data & Observability Enhancements
Status: 🔴 Owner: @tbd  
Playbooks: `DATA_PLATFORM.md`, `OBSERVABILITY_SRE.md`

- [ ] Postgres DDL + migrations; seed data; indexes (Owner)
- [ ] OpenSearch offer index; pgvector similarity (Owner)
- [ ] Dashboards: search latency, checkout success, headless success rate (Owner)

**Exit**
- Dashboards reflect live traffic; slow queries identified; indices in place.

---

### 1J. Security & Compliance
Status: 🔴 Owner: @tbd  
Playbooks: `SECURITY_COMPLIANCE.md`

- [ ] Headless policy enforcement (domain allowlist) (Owner)
- [ ] Log redaction + PII encryption fields; secrets rotation schedule (Owner)
- [ ] Basic DPA/privacy notice; consent toggles for email ingestion (if enabled) (Owner)

**Exit**
- Audit shows no PII leakage; policy violations blocked; documentation published.

---

### 1K. Launch & Canary
Status: 🔴 Owner: @tbd  
Playbooks: `INFRA_CICD.md`, `OBSERVABILITY_SRE.md`

- [ ] Canary deploy (5%) with SLO guardrails & auto‑rollback (Owner)
- [ ] Synthetic journey (Prompt→Order) monitors in prod (Owner)
- [ ] Runbooks for top 3 incidents (connector timeout, CAPTCHA stall, payment decline) (Owner)

**Exit**
- MVP live to internal/beta users; error budgets healthy for 1 week.

---

### 1L. LangChain Agent Orchestration Evaluation
Status: 🔴 Owner: @tbd  
Playbooks: `BACKEND_SERVICES.md`, `ARCHITECTURE.md`

- [ ] **Proof of Concept**: Implement agent tool calling workflow (search→extract→normalize→rank) using LangGraph within existing agent service; compare performance vs current implementation (Owner) — Links: `BACKEND_SERVICES.md#agent`, `ARCHITECTURE.md#Integration-Spine`
- [ ] **Observability Integration**: Add LangSmith tracing alongside OTEL for agent decision paths, token usage, and prompt performance metrics (Owner) — Links: `OBSERVABILITY_SRE.md`
- [ ] **Performance Benchmark**: Measure latency impact against p95 ≤ 4s target; evaluate memory/CPU overhead in staging environment (Owner) — Links: `ARCHITECTURE.md#Non-Functional-Targets`
- [ ] **Decision Documentation**: Create ADR documenting evaluation results, performance comparison, and recommendation for Phase 2 adoption (Owner)

**Exit**
- LangChain PoC demonstrates comparable performance and provides measurable benefits in agent observability/debugging; decision documented for Phase 2 planning.

---

## Phase 2 — Coverage, Reliability, & Returns (weeks 10–20)

> **Goal:** Expand merchant coverage, add Firmly & BigCommerce, returns/RMA, stronger fraud, data warehouse, and improve headless resilience.  
> **Read before work:** `INTEGRATIONS.md`, `BACKEND_SERVICES.md`, `DATA_PLATFORM.md`, `OBSERVABILITY_SRE.md`, `SECURITY_COMPLIANCE.md`

### 2A. Integrations Expansion
Status: 🔴 Owner: @tbd  
Playbooks: `INTEGRATIONS.md`

- [ ] **BigCommerce** connector (carts/checkout) (Owner)
- [ ] **Firmly** onboarding (API keys, catalog & order webhooks) (Owner)
- [ ] Capability registry auto‑updates per domain (API/DEEPLINK/HEADLESS) (Owner)

**Exit**
- ≥2 new merchants live via BigCommerce; Firmly demo order succeeds.

---

### 2B. Returns & Price Alerts
Status: 🔴 Owner: @tbd  
Playbooks: `BACKEND_SERVICES.md`, `FRONTEND.md`

- [ ] Returns initiation flow; RMA creation if API supports; status updates (Owner)
- [ ] Price history storage; alert subscriptions & notifications (Owner)

**Exit**
- Users can start returns from the Orders hub; alerts trigger correctly.

---

### 2C. Fraud & Risk
Status: 🔴 Owner: @tbd  
Playbooks: `BACKEND_SERVICES.md`, `PAYMENTS_WALLET.md`

- [ ] Velocity & spend anomaly rules; device signals (mobile/web) (Owner)
- [ ] 2FA approvals for risky Autopilot orders (push) (Owner)

**Exit**
- Fraud false‑negative rate acceptable; risky orders held for approval.

---

### 2D. Observability & SLO‑Gated Releases
Status: 🔴 Owner: @tbd  
Playbooks: `OBSERVABILITY_SRE.md`, `INFRA_CICD.md`

- [ ] Synthetic monitors per checkout path (API/DEEPLINK/HEADLESS) (Owner)
- [ ] Release gates: block deploys on SLO burn > threshold (Owner)

**Exit**
- Failed synthetic blocks rollout; rollback auto‑triggers work.

---

### 2E. Data Platform: Warehouse & Quality
Status: 🔴 Owner: @tbd  
Playbooks: `DATA_PLATFORM.md`

- [ ] Warehouse ingestion (Airbyte/dbt) for orders/offers/events (Owner)
- [ ] Great Expectations checks (freshness, validity) (Owner)

**Exit**
- BI dashboards live; DQ failures alert and block downstream jobs.

---

### 2F. Headless: Scripts Pack & Metrics
Status: 🔴 Owner: @tbd  
Playbooks: `HEADLESS_RUNNER.md`

- [ ] Apify actors for monitoring & price checks (Owner)
- [ ] Script pack for top‑5 domains; selector hardening (Owner)
- [ ] KPIs: success %, median duration, pause rate (Owner)

**Exit**
- Headless success ≥80% on allowlisted set; median run ≤ 90s.

---

### 2G. Mobile Enhancements
Status: 🔴 Owner: @tbd  
Playbooks: `MOBILE.md`

- [ ] Autopilot approval via push (deep link to confirm) (Owner)
- [ ] Returns flow on mobile; receipts viewer (Owner)

**Exit**
- Mobile parity for key flows; Detox E2E passing.

---

### 2H. Experimentation
Status: 🔴 Owner: @tbd  
Playbooks: `FRONTEND.md`, `BACKEND_SERVICES.md`

- [ ] Feature flags for ranking variants; A/B pipelines (Owner)
- [ ] “Why ranked?” explainers & sliders; measure CTR/conv uplift (Owner)

**Exit**
- One experiment shipped with statistically sound readout.

---

### 2I. Security & Compliance Step‑Up
Status: 🔴 Owner: @tbd  
Playbooks: `SECURITY_COMPLIANCE.md`

- [ ] SAST/DAST in CI; dependency inventory (SBOM) (Owner)
- [ ] Data retention policies & automated purge jobs (Owner)

**Exit**
- Clean security scan; purge jobs verified on test data.

---

### 2J. Performance & Cost
Status: 🔴 Owner: @tbd  
Playbooks: `OBSERVABILITY_SRE.md`

- [ ] LLM/crawl cost dashboards; caching strategies (Owner)
- [ ] p95 Prompt→first offers ≤ 4s via progressive reveal (Owner)

**Exit**
- Costs within budget; latency SLOs met for 2 consecutive weeks.

---

## Phase 3 — Production Scale & Standards (weeks 20+)

> **Goal:** Workflow engine for resiliency, payment tokenization upgrades, multi‑region ops, optional browser extension, advanced ranking & enterprise features.  
> **Read:** `BACKEND_SERVICES.md`, `PAYMENTS_WALLET.md`, `INFRA_CICD.md`, `OBSERVABILITY_SRE.md`

### 3A. Workflow Engine (Temporal)
Status: 🔴 Owner: @tbd

- [ ] Migrate long‑running checkouts & returns to workflows; replay tests (Owner)
- [ ] Saga patterns for multi‑merchant orders (Owner)

**Exit**
- No orphaned orders; replay verifies idempotency.

---

### 3B. Payments Tokenization Upgrades
Status: 🔴 Owner: @tbd

- [ ] Evaluate network token pilots; integrate when available (Owner)
- [ ] Split tenders & partial refunds automation (Owner)

**Exit**
- Tokenized flows reduce declines; refunds automated end‑to‑end.

---

### 3C. (Optional) Browser Extension
Status: 🔴 Owner: @tbd

- [ ] Prototype extension for user‑side automation on logged‑in sessions (Owner)
- [ ] Secure messaging with backend; telemetry and privacy controls (Owner)

**Exit**
- Extension completes checkout on at least 2 sites with near‑zero friction.

---

### 3D. Reliability & Compliance Scale
Status: 🔴 Owner: @tbd

- [ ] Multi‑region DR; backup/restore drills (Owner)
- [ ] SOC2 program groundwork; split payments into separate repo if needed (Owner)

**Exit**
- RTO/RPO targets met; payments repo separation complete (if required).

---

### 3E. Advanced Ranking & Subscriptions
Status: 🔴 Owner: @tbd

- [ ] Counterfactuals (“+€50 budget unlocks X”); learning‑to‑rank pipeline (Owner)
- [ ] Subscription/reorder cadence for consumables (Owner)

**Exit**
- Ranking uplift demonstrated; subscriptions live for 1 merchant.

---

### 3F. Enterprise Features
Status: 🔴 Owner: @tbd

- [ ] SSO (SAML/OIDC), audit exports, role‑scoped admin (Owner)

**Exit**
- Pilot enterprise tenant onboarded.

---

## Cross‑Phase Governance

### Definition of Done (per sub‑phase)
- ✅ Code + tests merged and green in CI (unit/contract/E2E as applicable)  
- ✅ **Documentation updated** (all relevant files):
  - Update `TODO.md` with progress/status changes
  - Update `HISTORY.md` with session changes before committing
  - Update relevant `docs/*.md` playbooks with any design/interface changes
  - Add ADR (Architecture Decision Record) if design changes made
- ✅ Dashboards/alerts created where relevant  
- ✅ Security checks passed (SAST/DAST, secrets scan)  
- ✅ Runbooks updated (if user‑visible or ops‑impacting)

### Documentation Maintenance Workflow
**CRITICAL**: Before any commit, ensure all documentation is updated:

1. **TODO.md**: Update task statuses (🔴→🟡→🟢), mark completed items, add new discovered tasks
2. **HISTORY.md**: Document all changes made in current session with timestamp and summary
3. **docs/*.md**: Update relevant playbooks if interfaces, designs, or architecture changed
4. **ADRs**: Create Architecture Decision Records for significant design decisions

**Example commit flow**:
```bash
# 1. Make code changes
# 2. Update TODO.md status 
# 3. Document changes in HISTORY.md
# 4. Update relevant docs/*.md files
# 5. Commit with human-style message (no AI attribution)
```

### Release Gates
- SLO burn < threshold in staging for 24–48h  
- Canary metrics healthy; synthetic journeys pass  
- No P0/P1 open issues on milestone
- **All documentation updated per workflow above**

### Risk Register (rolling)
- **Connector drift** → nightly contract tests; sandbox smoke tests  
- **Headless breakage** → allowlist & canary scripts; fast rollback  
- **Payment disputes** → clear receipts linking, spend caps, 2FA for risky orders  
- **PII leakage** → redaction tests in CI; log sampling reviews

---

## Backlog & Ideas (triage regularly)
- Browser extension (Phase 3C)
- Merchant self‑serve onboarding UI
- Coupon intelligence & automatic application across merchants
- On‑device ML for attribute extraction (privacy‑preserving)
- “Price match” advice & negotiation emails


## Phase 4 — GA Readiness (weeks 20+)

> **Goal:** Close the remaining gaps for General Availability (GA): broaden API‑first coverage and merchant onboarding, harden payments/returns and reconciliation, boost headless reliability (as a controlled fallback), complete compliance/trust posture, finalize UX accessibility & internationalization, mature ops/support, and raise search/compare quality at scale.  
> **Read before work:** `docs/ARCHITECTURE.md`, then the specific playbooks referenced in each sub‑phase below.

### 4A. Merchant Scale & Onboarding
Status: 🔴  Owner: @tbd  
Playbooks: `docs/INTEGRATIONS.md`, `docs/FRONTEND.md`, `docs/ARCHITECTURE.md`, `docs/SECURITY_COMPLIANCE.md`

- [ ] Merchant **self‑serve portal** (admin UI in web) to connect stores (Shopify install, BigCommerce app OAuth), view capability tier (API/DEEPLINK/HEADLESS), run a **test order**, and see connector health. (Owner) — Links: `docs/INTEGRATIONS.md#Connector-Design`, `docs/FRONTEND.md#Phase-1`, `docs/ARCHITECTURE.md#Integration-Spine`
- [ ] **Capability Registry UI** & scheduler to auto‑refresh per‑domain capabilities (API/DEEPLINK/HEADLESS), TOS notes, and SLA status; nightly sync + manual recheck. (Owner) — Links: `docs/INTEGRATIONS.md#Phase-2`, `docs/BACKEND_SERVICES.md`
- [ ] Expand **API‑first coverage**: prioritize GMV‑heavy categories; add/enable stores via Violet/Shopify/BigCommerce and scale **Firmly** where available; document per‑merchant SLAs. (Owner) — Links: `docs/INTEGRATIONS.md#Phase-1`
- [ ] Public **status page** for integrations (uptime, incidents, maintenance); incident comms workflow. (Owner) — Links: `docs/OBSERVABILITY_SRE.md`, `docs/INFRA_CICD.md`

**Exit**
- ≥ 70–80% of target GMV flows through **API‑first** connectors.  
- Status page live; merchant portal used by ≥ 10 active stores with successful test orders.

### 4B. Payments Maturity (Refunds, Reconciliation, Tokens)
Status: 🔴  Owner: @tbd  
Playbooks: `docs/PAYMENTS_WALLET.md`, `docs/BACKEND_SERVICES.md`, `docs/DATA_PLATFORM.md`, `docs/SECURITY_COMPLIANCE.md`

- [ ] **Refunds & cancellations automation**: implement end‑to‑end flows (full/partial) per connector; webhook ingestion + idempotent state transitions; user‑visible receipt updates. (Owner) — Links: `docs/PAYMENTS_WALLET.md`, `docs/INTEGRATIONS.md`, `docs/BACKEND_SERVICES.md`
- [ ] **Reconciliation**: daily matching for orders ↔ payments ↔ refunds (ledger reports + exceptions queue); dashboards for mismatches. (Owner) — Links: `docs/DATA_PLATFORM.md`, `docs/OBSERVABILITY_SRE.md`
- [ ] **Standardized receipts & taxes**: generate PDF/JSON receipts with tax breakdown for all paths (including headless/guest); store in artifacts; expose in Orders hub. (Owner) — Links: `docs/FRONTEND.md`, `docs/BACKEND_SERVICES.md`, `docs/DATA_PLATFORM.md`
- [ ] **Network tokenization** pilot → **production** where available; update checkout path selection to prefer network tokens over virtual cards; expand guardrails & telemetry. (Owner) — Links: `docs/PAYMENTS_WALLET.md`, `docs/SECURITY_COMPLIANCE.md`

**Exit**
- ≥ 95% of refunds processed automatically; reconciliation exceptions < 1% of orders.  
- Tokenized payments live for at least one network/merchant set; receipts/taxes standardized for 100% of orders.

### 4C. Headless Robustness (Controlled Fallback)
Status: 🔴  Owner: @tbd  
Playbooks: `docs/HEADLESS_RUNNER.md`, `docs/OBSERVABILITY_SRE.md`, `docs/SECURITY_COMPLIANCE.md`

- [ ] **AI‑assisted selectors & auto‑heal**: label/text‑based targeting; heuristic retries; automatic script patch slots; escalate to “assist” if thresholds exceeded. (Owner) — Links: `docs/HEADLESS_RUNNER.md#Phase-3`
- [ ] **Fallback decision engine**: policy that chooses DEEPLINK vs HEADLESS vs ASSIST using success‑rate KPIs, site risk profile, and guardrails; log decision rationale. (Owner) — Links: `docs/HEADLESS_RUNNER.md`, `docs/BACKEND_SERVICES.md`
- [ ] **Non‑API returns** support: generate labels, capture proof‑of‑return (upload/email parse), and track refund confirmations. (Owner) — Links: `docs/BACKEND_SERVICES.md`, `docs/DATA_PLATFORM.md`
- [ ] **Canary scripts + MTTP SLO**: script canaries per domain; alert on breakage; **Mean Time To Patch < 24h**; linter for scripts + artifact completeness checks. (Owner) — Links: `docs/OBSERVABILITY_SRE.md`, `docs/HEADLESS_RUNNER.md`

**Exit**
- Allowlisted headless success rate ≥ 85%; median run ≤ 90s; pause‑for‑human < 10%.  
- Documented MTTP SLO met for 60 days; decision engine audit trail present.

### 4D. Compliance & Trust
Status: 🔴  Owner: @tbd  
Playbooks: `docs/SECURITY_COMPLIANCE.md`, `docs/INFRA_CICD.md`

- [ ] **SOC 2 Type II** program: control mapping, evidence collection, change‑mgmt, vendor risk, security awareness; pen test & remediation; publish Trust Center. (Owner) — Links: `docs/SECURITY_COMPLIANCE.md`
- [ ] **PCI SAQ** posture verified (no PAN storage), ASV scans, recurring vulnerability management; document network segmentation for payments. (Owner) — Links: `docs/SECURITY_COMPLIANCE.md`, `docs/INFRA_CICD.md`
- [ ] **Privacy & residency**: user portal for data export/delete; region pinning (if required); cookie & tracking policies. (Owner) — Links: `docs/SECURITY_COMPLIANCE.md`, `docs/DATA_PLATFORM.md`
- [ ] **TOS matrix** & merchant policy docs (API/DEEPLINK/HEADLESS rules) surfaced in admin and legal pages. (Owner) — Links: `docs/INTEGRATIONS.md`, `docs/ARCHITECTURE.md`

**Exit**
- SOC 2 Type II audit completed (or in final fieldwork with all controls operating).  
- PCI SAQ/ASV documented; Trust Center live; privacy portal operational.

### 4E. UX Completeness (A11y, i18n, Loyalty/Coupons, Optional Extension)
Status: 🔴  Owner: @tbd  
Playbooks: `docs/FRONTEND.md`, `docs/BACKEND_SERVICES.md`, `docs/INTEGRATIONS.md`, `docs/MOBILE.md`

- [ ] **Accessibility**: WCAG 2.2 AA audit and fixes (keyboard, SR, color contrast, focus management); automated checks in CI. (Owner) — Links: `docs/FRONTEND.md`
- [ ] **Internationalization**: currency formatting, locale dates, **address validation** per country; **shipping ETA normalization**; language packs. (Owner) — Links: `docs/FRONTEND.md`, `docs/BACKEND_SERVICES.md`
- [ ] **Loyalty & coupons**: capture loyalty IDs; systematic coupon discovery & application across connectors; **savings breakdown** in UI. (Owner) — Links: `docs/INTEGRATIONS.md`, `docs/BACKEND_SERVICES.md`, `docs/FRONTEND.md`
- [ ] **(Optional)** Desktop **browser extension** for logged‑in flows (reduces headless need): secure messaging with backend; privacy controls; limited GA on 2–3 sites. (Owner) — Links: `docs/FRONTEND.md`, `docs/HEADLESS_RUNNER.md`

**Exit**
- A11y checks pass in CI & manual audit; i18n live for launch locales.  
- Loyalty/coupons applied where supported; savings visible; extension (if chosen) completes checkout on 2+ merchants.

### 4F. Ops & Support
Status: 🔴  Owner: @tbd  
Playbooks: `docs/OBSERVABILITY_SRE.md`, `docs/BACKEND_SERVICES.md`, `docs/INFRA_CICD.md`

- [ ] **In‑app support** wired to agent run IDs, order IDs, and headless trace links; macros for top 10 issues. (Owner) — Links: `docs/BACKEND_SERVICES.md`, `docs/OBSERVABILITY_SRE.md`
- [ ] **Ops console**: retry webhooks, reprocess DLQs, replay agent runs, manually advance order states (with audit). (Owner) — Links: `docs/BACKEND_SERVICES.md`, `docs/DATA_PLATFORM.md`
- [ ] **SLA dashboards & on‑call**: incident runbooks finalized, on‑call schedule & paging; public **status page** integrated with incidents. (Owner) — Links: `docs/OBSERVABILITY_SRE.md`, `docs/INFRA_CICD.md`

**Exit**
- MTTR & SLA targets met for 60 days; support handles ≥ 80% of issues without engineer intervention.

### 4G. Quality & Ranking (Extraction F1, LTR, Experiments)
Status: 🔴  Owner: @tbd  
Playbooks: `docs/BACKEND_SERVICES.md`, `docs/DATA_PLATFORM.md`, `docs/OBSERVABILITY_SRE.md`

- [ ] **Gold datasets** for extraction/normalization; nightly regression; **F1 gates in CI**; drift alerts. (Owner) — Links: `docs/BACKEND_SERVICES.md`, `docs/DATA_PLATFORM.md`
- [ ] **Learning‑to‑rank** pipeline (offline → online) with safe rollout and guardrails; variant monitoring; rollback on metric regressions. (Owner) — Links: `docs/DATA_PLATFORM.md`, `docs/OBSERVABILITY_SRE.md`
- [ ] **Variant explorer** and experiment hygiene (power analysis, MDEs, stats correctness). (Owner) — Links: `docs/FRONTEND.md`, `docs/BACKEND_SERVICES.md`

**Exit**
- Extraction/normalization F1 ≥ target; LTR shows statistically significant uplift; guardrails prevent regressions.

### 4H. Mobile Parity & Polish
Status: 🔴  Owner: @tbd  
Playbooks: `docs/MOBILE.md`, `docs/BFF_API.md`, `docs/FRONTEND.md`

- [ ] **Offline states & background sync** for order updates; resilient network handling. (Owner) — Links: `docs/MOBILE.md`
- [ ] **Biometrics** for sensitive actions (Autopilot approvals, guardrail edits). (Owner) — Links: `docs/MOBILE.md`
- [ ] **Deep links** to merchant apps; universal link handling; store readiness (crash‑free sessions > 99.5%, ANR budgets, review prompts). (Owner) — Links: `docs/MOBILE.md`

**Exit**
- Mobile feature parity with web for orders/returns/approvals; reliability KPIs met in app stores.

### Phase 4 Exit (GA) — Definition of Done
- Coverage: ≥ 70–80% GMV via API‑first; documented fallback tiers for remainder, headless success ≥ 85% (allowlisted).  
- UX: Web + Mobile prompt→compare→cart→checkout (Assist/Autopilot), A11y AA, i18n for launch locales, loyalty/coupons where supported.  
- Payments: refunds/reconciliation automated; standardized receipts/taxes; tokenized flows live where available.  
- Orders: real‑time tracking for ≥ 90% orders; returns initiation for ≥ 70% via API; guided returns elsewhere.  
- Trust: SOC 2 Type II (or in final fieldwork), PCI SAQ/ASV, privacy portal, Trust Center live.  
- SRE: SLOs met for 60 days; synthetic journeys green; incident/runbooks active; canary/rollback proven.  
- Quality: extraction F1 gates pass; LTR uplift measured; experiments stats‑correct.  
- Ops: ops console in use; support resolves ≥ 80% without engineering handoff.

## Milestones & Labels

- Milestones: `P0 Foundation`, `P1 MVP`, `P2 Coverage`, `P3 Scale`, `P4 GA readiness`
- Labels: `area:frontend`, `area:bff`, `area:agent`, `area:integrations`, `area:headless`, `area:payments`, `area:data`, `area:infra`, `type:bug`, `type:feature`, `type:test`, `needs:design`, `blocked`

### Final Note
For every task, **consult the relevant playbook(s)** before starting work to ensure contracts, constraints, and testing requirements are understood:
- Architecture & flows: `ARCHITECTURE.md`
- Component specifics: the corresponding `*.md` under `/docs`
- CI/CD, Observability, Security: the respective playbooks to wire tests, alerts, and policies correctly.