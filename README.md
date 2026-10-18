# WakeWise

A smart alarm application built with Flutter for Android and iOS. WakeWise helps users build consistent morning routines through interactive cognitive and physical challenges, including Math, Memory, and Shake.

Built with **Clean Architecture** and **BLoC**, WakeWise is an offline-first mobile application featuring local alarm scheduling, a dynamic circadian theme engine, streak tracking, and wake-up analytics.

---

## ⚡ Tech Stack

| Layer / Concern | Technology |
| :--- | :--- |
| **Framework & Language** | Flutter 3.27+ / Dart 3.6+ |
| **State Management** | `flutter_bloc` (v8.1+) |
| **Architecture** | Clean Architecture (Domain, Data, Presentation, Core) |
| **Local Storage** | Hive |
| **Notifications** | Local notifications |
| **Routing** | `go_router` |
| **Analytics & Data Visualization** | `fl_chart` |
| **Design System** | Custom Material 3 design tokens |

---

## ✨ Features

### ⏰ Smart Alarm Management

- **Recurring & One-Time Alarms:** Configure alarms for specific days, weekdays, weekends, or individual dates.
- **Local Notifications:** Schedule alarms using local notification functionality, with support for offline use.

### 🧠 Challenge-Based Dismissal

- **Math Challenge:** Solve arithmetic problems before dismissing an alarm.
- **Memory Challenge:** Recall tile-sequence patterns on a 3×3 grid.
- **Shake Challenge:** Complete a movement target using accelerometer-based phone movement detection.

### 🌅 Multi-Stage Morning Quest

- **Chained Wake Missions:** Complete sequential tasks combining math, memory, and physical challenges.
- **Progress Feedback:** Track mission progress through visual and haptic feedback.

### 🎮 Gamification & Analytics

- **XP & Levels:** Earn experience points for completing supported wake-up activities.
- **Streaks & Achievements:** Track consecutive wake days and unlock achievement badges.
- **Visual Analytics:** Explore wake-up duration and consistency through charts powered by `fl_chart`.

### 🌓 Dynamic Circadian Theme Engine

The interface adapts to local time across four visual phases:

- 🌅 **Morning:** Warm sunrise cream and gold tones.
- ☀️ **Afternoon:** Dark, high-contrast focus mode.
- 🌇 **Evening:** Muted sunset peach and violet hues.
- 🌙 **Night:** Deep midnight navy palette.

---

## 🏗️ Architecture

WakeWise follows Clean Architecture to separate business logic, data handling, and presentation.

```text
lib/
├── core/                   # Theme engine, constants, services
├── data/                   # Data sources, models, repository implementations
├── domain/                 # Domain entities, repository interfaces, challenge logic
├── presentation/           # BLoCs, screens, reusable UI widgets
└── routes/                 # GoRouter configuration
```

### Architectural Layers

- **Domain:** Business entities, repository abstractions, and challenge logic.
- **Data:** Local persistence, data sources, models, and repository implementations.
- **Presentation:** BLoC state management, screens, and reusable UI components.
- **Core:** Shared services, theme management, constants, and design tokens.

---

## 🖼️ Screenshots

| Home Dashboard | Add / Edit Alarm | Morning Quest | Analytics |
| :---: | :---: | :---: | :---: |
| ![Home Screen](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/home.png) | ![Add Alarm](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/add_alarm.png) | ![Morning Quest](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/quest.png) | ![Analytics](https://raw.githubusercontent.com/MaiCoderHoon/wakewise/main/docs/screenshots/analytics.png) |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK:** 3.27.0 or later
- **Dart SDK:** 3.6.0 or later
- **Platform targets:** Android and iOS, subject to the project's current platform configuration

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

- **Layered Architecture:** Separates domain logic, data persistence, and presentation.
- **BLoC State Management:** Organizes application state and event-driven UI updates.
- **Reusable Design Tokens:** Uses shared styling definitions such as `AppSpacing`, `AppColors`, and `AppTypography`.
- **Offline-First Storage:** Uses local persistence to keep supported application data available without a network connection.
- **Dynamic Theming:** Adjusts the interface according to the local time of day.

---

## 🗺️ Roadmap

The following are planned enhancements, not necessarily implemented features:

- [ ] **Home Screen Widgets:** Native widgets displaying upcoming alarms.
- [ ] **Wearable Support:** Companion experiences for Wear OS and Apple Watch.
- [ ] **Cloud Sync & Backup:** Remote backup for alarm settings and streak records.
- [ ] **Sleep Insights:** Additional statistics about bedtime consistency and wake-up duration.

---

## 🤝 Contributing

Bug reports and feature suggestions are welcome through GitHub Issues.

Before submitting code changes, please review the repository's usage and copyright terms. Submitting a pull request does not automatically grant permission to use or redistribute the project outside the permissions granted by the copyright holder.

---

## 📄 Copyright & License

Copyright © 2026 WakeWise. All rights reserved.

This repository is provided for viewing and educational reference. No permission is granted to copy, modify, redistribute, sublicense, or use this code commercially without prior written permission from the copyright holder.

The source code is not offered under the MIT License or another open-source license. Access to this public repository does not grant general permission to reuse its contents.

---

## 👤 Author & Repository

- **GitHub:** [@MaiCoderHoon](https://github.com/MaiCoderHoon)
- **Repository:** [github.com/MaiCoderHoon/wakewise](https://github.com/MaiCoderHoon/wakewise)
