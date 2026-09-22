# Softel B2B Application

A modern, high-performance Flutter B2B e-commerce mobile and cross-platform application built with GetX state management, clean architecture, and responsive UI components.

---

## Overview

Softel B2B provides business clients with a seamless digital commerce experience, including product catalog discovery, multi-category browsing, real-time cart and order tracking, multi-language localization, and secure enterprise authentication.

---

## Features

- **Enterprise Authentication:** Company selection, credentials login, Google Sign-In integration, and secure session management with `flutter_secure_storage`.
- **Product Catalog & Search:** Real-time search, family/sub-family categorization, dynamic product grids, and cached image previews.
- **Cart & Order Management:** Reactive shopping cart state, real-time quantity updates, order confirmation, and parcel tracking.
- **Localization:** Multi-language support (English, Arabic, French) with reactive locale switching via GetX.
- **Responsive Architecture:** Clean separation of concerns with controllers, bindings, services, data models, and reusable UI components.

---

## Technology Stack

- **Framework:** [Flutter](https://flutter.dev/) (Channel Stable) & [Dart](https://dart.dev/)
- **State Management & Routing:** [GetX](https://pub.dev/packages/get)
- **Backend & Authentication:** Firebase Core, Google Sign-In, RESTful API client
- **Storage:** `shared_preferences`, `flutter_secure_storage`
- **Networking:** HTTP with custom CRUD helper abstractions
- **UI Components:** Custom SVG icons, Lottie animations, cached network images, carousel widgets

---

## Project Structure

```text
softel/
├── android/                   # Android native configuration & Gradle scripts
├── ios/                       # iOS native configuration & Xcode project
├── lib/
│   ├── bindings/              # Dependency injection bindings
│   ├── controller/            # GetX controllers (Auth, Cart, Home, Products, Tracking)
│   ├── core/                  # Theme, localization, constants, middleware, services
│   ├── data/                  # Data models and API definitions
│   ├── features/              # Feature modules & modular bindings
│   ├── view/                  # Screens and reusable UI widgets
│   ├── linkapi.dart           # API endpoint definitions
│   ├── routes.dart            # Application route definitions
│   └── main.dart              # Application entry point
├── assets/                    # SVG icons, images, fonts, and Lottie animations
├── test/                      # Unit and widget tests
├── pubspec.yaml               # Package dependencies and asset configurations
└── .gitignore                 # Version control ignore rules
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `>=3.8.1`)
- [Dart SDK](https://dart.dev/get-dart)
- Android Studio / VS Code with Flutter extensions
- Android SDK & Build Tools (for Android development)
- Xcode & CocoaPods (for iOS macOS development)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/khaledbouhoun/Softel-Frontend.git
   cd Softel-Frontend
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables:**
   Copy the example environment template and fill in your client credentials:
   ```bash
   cp .env.example .env
   ```
   Provide your specific `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET` in `.env`.

4. **Configure Firebase:**
   - Place your `google-services.json` inside `android/app/` (refer to `android/app/google-services.example.json`).
   - Place your `GoogleService-Info.plist` inside `ios/Runner/`.
   - Alternatively, generate `lib/firebase_options.dart` using the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/):
     ```bash
     flutterfire configure
     ```

5. **Configure Android Keystore (Optional for Release Builds):**
   Copy `android/key.properties.example` to `android/key.properties` and provide your signing credentials if building signed release APKs/bundles.

---

## Running the Application

### Development Mode

```bash
flutter run
```

### Run Static Analysis

```bash
flutter analyze
```

### Run Tests

```bash
flutter test
```

### Build Android APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

---

## License

This project is proprietary and confidential. All rights reserved.
