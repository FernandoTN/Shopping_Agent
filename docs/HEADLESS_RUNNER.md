# Headless Runner (Fallback Automation)

## Objective
Policy-aware automation to complete checkout where APIs don’t exist. Allowlisted domains only. Pauses on CAPTCHA/2FA; never evades anti-bot.

## Backends
- **Browserless** (Playwright/Puppeteer sessions)
- **Apify** (hosted actor runs & storage)

## Architecture
- `/services/headless` exposes: `start_run(script, inputs)`, `status(run_id)`, `cancel(run_id)`
- Scripts per platform archetype (Shopify-like, Woo-like) + site-specific patches
- Artifacts: screenshots, HAR/trace, DOM snapshots → S3; indexed by `automation_runs`

## Phase Plan
### Phase 1
- **1A**: Integrate Browserless; build canonical “guest checkout” script
- **1B**: Add Stripe Issuing virtual card fill; screenshot & trace capture
- **1C**: Admin allowlist UI; pause/notify for human approval

### Phase 2
- **2A**: Apify actors for recurring monitors & price checks
- **2B**: Script pack for top-5 allowlisted sites
- **2C**: KPI dashboards (success %, avg duration, pause rate)

### Phase 3
- **3A**: AI-assisted selectors (label-based) to reduce brittleness
- **3B**: Script linting & static checks
- **3C**: Canary scripts & rollback

## Tests
- CI runs scripts on staging sites; asserts page checkpoints
- Golden screenshots diffing; trace validation
- Policy tests ensure allowlist enforcement

## Risks
- Site changes break flows → fast patching; use generic selectors
- Merchant policy shifts → disable domain via feature flag