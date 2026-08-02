<p align="center">
  <img src="https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/assets/logo.png" width="120" alt="WakeWise Logo" />
</p>

<h1 align="center">WakeWise</h1>

<p align="center">
  <strong>The Next-Generation Smart Alarm & Morning Consistency Engine</strong>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.27+-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Version" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.6+-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Version" /></a>
  <a href="https://pub.dev/packages/flutter_bloc"><img src="https://img.shields.io/badge/State_Management-BLoC_v8.1-blueviolet?style=for-the-badge&logo=bloc" alt="BLoC Architecture" /></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License: MIT" /></a>
  <a href="https://github.com/MaiCoderHoon/wakewise/actions"><img src="https://img.shields.io/badge/Build-Passing-brightgreen?style=for-the-badge&logo=github-actions" alt="Build Status" /></a>
</p>

<p align="center">
  <a href="#about">About</a> •
  <a href="#key-features">Key Features</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#installation">Installation</a> •
  <a href="#why-wakewise">Why WakeWise?</a> •
  <a href="#roadmap">Roadmap</a> •
  <a href="#contributing">Contributing</a> •
  <a href="#license">License</a>
</p>

---

## 📌 About WakeWise

**WakeWise** is an open-source, production-grade smart alarm and cognitive activation mobile application built with **Flutter**. Unlike conventional alarm clocks that are trivially snoozed or dismissed out of habit, WakeWise combines **cognitive challenge-based dismissal**, **multi-stage Morning Quests**, **circadian ambient UI adaptation**, and **habit gamification** to guarantee that you wake up alert, energized, and ready for your day.

Engineered with strict adherence to **Clean Architecture** principles and **BLoC (Business Logic Component)** state management, WakeWise serves both as a feature-complete productivity tool for users and a reference implementation for engineers looking to build scalable, production-ready Flutter applications.

---

## ✨ Key Features

### ⏰ Smart Alarm Engine
* **Multiple Alarm Management**: Configure recurring, single-instance, or weekday/weekend custom alarms with precise schedule settings.
* **Precise Local Notification Scheduling**: Low-latency, offline-first native alarm triggers utilizing system-level notifications and full-screen alerts.
* **Granular Repeat Schedules**: Custom weekday selections (e.g., Mon–Fri, Weekends, or specific days).

### 🧠 Cognitive Challenge Dismissal
* **Math Challenge**: Solve dynamic arithmetic equations (customizable from Easy to Hard) to stimulate logical reasoning.
* **Memory Recall Challenge**: Pattern memory grid tests requiring sequential recall to activate short-term working memory.
* **Energy Shake Challenge**: Uses device accelerometer thresholds to ensure physical motion and movement before alarm silencing.

### 🌅 Multi-Stage Morning Quest
* **Progressive Wake Routine**: Chained multi-stage wake missions combining cognitive puzzles and movement in sequential progression to transition the brain into peak alertness.
* **Real-time Mission Feedback**: Instant haptic feedback and transient overhead banners tracking stage completion.

### 🎮 Gamification & Habits
* **Streak & Level Progression**: Earn XP (Experience Points) upon every successful morning wake-up. Level up from Novice Waker to Master Waker.
* **Achievement System**: Unlockable badges (`Early Bird`, `Math Genius`, `Unstoppable Streak`, `Motion Master`) with local progress tracking.
* **Consistency Analytics**: Visual breakdown of average wake delays, streak length, and weekly consistency metrics using interactive charts.

### 🌓 Dynamic Circadian Theme Engine
* **Ambient Time-of-Day Adaptation**: Automatically transitions interface styling across four distinct circadian phases:
  * 🌅 **Morning Sunrise**: Warm cream and gold gradients.
  * ☀️ **Afternoon Focus**: Sleek dark slate and minimalist neon accents inspired by Linear and Nothing OS.
  * 🌇 **Evening Sunset**: Muted peach and violet hues.
  * 🌙 **Night Midnight Navy**: Deep navy and dark blue tones optimized for night-time legibility and eye comfort.

---

## 🛠️ Tech Stack

WakeWise is engineered using modern, production-tested libraries and patterns from the Flutter and Dart ecosystems:

| Layer / Subsystem | Technology | Purpose |
| :--- | :--- | :--- |
| **Framework** | [Flutter SDK](https://flutter.dev) (v3.27+) | Cross-platform UI engine |
| **Language** | [Dart](https://dart.dev) (v3.6+) | Strongly typed reactive core |
| **State Management** | [flutter_bloc](https://pub.dev/packages/flutter_bloc) (v8.1+) | Unidirectional data flow & state isolation |
| **Local Database** | [Hive](https://pub.dev/packages/hive) / Local Storage | High-performance NoSQL offline data storage |
| **Notifications** | Native Local Notifications | High-priority local background alarms & banners |
| **Routing** | [GoRouter](https://pub.dev/packages/go_router) | Declarative type-safe routing with deep linking support |
| **Charts** | [fl_chart](https://pub.dev/packages/fl_chart) | Highly customizable interactive analytics charts |
| **Design System** | Material 3 & Custom Tokens | Custom component design system built on Material Design 3 |

---

## 🏗️ Architecture

WakeWise follows **Clean Architecture** as proposed by Robert C. Martin (Uncle Bob), decoupled into strict functional layers. This guarantees testability, maintainability, and clean separation of concerns.

```text
lib/
├── core/                   # Cross-cutting concerns, theme engine, constants, services
│   ├── constants/          # Colors, spacing, typography, and animation tokens
│   ├── services/           # TimeOfDayService, System services
│   └── theme/              # Circadian themes (Morning, Afternoon, Evening, Night)
├── data/                   # Data layer (Data sources, Repositories implementations, DTOs)
│   ├── datasources/        # Local storage (Hive / SharedPreferences data sources)
│   ├── models/             # Data transfer objects and JSON serialization
│   └── repositories/       # Concrete implementations of Domain Repositories
├── domain/                 # Domain layer (Pure Dart business logic, Entities, Interfaces)
│   ├── challenges/         # Challenge engine entities (Math, Memory, Shake)
│   ├── entities/           # Core business models (Alarm, UserStats, Achievement)
│   └── repositories/       # Abstract repository interfaces
├── presentation/           # Presentation layer (UI screens, custom widgets, BLoCs)
│   ├── blocs/              # AlarmBloc, MissionBloc, GamificationBloc, StatsBloc
│   ├── screens/            # Screen views (Home, AddEditAlarm, AlarmRing, Analytics, etc.)
│   └── widgets/            # Reusable UI component system (AppCard, AppHeroHeader, etc.)
└── routes/                 # Declarative GoRouter configuration
```

### Layer Responsibilities

1. **Domain Layer**: The heart of the application. Contains pure Dart entities, challenge interfaces, and repository contracts. Has **zero dependencies** on Flutter UI or external packages.
2. **Data Layer**: Responsible for data fetching, local persistence (Hive), and mapping raw data structures into domain entities. Implements repository contracts defined in the Domain layer.
3. **Presentation Layer**: Houses BLoC state managers, Flutter UI screens, and custom reusable design system widgets. Consumes domain state via standard BLoCs.
4. **Core Layer**: Manages application-wide utilities, circadian theme switching logic (`DynamicThemeManager`), system constants, and shared services.

---

## 🖼️ Screenshots

| Home Dashboard | Add / Edit Alarm | Morning Quest | Analytics & Trends |
| :---: | :---: | :---: | :---: |
| ![Home Screen](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/home.png) | ![Add Alarm](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/add_alarm.png) | ![Morning Quest](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/quest.png) | ![Analytics](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/analytics.png) |

---

## 🚀 Installation & Setup

### Prerequisites

Ensure your development environment meets the following requirements:
* **Flutter SDK**: `>= 3.27.0`
* **Dart SDK**: `>= 3.6.0`
* **Android Studio** / **VS Code** with Flutter extensions installed
* **Target Platforms**: Android (API Level 21+) or iOS (iOS 13.0+)

### Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone https://github.com/MaiCoderHoon/wakewise.git
   cd wakewise
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Static Analysis & Tests**
   ```bash
   flutter analyze
   flutter test
   ```

4. **Launch Application**
   ```bash
   # Run on connected device or emulator
   flutter run
   ```

---

## 🌟 Why WakeWise?

* 💎 **Clean Architecture & Scalability**: Built from day one with enterprise-grade folder structures and unidirectional data flow, making it ideal for teams and open-source contributors.
* 🎨 **Reusable Design System**: Custom design tokens (`AppSpacing`, `AppColors`, `AppTypography`) powering modular components (`AppCard`, `AppHeroHeader`, `AppQuickActionRow`) for uniform styling.
* 🌗 **Dynamic Circadian Themes**: Seamless real-time theme adaptation based on time-of-day boundaries, reducing eye strain and enhancing user delight.
* ⚡ **Predictable BLoC State Management**: Completely isolated business logic enabling straightforward unit testing, mock testing, and deterministic UI state updates.
* 🏆 **Deep Gamification Integration**: High-retention streak tracking and XP progression system transforming wake-up routines into an enjoyable habit loop.

---

## 🗺️ Roadmap

We are actively expanding WakeWise to introduce further smart habit and health integration features:

- [ ] **Cloud Backup & Restore**: Encrypted cross-device backup for alarms, stats, and badges.
- [ ] **WearOS & Apple Watch Support**: Companion apps for haptic wrist alarms and heart-rate sync.
- [ ] **AI Sleep & Routine Insights**: On-device machine learning recommendations for optimal bedtime and alarm timing.
- [ ] **Home Screen Widgets**: Native iOS WidgetKit & Android Home Screen widgets for instant alarm previews.
- [ ] **Smart Ambient Soundscapes**: White noise, rain, and sunrise audio generators for sleep preparation.

---

## 🤝 Contributing

Contributions are welcome and highly appreciated! Whether you are fixing bugs, improving documentation, or proposing new features, please follow these steps:

1. **Fork the Repository**
2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit Your Changes**
   ```bash
   git commit -m "feat: add amazing new feature"
   ```
4. **Push to Your Branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

Please ensure your code passes `flutter analyze` and `flutter test` prior to submitting a PR.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.

---

## 👤 Author

**WakeWise Engineering Team**

* GitHub: [@MaiCoderHoon](https://github.com/MaiCoderHoon)
* Project Repository: [https://github.com/MaiCoderHoon/wakewise](https://github.com/MaiCoderHoon/wakewise)

---

<p align="center">
  Crafted with ❤️ to <strong>Wake-wisely</strong>
</p>
