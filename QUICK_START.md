# Amber iOS App - Quick Start Guide

## 🚀 Project Summary

**Status**: ✅ Phase 1 Complete - Static UI with Mock Data
**Lines of Code**: ~1,565 Swift LOC
**Files Created**: 17 Swift files + Project configuration
**Architecture**: MVVM + SwiftUI + Combine

---

## 📱 What's Built

### Three Main Screens (Horizontal Paging)

1. **Discover** (Left Screen)
   - Category tabs: "For You" + 6 health dimensions
   - 5 insight cards with different types
   - Full scrolling support

2. **Connections** (Center Screen - Default)
   - "My Card" row at top
   - 7 mock contacts alphabetically sorted
   - Alphabet scrubber (A-Z quick nav)
   - Liquid glass search bar with voice button
   - Contact detail view ready

3. **Amber ID** (Right Screen)
   - Identity card with blue ring avatar
   - 26 connections count
   - Personality summary (6 traits)
   - Stories carousel (3 story cards)
   - Integration toggles (3 services)
   - Journal widget with text editor

---

## 🎨 Design System

### Colors
- Background: `#0A0A0A` (near black)
- Cards: `#1C1C1E`, `#2C2C2E` (elevated)
- Accent Blue: `#4A90D9`
- Health Dimensions:
  - Spiritual: `#9B59B6` (purple)
  - Emotional: `#E74C3C` (red)
  - Physical: `#27AE60` (green)
  - Intellectual: `#F39C12` (orange)
  - Social: `#3498DB` (blue)
  - Financial: `#1ABC9C` (teal)

### Components
- Liquid glass search bar (blur + frosted glass)
- Health dimension badges
- Contact avatars (with initials fallback)
- Story cards (emoji + title + subtitle)
- Integration toggles
- Journal widget

---

## 🏗️ Architecture

```
MVVM Pattern:
- Models: Data structures (Codable)
- Views: SwiftUI views
- ViewModels: @Published state + business logic (@MainActor)
- Components: Reusable UI elements
```

### Mock Data Included

**Connections (7):**
1. Alex Thompson - Tech Innovations Inc
2. Sarah Johnson - Design Studio
3. Michael Chen - Global Ventures
4. Emily Rodriguez - Wellness Co
5. David Park - Startup Labs (Mentor)
6. Jennifer Kim - Marketing Pro
7. Robert Williams - Finance Group (Mentor)

**Insights (5):**
1. Emotional: Strengthen bond with Sarah
2. Intellectual: Science of deep conversations
3. Social: 30-day connection streak
4. Spiritual: Score increased +12
5. Financial: Network opportunity with Michael

**Amber ID:**
- Name: Sagar Tiwari
- Personality: Tranquility, Extrovert, Feelings-based
- 3 story cards
- 3 integration options

---

## 🛠️ Opening in Xcode

### Method 1: Create New Project (Recommended)

Since the project was created programmatically, you'll need to set it up in Xcode:

1. **Open Xcode**
2. **File → New → Project**
3. Choose **iOS → App**
4. Settings:
   - Product Name: `Amber`
   - Team: Your team
   - Organization Identifier: `com.amber`
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None
   - Testing: Uncheck all
5. Save to: `/Users/sagartiwari/Desktop/Amber/amber-id-xcode` (new location)
6. **Delete the default files** Xcode created:
   - `ContentView.swift`
   - `AmberApp.swift` (the default one)
7. **Copy all files** from `/Users/sagartiwari/Desktop/Amber/amber-id/Amber/` to the new project
8. **Add to project**: Right-click project → Add Files to "Amber" → Select all folders
9. **Build Settings**:
   - iOS Deployment Target: **17.0**
   - Supports Portrait only

### Method 2: Manual pbxproj Fix

If you want to use the existing project:

1. Open `/Users/sagartiwari/Desktop/Amber/amber-id/Amber.xcodeproj`
2. If errors occur, regenerate with Method 1

---

## 🧪 Testing the App

### Build & Run

1. Select **iPhone 15 Pro** simulator (or any iOS 17+ device)
2. Press `Cmd + R` or click the Play button
3. Wait for build to complete

### Navigation Testing

- **Swipe left**: Discover → Connections
- **Swipe right**: Connections → Amber ID
- **Default start**: Connections view (center)

### Feature Testing

**Discover View:**
- Tap category tabs to filter insights
- Scroll through insight cards
- Tap cards (action placeholder)

**Connections View:**
- Scroll through contacts (A-Z)
- Tap alphabet scrubber for quick jump
- Type in search bar to filter
- Tap + button (placeholder)
- Tap contact row (placeholder)

**Amber ID View:**
- View identity card
- Scroll stories horizontally
- Toggle integrations (state persists)
- Type in journal widget
- Tap "Save" button (placeholder)

---

## 🔧 Customization

### Change User Profile

Edit `Amber/Models/AmberUser.swift`:

```swift
static let placeholder = AmberUser(
    name: "Your Name",        // Change this
    email: "your@email.com",  // And this
    // ... rest of the properties
)
```

### Add More Connections

Edit `Amber/ViewModels/ConnectionsViewModel.swift`:

```swift
private func loadMockData() {
    connections = [
        // Add your connections here
        Connection(name: "New Person", ...)
    ]
}
```

### Add More Insights

Edit `Amber/ViewModels/DiscoverViewModel.swift`:

```swift
private func loadMockData() {
    insights = [
        // Add your insights here
        Insight(title: "New Insight", ...)
    ]
}
```

---

## 📋 Acceptance Criteria Checklist

- ✅ Three-screen horizontal paging works smoothly
- ✅ Discover screen shows categorized insight cards
- ✅ Connections screen shows alphabetical contact list with scrubber
- ✅ Amber ID screen displays wallet-style identity card
- ✅ All screens match dark aesthetic
- ✅ Liquid glass search bar on Connections screen
- ✅ Stories carousel is horizontally scrollable
- ✅ Integration toggles work (state persists)
- ✅ Journal widget allows text input

**Phase 1 Complete!** 🎉

---

## 🚧 Next Steps

### Phase 2: Backend Integration

1. Add **Supabase Swift SDK**:
   ```
   https://github.com/supabase-community/supabase-swift
   ```

2. Create `.env` file:
   ```
   SUPABASE_URL=your_project_url
   SUPABASE_KEY=your_anon_key
   ```

3. Implement `SupabaseService.swift`:
   - Authentication
   - CRUD operations
   - Real-time subscriptions

4. Replace mock data in ViewModels

### Phase 3: AI Features

1. Add **Claude API** integration
2. Implement personality questions
3. Generate insights dynamically
4. Add chat interface

---

## 💡 Tips

### Performance
- Use `.task { }` for async loading
- ViewModels use `@MainActor` for thread safety
- Lazy loading for large lists

### Debugging
- Check Xcode console for print statements
- Use Xcode Previews for quick UI iteration
- Breakpoints in ViewModels to track state

### Common Issues

**Issue**: Build fails with type errors
**Fix**: Clean build folder (`Cmd+Shift+K`), rebuild

**Issue**: Preview crashes
**Fix**: Restart Xcode, rebuild

**Issue**: UI not updating
**Fix**: Check `@Published` properties in ViewModels

---

## 📚 Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Combine Framework](https://developer.apple.com/documentation/combine)
- [Supabase Swift SDK](https://github.com/supabase-community/supabase-swift)

---

## ✨ Features Showcase

**Unique Features:**
- Six-dimensional health tracking
- Personality science integration
- Relationship impact scoring
- AI-powered insights (Phase 3)
- Wallet-style identity card

**Technical Highlights:**
- MVVM architecture
- Reactive programming with Combine
- Dark mode native design
- Gesture-based navigation
- Glass morphism UI effects

---

**Built with SwiftUI** ❤️

Need help? Check `README.md` for detailed documentation.
