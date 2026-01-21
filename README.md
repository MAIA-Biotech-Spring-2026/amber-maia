# Amber - Relationship Intelligence Platform

A universal healthcare identity and relationship intelligence platform combining iOS mobile app with Privy.io authentication, Solana blockchain verification, and Togari business integration.

## Overview

Amber consists of two main products:

1. **Amber ID (iOS App)**: Consumer-facing mobile app for personal health relationships with universal authentication
2. **Togari**: Business platform for healthcare practitioners (separate codebase)

This repository contains the Amber ID iOS application.

## Architecture

### Frontend (iOS)
- **Framework**: SwiftUI (iOS 16+)
- **Auth SDK**: Privy Swift SDK v2.8.0+
- **Blockchain**: Solana (verified identity NFTs)
- **Storage**: Keychain (secure credentials), UserDefaults (preferences)

### Backend Integration
- **Privy.io**: Multi-provider authentication & wallet infrastructure
- **Solana**: Blockchain for government ID-verified identities
- **Togari API**: User organization and practitioner data sync

### Key Features
- **Universal Authentication**: Email, phone, Google, Apple, LinkedIn, Ethereum/Solana wallets
- **Blockchain Verification**: Government ID verification minted as Solana NFTs
- **Data Aggregation**: Connect calendars, email, HealthKit, LinkedIn, and more
- **Six Health Dimensions**: Spiritual, Emotional, Physical, Intellectual, Social, Financial
- **Relationship Intelligence**: Track how connections affect your wellbeing

---

## Quick Start

### Prerequisites

- **Xcode 15.0+**
- **iOS 17.0+**
- **Swift 5.9+**
- **Privy.io Account** (for authentication credentials)

### Opening the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/sagartiw/amber.git
   cd amber
   ```

2. Open the Xcode project:
   ```bash
   cd AmberApp
   open AmberApp.xcodeproj
   ```

3. Select an iOS simulator (iPhone 15 Pro recommended)

4. Press `Cmd+R` to build and run

---

## Project Structure

```
AmberApp/
├── AMBER_ID_ARCHITECTURE.md    # Comprehensive integration guide
├── AmberApp/
│   ├── AmberApp.swift          # Main app entry point
│   ├── Extensions/
│   │   ├── Color+Amber.swift   # Color design system
│   │   └── Font+Amber.swift    # Typography system
│   ├── Models/
│   │   ├── AmberUser.swift     # User/Amber ID model
│   │   ├── Connection.swift    # Contact/connection model
│   │   ├── HealthDimension.swift
│   │   ├── PersonalityTypes.swift
│   │   ├── Insight.swift
│   │   └── AmberStory.swift
│   ├── Components/
│   │   ├── LiquidGlassSearchBar.swift
│   │   ├── ContactAvatar.swift
│   │   ├── HealthBadge.swift
│   │   └── CustomTabBar.swift
│   ├── Views/
│   │   ├── DiscoverView.swift      # Newsfeed/insights
│   │   ├── ConnectionsView.swift   # Contacts/relationships
│   │   ├── AmberIDView.swift       # Profile/identity
│   │   └── AddContactView.swift    # Lead capture form
│   ├── ViewModels/
│   │   ├── DiscoverViewModel.swift
│   │   ├── ConnectionsViewModel.swift
│   │   └── AmberIDViewModel.swift
│   └── Services/               # Future: Privy, Solana, API clients
```

---

## Features Implemented

### ✅ Phase 1: Core UI (Complete)

1. **Three-Tab Navigation**
   - Discover: Newsfeed with health insights
   - Connections: Contact list with + button for lead capture
   - Amber ID: Personal identity profile

2. **Discover View**
   - Category tabs ("For You" + 6 health dimensions)
   - Insight cards with health badges
   - Mock data with sample content

3. **Connections View**
   - Contact list with avatars
   - Search bar with voice input
   - Add Contact button (+ icon) in top right
   - Alphabet scrubber for quick navigation

4. **Amber ID View**
   - Identity card with avatar
   - Personality summary table
   - Horizontally scrollable stories
   - Integration toggles (Apple Contacts, LinkedIn, Calendar)
   - Journal widget

5. **Design System**
   - Dark theme (background: #0A0A0A)
   - Glass morphism effects
   - Health dimension colors (Spiritual, Emotional, Physical, etc.)
   - Custom typography and reusable components

---

## Implementation Roadmap

See `AmberApp/AMBER_ID_ARCHITECTURE.md` for detailed technical architecture.

### Phase 1: Core Auth (Week 1-2) - IN PROGRESS
- [x] Core UI foundation
- [x] Remove globe/tree views (simplified to list view)
- [x] Add + button for lead capture
- [ ] Integrate Privy Swift SDK
- [ ] Build onboarding UI flow
- [ ] Implement email/phone OTP auth
- [ ] Store credentials in Keychain

### Phase 2: Social & Wallet Auth (Week 3)
- [ ] Google OAuth
- [ ] Apple Sign In
- [ ] LinkedIn OAuth
- [ ] Solana wallet connection
- [ ] Link multiple auth methods

### Phase 3: ID Verification (Week 4)
- [ ] Government ID upload UI
- [ ] Privy ID verification integration
- [ ] Solana NFT minting for verified identities
- [ ] Verified badge display in profile

### Phase 4: Data Sources (Week 5-6)
- [ ] Calendar integration (Google, Apple EventKit)
- [ ] Email integration (Gmail, Outlook)
- [ ] HealthKit integration
- [ ] LinkedIn profile sync
- [ ] Data source management UI

### Phase 5: Togari Integration (Week 7-8)
- [ ] Backend API endpoints
- [ ] User sync on signup
- [ ] Organization creation flow for practitioners
- [ ] Session token exchange
- [ ] Dashboard deep linking

---

## Mock Data

The app currently uses mock data for development:

- **Connections**: 7 sample contacts (Alex, Sarah, Michael, Emily, David, Jennifer, Robert)
- **Insights**: 5 sample insights across health dimensions
- **Amber ID**: Sample profile for "Sagar Tiwari"

---

## Configuration

### Bundle Identifier
- `com.amber.app`

### Deployment Target
- iOS 17.0+

### Architecture
- MVVM with Combine
- SwiftUI for all UI components
- Async/await for networking

---

## Next Steps

### 1. Get Privy Credentials
- Sign up at [privy.io](https://www.privy.io/)
- Create new app
- Get App ID and Client ID
- Configure supported chains (Ethereum, Solana)

### 2. Set up Development Environment
- Add Privy SDK via Swift Package Manager
- Configure `Info.plist` for OAuth redirects
- Set up URL schemes for deep linking

### 3. Backend Coordination
- Define Amber ID API endpoints in Togari backend
- Set up JWT verification
- Create user and organization database tables

---

## Design Philosophy

**Amber = Central Nervous System for Relationships**

Combining the best of:
- **Dimensional**: Deep personality science
- **Perplexity**: Intelligent newsfeed
- **Apple Contacts**: Simple utility

**Six-Dimensional Health Model:**
- 🔮 Spiritual
- ❤️ Emotional
- 🏃 Physical
- 🧠 Intellectual
- 👥 Social
- 💰 Financial

---

## Resources

- [Privy iOS SDK](https://github.com/privy-io/privy-ios)
- [Privy Documentation](https://docs.privy.io/)
- [Solana Web3.swift](https://github.com/portto/solana-web3.swift)
- [Metaplex NFT Standard](https://docs.metaplex.com/)

---

## Known Issues

- Xcode project file may need regeneration for proper compilation
- Mock data only - no persistence yet
- No authentication implemented yet
- Images/photos not implemented (using initials avatars)

---

## License

Proprietary - Amber

## Contact

For questions or support, contact the Amber team.

---

**Last Updated**: January 20, 2026

Built with ❤️ using SwiftUI
