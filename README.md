# Amber - Relationship Intelligence Platform
## MAIA Biotech Spring 2026 Project

> Adapted from original Amber project for USC MAIA Biotech coursework

A universal healthcare identity and relationship intelligence platform combining iOS mobile app with Privy.io authentication, Solana blockchain verification, and healthcare integration.

## Project Context

This project is part of the **USC MAIA (Multi-modal AI in Biotechnology) Spring 2026** program. We're adapting and extending the Amber platform to explore AI applications in healthcare relationship management and identity verification.

**Original Repository:** [sagartiw/amber](https://github.com/sagartiw/amber)
**MAIA Organization:** [MAIA-Biotech-Spring-2026](https://github.com/MAIA-Biotech-Spring-2026)

## Team Members

*(Add your team members here)*
- Team Member 1 - [@github-username](https://github.com/username)
- Team Member 2 - [@github-username](https://github.com/username)
- Team Member 3 - [@github-username](https://github.com/username)

## Overview

Amber consists of two main components:

1. **Amber ID (iOS App)**: Consumer-facing mobile app for personal health relationships with universal authentication
2. **Backend API**: Healthcare data integration and AI-powered relationship intelligence

For detailed setup and architecture information, see:
- [QUICK_START.md](QUICK_START.md) - Quick setup guide
- [SETUP.md](SETUP.md) - Detailed configuration
- [AmberApp/AMBER_ID_ARCHITECTURE.md](AmberApp/AMBER_ID_ARCHITECTURE.md) - Technical architecture

## MAIA Project Goals

### Research Questions
1. How can blockchain technology enhance healthcare identity verification?
2. What role can AI play in relationship intelligence for health outcomes?
3. How do we balance privacy with data aggregation in healthcare apps?
4. What are the ethical considerations for health-related AI insights?

### Deliverables

#### Phase 1: Platform Understanding (Weeks 1-4)
- [ ] Document current Amber architecture
- [ ] Set up development environment
- [ ] Deploy test instance
- [ ] Literature review on healthcare identity systems

#### Phase 2: Feature Development (Weeks 5-10)
- [ ] Enhance AI-powered health insights
- [ ] Implement additional data source integrations
- [ ] Add privacy controls
- [ ] Improve relationship tracking algorithms

#### Phase 3: Research & Analysis (Weeks 11-14)
- [ ] Conduct user experience testing
- [ ] Analyze relationship-health correlation data
- [ ] Evaluate blockchain identity verification
- [ ] Security and privacy audit

#### Phase 4: Final Presentation (Weeks 15-16)
- [ ] Prepare demo and presentation
- [ ] Write final research paper
- [ ] Document findings
- [ ] Deploy production version

## Original Project Overview

This is based on the Amber platform - a relationship intelligence system that combines:

- **Universal Authentication**: Email, phone, Google, Apple, LinkedIn, Ethereum/Solana wallets
- **Blockchain Verification**: Government ID verification minted as Solana NFTs
- **Data Aggregation**: Calendars, email, HealthKit, LinkedIn
- **Six Health Dimensions**: Spiritual, Emotional, Physical, Intellectual, Social, Financial
- **AI-Powered Insights**: Personalized health and relationship recommendations

## Technology Stack

### iOS
- SwiftUI (iOS 16+)
- Privy Swift SDK
- Solana integration
- HealthKit, EventKit

### Backend
- Node.js + Hono.js
- PostgreSQL + Drizzle ORM
- Privy.io authentication
- OpenAI API

### Infrastructure
- Google Cloud Platform
- Terraform
- Docker
- GitHub Actions

## Quick Start

### iOS App
```bash
cd AmberApp
open AmberApp.xcodeproj
# Press Cmd+R to build and run
```

### Backend API
```bash
cd services/app
pnpm install
pnpm run dev
```

See [QUICK_START.md](QUICK_START.md) for detailed instructions.

## Next Steps

**Current Status:** v2.0.0 - Production Ready (Phase 1 Complete)
**Next Priority:** Phase 2 - Authentication & User Management

### Immediate Tasks
- [ ] Implement Privy OAuth web login (ASWebAuthenticationSession)
- [ ] Get organizationId from user profile (not environment variable)
- [ ] Connect to backend API for Connections data
- [ ] Connect to backend API for Insights data

### Comprehensive Roadmap
See **[ROADMAP.md](../ROADMAP.md)** in the main workspace for:
- Complete Phase 2-6 planning
- All 7 intentional TODOs with locations and context
- Success metrics and timelines
- Production deployment strategy

### Quick Commands
```bash
# Development
open AmberApp.xcodeproj                # Open in Xcode
# Press Cmd+R to build and run

# From command line
xcodebuild -project AmberApp/AmberApp.xcodeproj -scheme AmberApp \
  -configuration Debug -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build

# Or use the automated launcher
cd ..                                  # Go to main workspace
./start-all.sh                         # Launches both Togari + Amber
```

## License

This project is based on the original Amber platform (Proprietary).
**Academic Use Only** - For USC MAIA Biotech coursework.

## Acknowledgments

- **Original Amber Team** - For the base platform
- **USC MAIA Program** - For project guidance
- **Privy.io** - For authentication infrastructure
- **Solana Foundation** - For blockchain tooling

---

**Course:** Multi-modal AI in Biotechnology (Spring 2026)
**Institution:** University of Southern California
**Organization:** [MAIA-Biotech-Spring-2026](https://github.com/MAIA-Biotech-Spring-2026)

## Upstream Sync

Last synced with upstream [sagartiw/amber](https://github.com/sagartiw/amber): **February 12, 2026**
- ✅ Pulled upstream changes into MAIA version
- ✅ Pushed MAIA security improvements back to upstream via PR
- ✅ Key improvements: 25+ crash fixes, security hardening, LinkedIn validation

**Last Updated**: February 12, 2026
