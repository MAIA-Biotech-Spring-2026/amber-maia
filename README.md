# Amber iOS App

A relationship intelligence iOS app that tracks how personal connections affect six dimensions of health: Spiritual, Emotional, Physical, Intellectual, Social, and Financial.

## Project Structure

```
Amber/
├── AmberApp.swift              # Main app entry point with horizontal paging
├── Extensions/
│   ├── Color+Amber.swift       # Color design system
│   └── Font+Amber.swift        # Typography system
├── Models/
│   ├── HealthDimension.swift   # Health dimension enum
│   ├── PersonalityTypes.swift  # Personality trait enums
│   ├── AmberUser.swift         # User/Amber ID model
│   ├── Connection.swift        # Contact/connection model
│   ├── Insight.swift           # Newsfeed insight model
│   └── AmberStory.swift        # Story card model
├── Components/
│   ├── LiquidGlassSearchBar.swift  # Reusable search bar
│   ├── ContactAvatar.swift         # Avatar component with initials
│   └── HealthBadge.swift           # Health dimension badge
├── Views/
│   ├── DiscoverView.swift      # Left screen: Newsfeed
│   ├── ConnectionsView.swift   # Center screen: Contacts
│   └── AmberIDView.swift       # Right screen: Profile
├── ViewModels/
│   ├── DiscoverViewModel.swift
│   ├── ConnectionsViewModel.swift
│   └── AmberIDViewModel.swift
└── Services/                   # For future Supabase integration
```

## Features Implemented

### ✅ Phase 1: Static UI (Complete)

1. **Three-Screen Horizontal Paging Navigation**
   - Discover (left)
   - Connections (center, default)
   - Amber ID (right)

2. **Discover View**
   - Category tabs with "For You" and health dimensions
   - Insight cards with health badges
   - Mock data with 5 sample insights

3. **Connections View**
   - "My Card" row at top
   - Alphabetically sorted contact list
   - Alphabet scrubber for quick navigation
   - Liquid glass search bar with voice input button
   - 7 mock contacts with different relationship types

4. **Amber ID View**
   - Identity card with avatar and blue ring
   - Personality summary table with 6 traits
   - Horizontally scrollable stories carousel
   - Integration toggles (Apple Contacts, LinkedIn, Calendar)
   - Journal widget with text editor

5. **Design System**
   - Dark theme (background: #0A0A0A)
   - Glass morphism effects
   - Health dimension colors
   - Custom typography
   - Reusable components

## Getting Started

### Requirements

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Opening the Project

1. Open `Amber.xcodeproj` in Xcode
2. Select an iOS simulator (iPhone 15 Pro recommended)
3. Press `Cmd+R` to build and run

### Project Configuration

The project uses:
- **Architecture**: MVVM with Combine
- **UI Framework**: SwiftUI
- **Min Deployment**: iOS 17.0
- **Bundle ID**: com.amber.app

## Mock Data

The app currently uses mock data:

- **Connections**: 7 sample contacts (Alex, Sarah, Michael, Emily, David, Jennifer, Robert)
- **Insights**: 5 sample insights across different health dimensions
- **Amber ID**: Sample profile for "Sagar Tiwari"

## Next Steps (Phase 2)

### Backend Integration

1. **Install Supabase Swift SDK**
   ```
   File > Add Package Dependencies
   https://github.com/supabase-community/supabase-swift
   ```

2. **Create Supabase Tables**
   - `users` (Amber ID profiles)
   - `connections` (contacts)
   - `insights` (newsfeed items)
   - `personality_questions`

3. **Implement Services**
   - Create `SupabaseService.swift`
   - Add authentication
   - Connect ViewModels to real data

### AI Integration (Phase 3)

1. Add Claude API integration
2. Implement chat interface
3. Build insight generation
4. Implement personality assessment questions

## Design Philosophy

**Amber = Central Nervous System for Relationships**

Combining:
- **Dimensional**: Personality science depth
- **Perplexity**: Newsfeed intelligence
- **Apple Contacts**: Simple utility

The app uses the six-dimensional health model:
- 🔮 Spiritual
- ❤️ Emotional
- 🏃 Physical
- 🧠 Intellectual
- 👥 Social
- 💰 Financial

## Known Issues

- Xcode project file may need regeneration in Xcode for proper compilation
- Mock data only - no persistence
- No authentication yet
- Images/photos not implemented (using initials avatars)

## License

Proprietary - Amber

## Contact

For questions or support, contact the Amber team.

---

Built with ❤️ using SwiftUI
