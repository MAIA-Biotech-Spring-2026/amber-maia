# Amber — The Health Network

> **Your health is shaped by the people around you. Amber makes that visible.**

---

## What is Amber?

Amber is a **health network** — a personal platform that connects your wellbeing data, personality insights, and social connections into one unified view. It tracks six dimensions of health and shows how your relationships, habits, and daily choices influence each one.

Amber is not a fitness tracker. It's not a social media app. It's the connective layer between your health, your people, and your self-awareness.

---

## Six Dimensions of Health

Amber scores your wellbeing across six interconnected dimensions:

| Dimension | Color | What It Tracks |
|-----------|-------|----------------|
| 🔮 Spiritual | Purple | Inner peace, purpose, mindfulness |
| ❤️ Emotional | Red | Mood, feelings, emotional regulation |
| 🏃 Physical | Green | Activity, sleep, exercise, movement |
| 🧠 Intellectual | Orange | Learning, curiosity, mental engagement |
| 👥 Social | Blue | Connection quality, community, belonging |
| 💰 Financial | Teal | Career health, professional networking |

Each dimension is scored 0–100 and tracked over time through daily digests powered by AI.

---

## Core Features

### Contacts
Unified contact management with rich profiles, personality data, and relationship context. Import from Apple Contacts or add manually.

### Network Visualizations
Three ways to see your people:
- **Amber Network** — Interactive bubble chart showing connection strength by health dimension
- **Family Network** — Hierarchical tree view of family relationships
- **Find My Friends** — Geographic visualization of your network

### Profile (Amber ID)
Your identity card with:
- Live activity tracking (Move, Exercise, Stand, Sleep, Screen Time)
- Personality insights (MBTI, Enneagram, Zodiac sun/moon/rising)
- Daily check-in (emotions, energy, cycle, sleep)
- Six daily digests with AI-powered chat for each health dimension
- Connected apps and data source management

### AI Insights
Perplexity-style chat interface for each health dimension. Ask questions about your patterns, get personalized recommendations, and understand how your relationships affect your wellbeing.

### Connected Data Sources
Integrate with Apple Health, Apple Contacts, Location Services, Google Calendar, Gmail, Instagram, Facebook, TikTok, LinkedIn, X, Substack, Claude, and ChatGPT.

---

## Tech Stack

- **SwiftUI** — Declarative UI framework
- **Combine** — Reactive data flow
- **MVVM** — Clean architecture pattern
- **iOS 17.0+** — Minimum deployment target
- **Zero dependencies** — Pure Apple frameworks (SwiftUI, Combine, Foundation, UIKit)

---

## Project Structure

```
AmberApp/
├── AmberApp.swift              # App entry point (3 tabs)
├── Models/                     # Data models
├── ViewModels/                 # Business logic
├── Views/                      # Screen-level views
│   └── Profile/                # Profile sub-views
├── Components/                 # Reusable UI components
├── Extensions/                 # Color + Font extensions
├── Services/                   # Service layer (future)
└── Assets.xcassets/            # App icons, images
```

---

## Getting Started

```bash
git clone https://github.com/sagartiw/amber.git
cd amber/AmberApp
open AmberApp.xcodeproj
```

Select **iPhone 15 Pro** simulator → `Cmd+R` to build and run.

See **SETUP.md** for detailed configuration and troubleshooting.

---

## Roadmap

**Now:** iOS client with three tabs (Contacts, Network, Profile), personality tests, daily digests with AI chat, health tracking integration, connected data sources.

**Next:** Service layer, backend API, onboarding wizard, iMessage AI prompts, real-time sync.

**Future:** Web app (Journey — enterprise context tool via Amber ID), practitioner dashboard (Togari), Android app, public API.

---

## Privacy

- All data stored locally on device
- No ads, no data selling
- You control which data sources connect
- Export your data anytime

---

## License

Proprietary — Amber Technologies Inc.

---

**Built with SwiftUI ❤️**
