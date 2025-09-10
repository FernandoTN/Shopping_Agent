# GraphQL BFF

## Objective
Provide a client-friendly, stable API facade and event stream across heterogeneous backends; enforce authz, rate limits, and query safety.

## Scope
- GraphQL schema & resolvers; persisted queries
- WebSockets for agent event streaming
- Response caching (Redis/CDN)
- Query complexity limits, RBAC/ABAC

## Integration Points
- **Upstream**: Core services via HTTP/gRPC
- **Downstream**: Web/Mobile apps
- **Schemas**: `/platform/schemas/graphql/`, JSON Schemas for inputs
- **Security**: OIDC JWT verification, CSRF for mutations (web)

## Phase Plan
### Phase 1
- **1A**: Schema (`searchOffers`, `buildComparison`, `cart`, `checkout`, `orders`, `merchantCapabilities`)
- **1B**: WebSocket events pipe; Redis cache
- **1C**: Rate limiting + persisted queries + error taxonomy

### Phase 2
- **2A**: Contract tests (Pact) with services
- **2B**: Canary fields & feature flags
- **2C**: Usage analytics + schema change linter

### Phase 3
- **3A**: Federation or modular schema split
- **3B**: Zero-downtime schema deploys
- **3C**: GraphQL @defer/@stream (if needed)

## Tests
- Unit resolvers; schema snapshot
- Pact provider/consumer tests
- k6 load tests

## Risks
- N+1 in resolvers → dataloaders
- Query abuse → complexity/frequency caps