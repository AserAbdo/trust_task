# Dushka Burger - Flutter App

A Flutter food ordering application implementing Clean Architecture with Cubit state management.

## 📱 Features

- **Categories Screen**: Browse food categories and products
- **Product Details Screen**: View product details with addons and quantity selection
- **Cart Screen**: Manage shopping cart with checkout functionality
- **Guest User Flow**: Full functionality without requiring login
- **English & Arabic Localization**: RTL support for Arabic

## 🏗️ Architecture

This project follows **Clean Architecture** principles with three main layers:

```
lib/
├── core/                   # Core functionality
│   ├── constants/          # API and app constants
│   ├── di/                 # Dependency injection
│   ├── error/              # Exceptions and failures
│   ├── l10n/               # Localization
│   ├── network/            # API client
│   ├── theme/              # App theme
│   └── utils/              # Utilities (Guest Manager)
│
├── features/               # Feature modules
│   ├── categories/
│   │   ├── data/           # Data layer (models, datasources, repositories)
│   │   ├── domain/         # Domain layer (entities, repositories, usecases)
│   │   └── presentation/   # Presentation layer (cubit, pages, widgets)
│   │
│   ├── product_details/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── cart/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart               # App entry point
```

## 🛠️ Tech Stack

- **Flutter** - UI framework
- **flutter_bloc** - State management (Cubit)
- **get_it** - Dependency injection
- **dio** - HTTP client
- **dartz** - Functional programming (Either type)
- **equatable** - Value equality
- **cached_network_image** - Image caching
- **shared_preferences** - Local storage

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.10.0)
- Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/trust_task.git
cd trust_task
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📡 API Endpoints

Base URL: `https://dushkaburger.com/wp-json/`

| Endpoint | Method | Description |
|----------|--------|-------------|
| `guestcart/v1/guestid` | GET | Get guest ID |
| `custom-api/v1/categories` | GET | Get categories |
| `custom-api/v1/products?product_id={id}` | GET | Get product details |
| `proaddon/v1/get2/?product_id2={id}` | GET | Get product addons |
| `guestcart/v1/cart?guest_id={id}` | GET | Get cart |
| `guestcart/v1/cart` | POST | Add to cart |
| `guestcart/v1/cart` | DELETE | Remove from cart |

## 🎨 UI Features

- Material Design 3
- Responsive layouts
- RTL support for Arabic
- Smooth animations
- Error handling with retry
- Loading states
- Empty states

## 📂 Project Structure

### Domain Layer
- **Entities**: Business objects (Category, Product, Cart)
- **Repositories**: Abstract interfaces
- **Use Cases**: Single responsibility business logic

### Data Layer
- **Models**: JSON serializable data classes
- **Data Sources**: Remote API implementations
- **Repository Implementations**: Concrete implementations

### Presentation Layer
- **Cubits**: State management with BLoC pattern
- **States**: Immutable state classes
- **Pages**: Screen widgets
- **Widgets**: Reusable UI components

## 🌐 Localization

The app supports:
- English (en)
- Arabic (ar) with RTL layout

## 📝 License

This project is created for the Trust Apps technical assessment.

## 👤 Author

Trust Task Submission
