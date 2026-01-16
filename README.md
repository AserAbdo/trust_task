# 🍔 Dushka Burger - Flutter Food Ordering App

A professional Flutter food ordering application built with **Clean Architecture** and **Cubit** state management. This app demonstrates best practices in Flutter development including proper separation of concerns, dependency injection, and comprehensive error handling.

![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green?style=for-the-badge)
![State Management](https://img.shields.io/badge/State-Cubit-blueviolet?style=for-the-badge)

---

## 📱 Screenshots

| Categories Screen | Product Details | Cart Screen |
|:---:|:---:|:---:|
| Browse categories and products | View details with addons | Manage your cart |

---

## ✨ Features

### Screens Implemented
- **📋 Categories Screen** - Browse food categories with products listing
- **🍕 Product Details Screen** - View product info, select addons, adjust quantity
- **🛒 Cart Screen** - Manage cart items, apply coupons, view payment summary

### Technical Features
- ✅ **Clean Architecture** - Domain, Data, Presentation layers
- ✅ **Cubit State Management** - Reactive and predictable state
- ✅ **Guest User Flow** - Full functionality without login
- ✅ **English & Arabic Localization** - RTL support included
- ✅ **Dependency Injection** - Using GetIt for loose coupling
- ✅ **Error Handling** - Comprehensive error states with retry
- ✅ **Cached Images** - Efficient image loading and caching
- ✅ **Material Design 3** - Modern and beautiful UI

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles by Uncle Bob, ensuring:
- Independence of frameworks
- Testability
- Independence of UI
- Independence of Database
- Independence of external agencies

### Layer Structure

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Pages     │  │   Widgets   │  │   Cubit + States    │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌─────────────────┐  ┌────────────────┐   │
│  │  Entities   │  │   Repositories  │  │   Use Cases    │   │
│  │  (Models)   │  │   (Abstract)    │  │ (Business Logic│   │
│  └─────────────┘  └─────────────────┘  └────────────────┘   │
├─────────────────────────────────────────────────────────────┤
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌─────────────────┐  ┌────────────────┐   │
│  │   Models    │  │  Data Sources   │  │  Repository    │   │
│  │   (DTOs)    │  │   (Remote/Local)│  │  Implementation│   │
│  └─────────────┘  └─────────────────┘  └────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/
│   │   ├── api_constants.dart      # API endpoints & auth
│   │   └── app_constants.dart      # App-wide constants
│   ├── di/
│   │   └── injection_container.dart # GetIt DI setup
│   ├── error/
│   │   ├── exceptions.dart         # Custom exceptions
│   │   └── failures.dart           # Failure classes
│   ├── l10n/
│   │   └── app_localizations.dart  # EN/AR translations
│   ├── network/
│   │   └── api_client.dart         # Dio HTTP client
│   ├── theme/
│   │   └── app_theme.dart          # Material theme
│   └── utils/
│       └── guest_manager.dart      # Guest ID management
│
├── features/                       # Feature modules
│   ├── categories/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── categories_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── category_model.dart
│   │   │   └── repositories/
│   │   │       └── categories_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── category.dart
│   │   │   ├── repositories/
│   │   │   │   └── categories_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_categories_usecase.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── categories_cubit.dart
│   │       │   └── categories_state.dart
│   │       ├── pages/
│   │       │   └── categories_page.dart
│   │       └── widgets/
│   │           ├── category_tab.dart
│   │           └── product_card.dart
│   │
│   ├── product_details/            # Same structure
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── cart/                       # Same structure
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart                       # App entry point
```

---

## 📦 Dependencies Explained

| Package | Version | Purpose |
|---------|---------|---------|
| **flutter_bloc** | ^9.1.0 | State management using BLoC pattern (Cubit). Provides reactive state management with clear separation between UI and business logic. |
| **equatable** | ^2.0.7 | Simplifies value equality comparisons. Used for state classes and entities to avoid boilerplate == and hashCode implementations. |
| **dio** | ^5.8.0+1 | Powerful HTTP client for API calls. Supports interceptors, FormData, request cancellation, and automatic JSON parsing. |
| **get_it** | ^8.0.3 | Simple service locator for dependency injection. Allows loose coupling between classes and easier unit testing. |
| **dartz** | ^0.10.1 | Functional programming package providing Either type. Used for error handling without exceptions (Right = success, Left = failure). |
| **cached_network_image** | ^3.4.1 | Downloads and caches images. Shows placeholders during loading and error widgets for failed loads. |
| **shared_preferences** | ^2.5.3 | Persistent storage for simple data. Used to store guest_id locally so it persists between app sessions. |
| **intl** | ^0.20.2 | Internationalization and localization utilities. Handles date formatting, number formatting, and locale-specific strings. |
| **flutter_localizations** | SDK | Built-in Flutter package for Material/Cupertino widget translations. Required for RTL support and localized widgets. |

---

## 📡 API Integration

### Base URL
```
https://dushkaburger.com/wp-json/
```

### Authentication
- **Type**: Basic Authentication
- **Username**: `testapp`
- **Password**: `5S0Q YjyH 4s3G elpe 5F8v u8as`
- **Header**: `Authorization: Basic dGVzdGFwcDo1UzBRIFlqeUggNHMzRyBlbHBlIDVGOHYgdThhcw==`

### Endpoints

| Endpoint | Method | Description | Example Response |
|----------|--------|-------------|------------------|
| `guestcart/v1/guestid` | GET | Generate guest ID | `{"guest_id": "guest_696a3fdc4b66c"}` |
| `custom-api/v1/categories` | GET | Get all categories with products | Array of categories with nested products |
| `custom-api/v1/products?product_id={id}` | GET | Get product details | Product object with full details |
| `proaddon/v1/get2/?product_id2={id}` | GET | Get product addons/extras | Array of addon options |
| `guestcart/v1/cart?guest_id={id}` | GET | Get cart contents | Cart object with items |
| `guestcart/v1/cart` | POST | Add item to cart | Updated cart |
| `guestcart/v1/cart` | DELETE | Remove item from cart | Updated cart |

### Request Examples

**Add to Cart:**
```json
POST /guestcart/v1/cart
{
  "guest_id": "guest_123",
  "items": [
    {
      "product_id": 456,
      "quantity": 2,
      "addons": [
        {
          "id": 789,
          "name": "Extra Cheese",
          "price": "5.00"
        }
      ]
    }
  ]
}
```

**Delete from Cart:**
```json
DELETE /guestcart/v1/cart
{
  "guest_id": "guest_123",
  "product_id": 456,
  "quantity": 1
}
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/trust_task.git
cd trust_task
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Build APK
```bash
flutter build apk --release
```

---

## 🌍 Localization

The app supports two languages:

| Language | Code | Direction |
|----------|------|-----------|
| English | `en` | LTR |
| Arabic | `ar` | RTL |

To switch language programmatically:
```dart
MyApp.setLocale(context, Locale('ar')); // Switch to Arabic
MyApp.setLocale(context, Locale('en')); // Switch to English
```

---

## 🎨 UI/UX Features

- **Material Design 3** - Modern components and theming
- **Responsive Layout** - Adapts to different screen sizes
- **RTL Support** - Full right-to-left layout for Arabic
- **Loading States** - Smooth loading indicators
- **Error States** - User-friendly error messages with retry
- **Empty States** - Informative empty cart/categories views
- **Animations** - Subtle transitions and micro-interactions

### Color Scheme
| Color | Hex | Usage |
|-------|-----|-------|
| Primary | `#D32F2F` | Main buttons, accents |
| Primary Light | `#FFCDD2` | Backgrounds, badges |
| Background | `#F5F5F5` | Screen backgrounds |
| Surface | `#FFFFFF` | Cards, dialogs |

---

## 🧪 Testing

Run tests with:
```bash
flutter test
```

---

## 📄 License

This project is created for the **Trust Apps** technical assessment.

---

## 👤 Author

**Trust Task Submission**

📧 Contact: trustappsteam@gmail.com

---

## 🙏 Acknowledgments

- Trust Apps team for the opportunity
- Flutter community for excellent packages
- Clean Architecture principles by Uncle Bob
