# Observability & SRE

## Objective
Make the system debuggable and operable: logs, metrics, traces, SLOs, alerts, runbooks.

## Stack
- OTEL SDKs → Collector → Prometheus/Loki/Tempo/Grafana
- SLOs with burn-rate alerts; synthetic probes

## Phase Plan
### Phase 1
- **1A**: OTEL in BFF and core services; trace IDs across requests
- **1B**: Dashboards (latency, error rates, queue stalls)
- **1C**: SLOs: BFF availability, search latency; alerts wired

### Phase 2
- **2A**: Synthetic journeys (Prompt→Order) in staging & prod
- **2B**: Incident response runbooks; on-call rotations
- **2C**: Error budgets gate releases

### Phase 3
- **3A**: Advanced tracing (workflow spans)
- **3B**: Cost observability (LLM & headless)
- **3C**: Chaos experiments & auto-remediation

## Runbooks
- API connector timeouts
- Headless stalled on CAPTCHA
- Payment declines

## Risks
- Noisy alerts → iterate thresholds; add SLO-based alerts