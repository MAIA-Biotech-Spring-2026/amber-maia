# Amber - Family Relationship Intelligence Platform

A family relationship intelligence application built with SwiftUI, Solana blockchain, and Google Cloud Platform.

## Architecture

- **Frontend**: SwiftUI Multiplatform (iOS, visionOS, macOS)
- **Backend**: Node.js/Fastify on Cloud Run
- **Database**: Cloud SQL PostgreSQL
- **Storage**: Cloud Storage
- **Blockchain**: Solana (cNFTs for family members)
- **Infrastructure**: Terraform on GCP

## Quick Start

### Prerequisites

- Node.js 20+
- pnpm 9+
- Terraform 1.0+
- Google Cloud SDK
- Xcode 15+ (for iOS app)

### Local Development

1. **Install dependencies:**
   ```bash
   pnpm install
   ```

2. **Start backend:**
   ```bash
   AMBER_LOCAL_DEV=true pnpm --filter @amber/app-service dev
   ```

3. **Run iOS app:**
   - Open `apps/apple/AmberApp/AmberApp.xcodeproj` in Xcode
   - Select iOS Simulator
   - Press `Cmd + R`

### GCP Deployment

1. **Set up GCP:**
   ```bash
   cd infra/terraform
   ./setup.sh
   ```

2. **Deploy:**
   ```bash
   ./deploy.sh
   ```

See `infra/terraform/README.md` for detailed deployment instructions.

## Project Structure

```
amber/
├── apps/
│   └── apple/          # SwiftUI iOS/visionOS/macOS app
├── services/
│   └── app/            # Fastify API service
├── packages/
│   └── amberkit/       # Swift SDK for API client
└── infra/
    └── terraform/      # GCP infrastructure as code
```

## Features

- **3D Family Tree Visualization**: Interactive graph with nodes and edges
- **Natural Language Input**: Parse family relationships from text
- **Solana Integration**: cNFTs for family member identity
- **AI-Powered Insights**: Generate relationship intelligence
- **Health Integration**: Apple HealthKit support (planned)

## Documentation

- `infra/terraform/README.md` - Infrastructure deployment guide

