# Frontend (Web)

## Project-wide Objective (recap)
Seamless agent shopping: discovery → comparison → checkout (Assist/Autopilot) with transparent capabilities and clear guardrails.

## Purpose & Scope
Deliver a fast, accessible **Next.js** web app with:
- Prompt/chat canvas (streamed actions + citations)
- Results grid + comparison tables (normalized attributes)
- Universal cart with per-merchant capability badges: **API**, **DEEPLINK**, **HEADLESS**
- Guardrails control (budget, allowed merchants, Autopilot toggle)
- Orders hub (status, returns, receipts)
- Admin views (feature flags, headless allowlist)

## Integration Points
- **Consumes**: GraphQL BFF (`searchOffers`, `buildComparison`, `cart`, `checkout`, `orders`, `merchantCapabilities`)
- **Produces**: User actions; optional device fingerprint for fraud signals
- **Auth**: OIDC; uses short-lived JWT for BFF
- **Telemetry**: OTEL web SDK → collector; Web Vitals to analytics

## Phase Plan
### Phase 1
- **1A**: Shell (Next.js, Auth, layout, design system, i18n), Prompt UI, streaming agent events
- **1B**: Results & comparisons; capability badges; universal cart MVP
- **1C**: Checkout UX for 3 paths (API, Deeplink, Headless prompt), Guardrails panel

### Phase 2
- **2A**: Orders hub (tracking timeline, receipts), return initiation
- **2B**: “Why ranked?” explainers; sliders for user weighting
- **2C**: Price alerts, saved searches, recently viewed; accessibility audit (WCAG 2.2 AA)

### Phase 3
- **3A**: Advanced admin (connector health, run replays)
- **3B**: Performance budgets & prefetch; offline states
- **3C**: Theming & enterprise SSO (optional)

## Deliverables & Acceptance
- SSR pages for chat, results, cart, orders
- 95% Storybook coverage of states; Playwright E2E green across the 3 checkout paths
- Web Vitals: LCP ≤ 2.5s (p75), INP ≤ 200ms, CLS ≤ 0.1

## Test Strategy
- RTL unit tests; Storybook interaction tests
- Playwright E2E: Assist flow (deeplink), API checkout (eBay/Violet), Headless fallback (allowlisted demo site)
- Contract tests against GraphQL persisted queries

## Risks & Mitigations
- Long-running searches → progressive reveal + skeletons
- Headless pauses (CAPTCHA) → in-UI prompts & fallbacks
- Capability mismatch → server returns explicit capability + reason