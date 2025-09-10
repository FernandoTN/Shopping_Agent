# Shopping Agent

An AI-powered shopping assistant that enables intelligent product discovery, comparison, and automated checkout across multiple e-commerce platforms.

## Overview

Shopping Agent is a comprehensive platform that combines AI-driven product search with automated purchasing capabilities. It provides users with a conversational interface to find products, compare offers across merchants, and complete purchases through various integration methods.

## Key Features

- **AI-Powered Discovery**: Natural language product search with intelligent ranking and comparison
- **Multi-Platform Integration**: Support for Violet, eBay, Shopify, BigCommerce, and Firmly
- **Automated Checkout**: Three-tier approach: API-first, deeplink fallback, and headless automation
- **Smart Payments**: Stripe Issuing integration for secure virtual card transactions
- **Real-time Tracking**: End-to-end order monitoring and carrier integration
- **Price Intelligence**: Historical tracking and alert notifications
- **Returns Management**: Streamlined RMA processes and status updates

## Architecture

The platform follows a microservices architecture with:

- **Frontend**: Web and mobile applications with real-time streaming
- **GraphQL BFF**: Unified API facade for client applications
- **Core Services**: Agent orchestration, discovery, normalization, and offer ranking
- **Integration Layer**: Vendor-specific connectors and capabilities
- **Payment System**: Secure virtual card issuance and spend controls
- **Data Platform**: Real-time analytics and historical tracking

## Project Status

This project is currently in active development following a phased approach:

- **Phase 0**: Foundation & Bootstrap (Infrastructure, Security, Observability)
- **Phase 1**: API-First MVP with Policy-Aware Fallback (Current Focus)
- **Phase 2**: Coverage, Reliability, & Returns
- **Phase 3**: Production Scale & Standards
- **Phase 4**: GA Readiness (Compliance, UX Polish, Operational Maturity)

For detailed development progress and next steps, see [TODO.md](TODO.md).

## Getting Started

```bash
# Bootstrap the development environment
make bootstrap

# Start development servers
make dev
```

## Documentation

Comprehensive documentation is available in the `/docs` directory:

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Frontend Specifications](docs/FRONTEND.md)
- [Backend Services](docs/BACKEND_SERVICES.md)
- [Integration Guides](docs/INTEGRATIONS.md)
- [Security & Compliance](docs/SECURITY_COMPLIANCE.md)

## Contributing

This project follows strict development standards with:

- Pre-commit hooks for linting and security scanning
- Comprehensive testing requirements (unit, integration, E2E)
- SLO-gated releases with automated rollback
- Security-first approach with PII protection

## License

This project is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License - see the [LICENSE](LICENSE) file for details.

You are free to use, modify, and distribute this project for non-commercial purposes with proper attribution.
