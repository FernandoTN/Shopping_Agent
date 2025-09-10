# Data Platform

## Objective
Reliable OLTP for operations, fast search, and high-quality artifacts with lineage. Keep PII safe and auditable.

## Stores
- **Postgres**: users, carts, orders, connections, capabilities, automation_runs
- **Redis**: sessions, caches
- **OpenSearch**: full-text over offers/products
- **pgvector**: attribute similarity matching
- **S3/GCS**: HTML snapshots, headless traces, receipts
- **Warehouse**: BigQuery/Snowflake for analytics/experiments

## Schemas (high-level)
- `users`, `payment_methods`, `connections`
- `products`, `offers` (provenance, capability)
- `carts`, `orders`, `tracking_refs`
- `merchant_capabilities`, `automation_runs`, `agent_runs`

## Phase Plan
### Phase 1
- **1A**: DDL migrations (Alembic); seeds; DB CI checks
- **1B**: Offer index; vector ops in normalize
- **1C**: S3 artifact buckets; retention policies

### Phase 2
- **2A**: Warehouse pipelines (Airbyte/dbt); event ingestion
- **2B**: Great Expectations for freshness & validity
- **2C**: PII tagging & masked views

### Phase 3
- **3A**: Data lineage; schema registry for events
- **3B**: Cost optimization & tiered storage
- **3C**: GDPR tooling (export/delete jobs)

## Tests
- Migration tests; rollback drills
- Data quality checks; sampling assertions
- Load testing read/write hotspots

## Risks
- Schema drift → ADRs + versioned migrations
- PII exposure → field-level encryption & access controls