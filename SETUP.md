# ✨ Amber iOS App - Clean Setup Guide

All code has been regenerated fresh! Follow these steps to create the Xcode project.

---

## 📂 Current Directory Structure

```
amber-id/
├── Amber/                    ← All your Swift code is here!
│   ├── AmberApp.swift
│   ├── Extensions/
│   │   ├── Color+Amber.swift
│   │   └── Font+Amber.swift
│   ├── Models/
│   │   ├── AmberStory.swift
│   │   ├── AmberUser.swift
│   │   ├── Connection.swift
│   │   ├── HealthDimension.swift
│   │   ├── Insight.swift
│   │   └── PersonalityTypes.swift
│   ├── Components/
│   │   ├── ContactAvatar.swift
│   │   ├── HealthBadge.swift
│   │   └── LiquidGlassSearchBar.swift
│   ├── ViewModels/
│   │   ├── AmberIDViewModel.swift
│   │   ├── ConnectionsViewModel.swift
│   │   └── DiscoverViewModel.swift
│   └── Views/
│       ├── AmberIDView.swift
│       ├── ConnectionsView.swift
│       └── DiscoverView.swift
├── SETUP.md              ← You are here!
└── README.md
```

---

## 🚀 Step-by-Step Xcode Setup

### Step 1: Create New Xcode Project

1. **Open Xcode**
2. Click **"Create New Project"**
3. Select **iOS → App**
4. Click **Next**

### Step 2: Configure Project

Fill in these settings:
- **Product Name:** `Amber`
- **Team:** (Select your team or leave as None)
- **Organization Identifier:** `com.amber`
- **Bundle Identifier:** Will auto-fill as `com.amber.Amber`
- **Interface:** ✅ **SwiftUI**
- **Language:** ✅ **Swift**
- **Storage:** ❌ None
- **Include Tests:** ❌ Uncheck both

Click **Next**

### Step 3: Choose Location

**IMPORTANT:** Save it to:
```
/Users/sagartiwari/Desktop/Amber/amber-id/
```

This will create a new `Amber` folder next to your existing `Amber` folder.

Click **Create**

### Step 4: Delete Default Files

In Xcode Project Navigator (left sidebar), **delete these 2 files**:

1. Right-click `ContentView.swift` → **Delete** → **Move to Trash**
2. Right-click `AmberApp.swift` → **Delete** → **Move to Trash**

### Step 5: Add All Amber Files

1. In Xcode, **right-click** on the **Amber folder** (the blue folder icon at the top)
2. Select **"Add Files to 'Amber'..."**
3. Navigate to: `/Users/sagartiwari/Desktop/Amber/amber-id/Amber/`
4. Hold **⌘ Cmd** key and select **ALL these items**:
   - ✅ `AmberApp.swift`
   - ✅ `Extensions` folder
   - ✅ `Models` folder
   - ✅ `Views` folder
   - ✅ `ViewModels` folder
   - ✅ `Components` folder
5. **Important settings:**
   - ✅ **Copy items if needed** (CHECK THIS!)
   - ✅ **Create groups**
   - ✅ **Add to targets: Amber** (should be checked)
6. Click **Add**

### Step 6: Set iOS Deployment Target

1. Click on **Amber project** (blue icon at very top of navigator)
2. Select **Amber** target in the middle panel
3. Go to **General** tab
4. Find **Minimum Deployments**
5. Set **iOS** to **17.0**

### Step 7: Build & Run! 🎉

1. Select **iPhone 15 Pro** simulator (or any iOS 17+ device)
2. Press **⌘ + R** (or click the Play ▶️ button)
3. Wait for build to complete

---

## ✅ What You Should See

The app will launch with:

1. **Center Screen (Default):** Connections View
   - "My Card" at top
   - Alphabetical list of 3 contacts (Alex, Michael, Sarah)
   - Search bar at bottom

2. **Swipe Left:** Discover View
   - Category tabs (For You, Spiritual, Emotional, etc.)
   - 5 insight cards

3. **Swipe Right:** Amber ID View
   - Profile card with avatar
   - Personality summary (6 traits)
   - Stories carousel (3 cards)
   - Journal widget

---

## 🐛 Troubleshooting

### Build Errors?

**Solution 1:** Clean Build Folder
- Press `⌘ + Shift + K`
- Then build again `⌘ + R`

**Solution 2:** Check File Membership
- Select any `.swift` file
- Check **File Inspector** (right panel)
- Make sure **Target Membership → Amber** is ✅ checked

**Solution 3:** Restart Xcode
- Quit Xcode completely (`⌘ + Q`)
- Reopen the project

### White Screen?

Make sure you:
1. Deleted the default `ContentView.swift` and `AmberApp.swift`
2. Added ALL files from the `Amber/` folder
3. Set iOS deployment to 17.0

### Files Not Found?

If Xcode shows red files:
1. Select the red file
2. In **File Inspector**, click the folder icon
3. Navigate to the actual file location
4. Click **Choose**

---

## 🎯 Next Steps

Once the app is running:

1. **Explore the three screens** by swiping
2. **Test the search bar** in Connections
3. **Tap category tabs** in Discover
4. **Type in the journal** in Amber ID

Ready for Phase 2? Check `README.md` for backend integration steps!

---

## 📊 Project Stats

- **Swift Files:** 18
- **Lines of Code:** ~1,200
- **Mock Contacts:** 3
- **Mock Insights:** 5
- **Health Dimensions:** 6
- **Personality Traits:** 6

Built with SwiftUI ❤️
