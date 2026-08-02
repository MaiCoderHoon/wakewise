# WakeWise

A smart alarm application for Android and iOS built with Flutter. WakeWise helps users build consistent morning routines by requiring interactive cognitive and physical challenges (Math, Memory, Shake) to dismiss alarms.

Built using **Clean Architecture** and **BLoC**, WakeWise is an offline-first mobile application featuring a dynamic circadian theme engine, local notification scheduling, streak tracking, and wake-up analytics.

---

## ⚡ Tech Stack

| Layer / Concern | Technology |
| :--- | :--- |
| **Framework & Language** | Flutter 3.27+ / Dart 3.6+ |
| **State Management** | `flutter_bloc` (v8.1+) |
| **Architecture** | Clean Architecture (Domain, Data, Presentation, Core) |
| **Local Storage** | Hive |
| **Notifications** | Native System Local Notifications |
| **Routing** | `go_router` |
| **Analytics & Data Vis** | `fl_chart` |
| **Design System** | Custom Material 3 Dynamic Tokens |

---

## ✨ Features

### ⏰ Smart Alarm Management
- **Recurring & One-Time Alarms**: Schedule alarms with custom repeat days (weekdays, weekends, or specific days).
- **Local Notification Scheduling**: Trigger full-screen alerts and sound alarms offline using native system notifications.

### 🧠 Challenge-Based Dismissal
- **Math Challenge**: Solve arithmetic problems (configurable difficulty) before silencing alarms.
- **Memory Challenge**: Recall tile sequence patterns on a 3x3 grid.
- **Shake Challenge**: Accelerometer-based phone movement counter to ensure physical activity.

### 🌅 Multi-Stage Morning Quest
- **Chained Wake Missions**: Sequential multi-step routines combining math, memory, and physical shake tasks.
- **Haptic & Visual Feedback**: Real-time progress feedback with overhead banner overlays.

### 🎮 Gamification & Analytics
- **XP & Level System**: Earn XP for on-time alarm completion and track overall level progression.
- **Streak & Achievements**: Monitor consecutive wake days and unlock achievement badges.
- **Visual Analytics**: Interactive charts powered by `fl_chart` to track wake duration and consistency.

### 🌓 Dynamic Circadian Theme Engine
- **Time-Based Theme Switching**: Interface automatically transitions across four circadian phases based on local time:
  - 🌅 **Morning**: Warm sunrise cream & gold tones.
  - ☀️ **Afternoon**: High-contrast dark focus mode.
  - 🌇 **Evening**: Muted sunset peach & violet hues.
  - 🌙 **Night**: Deep midnight navy palette.

---

## 🏗️ Architecture

WakeWise follows Clean Architecture to separate business rules from UI and framework code:

```text
lib/
├── core/                   # Theme engine, constants, services
├── data/                   # Data sources, models, repository implementations
├── domain/                 # Domain entities, repository interfaces, challenge logic
├── presentation/           # BLoCs, screens, reusable UI widgets
└── routes/                 # Declarative GoRouter configuration
```

- **Domain**: Pure Dart objects (`Alarm`, `UserStats`, `BaseChallenge`) and repository abstractions. Independent of Flutter UI.
- **Data**: Manages Hive local database persistence and maps data models to domain entities.
- **Presentation**: BLoC state management (`AlarmBloc`, `MissionBloc`, `GamificationBloc`, `StatsBloc`) and UI components.
- **Core**: Circadian theme engine (`DynamicThemeManager`), time-of-day calculations, and styling tokens.

---

## 🖼️ Screenshots

| Home Dashboard | Add / Edit Alarm | Morning Quest | Analytics |
| :---: | :---: | :---: | :---: |
| ![Home Screen](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/home.png) | ![Add Alarm](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/add_alarm.png) | ![Morning Quest](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/quest.png) | ![Analytics](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/analytics.png) |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: `>= 3.27.0`
- **Dart SDK**: `>= 3.6.0`
- **Platform Targets**: Android (API 21+) or iOS (13.0+)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MaiCoderHoon/wakewise.git
   cd wakewise
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run static analysis and tests**
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch the app**
   ```bash
   flutter run
   ```

---

## 🎯 Technical Highlights

- **Clean Layer Separation**: Decoupled domain models and repository abstractions simplify unit testing and feature extensions.
- **Unidirectional Data Flow**: Isolated BLoCs handle state transitions for alarm scheduling, task validation, and gamification updates.
- **Reusable Component Tokens**: Standardized design tokens (`AppSpacing`, `AppColors`, `AppTypography`) power consistent UI elements across screens.
- **Offline Storage**: Persistent local database using Hive for fast load times and offline execution.

---

## 🗺️ Roadmap

- [ ] **Home Screen Widgets**: Android and iOS native home screen widgets displaying upcoming alarms.
- [ ] **Wearable App Support**: WearOS / Apple Watch companion apps for haptic wrist alarms.
- [ ] **Cloud Sync & Backup**: Encrypted remote backup for alarm settings and streak records.
- [ ] **Smart Sleep Insights**: Local statistics on bedtime consistency and average wake speed.

---

## 🤝 Contributing

Contributions are welcome! Feel free to report issues, submit feature requests, or open pull requests:

1. Fork the project repository.
2. Create a topic branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.

---

## 👤 Author

**Maintainer**
- GitHub: [@MaiCoderHoon](https://github.com/MaiCoderHoon)
- Repository: [github.com/MaiCoderHoon/wakewise](https://github.com/MaiCoderHoon/wakewise)
