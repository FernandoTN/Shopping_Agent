# Mobile App (React Native, Expo)

## Objective
Mirror web’s core flows with mobile-native ergonomics; push notifications for order/tracking; secure on-device secrets.

## Scope
- Prompt & results views
- Universal cart & checkout selector (API/Deeplink/Headless assist)
- Orders hub (timeline + push)
- Guardrails & payment method management

## Integration Points
- GraphQL BFF over HTTPS and WS
- Push via APNS/FCM (Notifications service)
- Deep links to merchant apps when beneficial

## Phase Plan
### Phase 1
- **1A**: Expo app scaffold, OIDC, basic prompt/results
- **1B**: Cart + capability badges; deeplink checkout handoff
- **1C**: Orders list + push setup

### Phase 2
- **2A**: Autopilot approvals via push
- **2B**: Return workflows; receipts viewer
- **2C**: Device trust signals for Fraud service

### Phase 3
- **3A**: Offline cache; background sync
- **3B**: Biometrics for sensitive actions
- **3C**: Widgets (iOS/Android)

## Tests
- Unit: Jest
- E2E: Detox on device farm (Assist/API paths)
- Contract: GraphQL query snapshots

## Risks
- Merchant deeplinks vary → maintain mapping
- Mobile headless not supported → fall back to deeplink