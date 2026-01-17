# 🎯 Interview Preparation - Dushka Burger Flutter Project

## 📚 Table of Contents
1. [Clean Architecture Questions](#clean-architecture-questions)
2. [Cubit State Management Questions](#cubit-state-management-questions)
3. [Dependency Injection Questions](#dependency-injection-questions)
4. [Localization Questions](#localization-questions)
5. [Error Handling Questions](#error-handling-questions)
6. [API Integration Questions](#api-integration-questions)
7. [Flutter Best Practices Questions](#flutter-best-practices-questions)
8. [Project-Specific Questions](#project-specific-questions)

---

## 🏗️ Clean Architecture Questions

### Q1: What is Clean Architecture and why did you use it?

**Answer:**
Clean Architecture is a way to organize your code into **3 layers**:

1. **Presentation Layer** → UI (Pages, Widgets, Cubit)
2. **Domain Layer** → Business Logic (Entities, Use Cases, Repository interfaces)
3. **Data Layer** → Data (Models, API calls, Repository implementation)

**Why use it?**
- **Easy to test** → Each layer can be tested alone
- **Easy to change** → If API changes, only Data layer changes
- **Easy to understand** → Code is organized in folders
- **Easy to maintain** → Find bugs quickly

```
Example in our project:
features/
  └── categories/
      ├── data/           ← API calls, Models
      ├── domain/         ← Business logic, Entities
      └── presentation/   ← UI, Cubit
```

---

### Q2: What is the difference between Entity and Model?

**Answer:**

| Entity (Domain Layer) | Model (Data Layer) |
|----------------------|-------------------|
| Simple Dart class | Has `fromJson()` and `toJson()` |
| Used in UI and business logic | Used for API communication |
| Does NOT know about JSON | Knows how to convert JSON |
| Clean and simple | Has more code |

**Example:**
```dart
// Entity (domain/entities/category.dart)
class Category {
  final int id;
  final String name;
}

// Model (data/models/category_model.dart)
class CategoryModel extends Category {
  CategoryModel({required int id, required String name});
  
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
```

---

### Q3: What is a Use Case?

**Answer:**
A Use Case is a class that does **ONE thing only**. It represents one action in your app.

**Example:**
- `GetCategoriesUseCase` → Gets all categories
- `AddToCartUseCase` → Adds item to cart
- `GetProductDetailsUseCase` → Gets one product details

**Why use it?**
- Code is **reusable** → Many screens can use same use case
- Code is **testable** → Easy to write unit tests
- Code is **clean** → Each file does one thing

```dart
class GetCategoriesUseCase {
  final CategoriesRepository repository;
  
  GetCategoriesUseCase(this.repository);
  
  Future<Either<Failure, List<Category>>> call() {
    return repository.getCategories();
  }
}
```

---

### Q4: What is the Repository Pattern?

**Answer:**
Repository is like a **bridge** between Domain and Data layers.

```
UI → Cubit → Use Case → Repository (interface) → Repository (implementation) → API
```

**Two parts:**
1. **Repository Interface** (in Domain layer) → Just a contract, no code
2. **Repository Implementation** (in Data layer) → Real code that calls API

**Why use it?**
- Domain layer doesn't know about API
- Easy to change data source (API → Database)
- Easy to test with fake data

```dart
// Interface (domain/repositories/)
abstract class CategoriesRepository {
  Future<Either<Failure, List<Category>>> getCategories();
}

// Implementation (data/repositories/)
class CategoriesRepositoryImpl implements CategoriesRepository {
  final RemoteDataSource remoteDataSource;
  
  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    // Call API here
  }
}
```

---

## 🔄 Cubit State Management Questions

### Q5: What is Cubit and why did you use it instead of Provider or setState?

**Answer:**
Cubit is a **state management** solution from the BLoC package. It's simpler than BLoC.

**Cubit vs setState:**
| Cubit | setState |
|-------|----------|
| Separates UI from logic | Logic is in widget |
| Easy to test | Hard to test |
| Good for complex apps | Good for simple widgets |

**Cubit vs Provider:**
| Cubit | Provider |
|-------|----------|
| Built-in state handling | Need to manage state yourself |
| Has loading, error, success states | Need to create states |
| Works well with Clean Architecture | Can be messy in big apps |

**Why not BLoC?**
- BLoC uses Events and States (more code)
- Cubit uses Functions and States (less code)
- For this app, Cubit is enough

---

### Q6: How does Cubit work? Explain with example from your project.

**Answer:**
Cubit has 3 parts:
1. **State** → Current data (loading, loaded, error)
2. **Cubit** → Business logic (functions that change state)
3. **BlocBuilder** → Widget that listens to state

**Example: CategoriesCubit**

```dart
// 1. States (categories_state.dart)
abstract class CategoriesState {}

class CategoriesLoading extends CategoriesState {}
class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;
}
class CategoriesError extends CategoriesState {
  final String message;
}

// 2. Cubit (categories_cubit.dart)
class CategoriesCubit extends Cubit<CategoriesState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  
  CategoriesCubit(this.getCategoriesUseCase) : super(CategoriesLoading());
  
  Future<void> loadCategories() async {
    emit(CategoriesLoading());  // Show loading
    
    final result = await getCategoriesUseCase();
    
    result.fold(
      (failure) => emit(CategoriesError(failure.message)),  // Show error
      (categories) => emit(CategoriesLoaded(categories)),   // Show data
    );
  }
}

// 3. UI (categories_page.dart)
BlocBuilder<CategoriesCubit, CategoriesState>(
  builder: (context, state) {
    if (state is CategoriesLoading) {
      return CircularProgressIndicator();
    }
    if (state is CategoriesError) {
      return Text(state.message);
    }
    if (state is CategoriesLoaded) {
      return ListView.builder(...);
    }
  },
)
```

---

### Q7: What is the difference between `emit()` and `setState()`?

**Answer:**

| emit() (Cubit) | setState() (StatefulWidget) |
|---------------|----------------------------|
| Changes Cubit state | Changes widget state |
| UI rebuilds automatically | UI rebuilds automatically |
| State is outside widget | State is inside widget |
| Can be used anywhere | Must be inside widget |
| Better for testing | Hard to test |

```dart
// emit() - in Cubit
emit(CategoriesLoaded(categories));

// setState() - in Widget
setState(() {
  this.categories = categories;
});
```

---

## 💉 Dependency Injection Questions

### Q8: What is Dependency Injection and why use GetIt?

**Answer:**
**Dependency Injection (DI)** = Giving a class what it needs from outside, not creating inside.

**Without DI (Bad):**
```dart
class CategoriesCubit {
  final useCase = GetCategoriesUseCase(
    CategoriesRepositoryImpl(
      CategoriesRemoteDataSource(
        ApiClient()
      )
    )
  ); // 😰 Too much code!
}
```

**With DI (Good):**
```dart
class CategoriesCubit {
  final GetCategoriesUseCase useCase;
  
  CategoriesCubit(this.useCase); // 😊 Simple!
}
```

**GetIt** is a service locator. It stores all objects in one place.

```dart
// Register
final sl = GetIt.instance;
sl.registerLazySingleton<ApiClient>(() => ApiClient());
sl.registerLazySingleton<CategoriesCubit>(() => CategoriesCubit(sl()));

// Use
final cubit = sl<CategoriesCubit>();
```

---

### Q9: What is the difference between Singleton and Factory in GetIt?

**Answer:**

| registerLazySingleton | registerFactory |
|----------------------|-----------------|
| Creates **ONE** object | Creates **NEW** object each time |
| Same object everywhere | Different object each time |
| Good for: API Client, Repositories | Good for: Cubits, Use Cases |

```dart
// Singleton - ONE ApiClient for whole app
sl.registerLazySingleton<ApiClient>(() => ApiClient());

// Factory - NEW Cubit each time
sl.registerFactory<CartCubit>(() => CartCubit(sl()));
```

---

## 🌍 Localization Questions

### Q10: How did you implement Arabic and English support?

**Answer:**

**3 Steps:**

1. **Create translations file** (app_localizations.dart)
```dart
class AppLocalizations {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'home': 'Home',
      'cart': 'Cart',
    },
    'ar': {
      'home': 'الرئيسية',
      'cart': 'السلة',
    },
  };
  
  String translate(String key) {
    return _translations[locale.languageCode]?[key] ?? key;
  }
}
```

2. **Add localization delegate** (main.dart)
```dart
MaterialApp(
  locale: Locale('en'),  // or 'ar'
  supportedLocales: [Locale('en'), Locale('ar')],
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ],
)
```

3. **Use in widgets**
```dart
Text(context.l10n.translate('home'))
```

---

### Q11: How did you handle RTL (Right-to-Left) for Arabic?

**Answer:**

Flutter handles RTL automatically with `Directionality` widget:

```dart
MaterialApp(
  builder: (context, child) {
    return Directionality(
      textDirection: locale.languageCode == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: child!,
    );
  },
)
```

**What changes in RTL?**
- Text starts from right
- Icons flip (back arrow → forward arrow)
- Padding/Margin switch sides
- Row children reverse order

---

## ⚠️ Error Handling Questions

### Q12: How did you handle errors in the app?

**Answer:**

**3-level error handling:**

1. **Exceptions** (data layer) → Catch API errors
```dart
try {
  final response = await dio.get(url);
  return CategoryModel.fromJson(response.data);
} on DioException catch (e) {
  throw ServerException(e.message);
}
```

2. **Failures** (domain layer) → Convert exceptions to failures
```dart
// In Repository
try {
  final data = await remoteDataSource.getCategories();
  return Right(data);  // Success
} on ServerException catch (e) {
  return Left(ServerFailure(e.message));  // Failure
}
```

3. **States** (presentation layer) → Show error to user
```dart
result.fold(
  (failure) => emit(CategoriesError(failure.message)),
  (data) => emit(CategoriesLoaded(data)),
);
```

---

### Q13: What is `Either` from dartz package?

**Answer:**

`Either` is a type that can be **Left** (error) or **Right** (success).

```dart
Either<Failure, List<Category>>
//     ↑ Error      ↑ Success
```

**Why use it?**
- No need for try-catch everywhere
- Forces you to handle both success and error
- Clean code

```dart
final result = await useCase();

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (categories) => print('Got ${categories.length} items'),
);
```

---

## 🌐 API Integration Questions

### Q14: How did you make API calls?

**Answer:**

Using **Dio** package for HTTP requests:

```dart
class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://dushkaburger.com/wp-json/',
      headers: {
        'Authorization': 'Basic xxxxx',
        'Content-Type': 'application/json',
      },
    ));
  }
  
  Future<Response> get(String path) => _dio.get(path);
  Future<Response> post(String path, dynamic data) => _dio.post(path, data: data);
}
```

---

### Q15: What is Basic Authentication?

**Answer:**

Basic Auth sends username and password in header:

```
Username: testapp
Password: 5S0Q YjyH 4s3G elpe 5F8v u8as

Encoded: base64(username:password)
Header: Authorization: Basic dGVzdGFwcDo1UzBRIFl...
```

In code:
```dart
import 'dart:convert';

final credentials = base64Encode(utf8.encode('$username:$password'));
headers['Authorization'] = 'Basic $credentials';
```

---

## ✨ Flutter Best Practices Questions

### Q16: What Flutter best practices did you follow?

**Answer:**

1. **const constructors** → Better performance
```dart
const Text('Hello')  // ✅ Good
Text('Hello')        // ❌ Not optimal
```

2. **Separate widgets** → Smaller, reusable files
```dart
// ❌ Bad - 1000 lines in one file
class BigPage extends StatelessWidget { ... }

// ✅ Good - Split into widgets
class ProductCard extends StatelessWidget { ... }
class CartButton extends StatelessWidget { ... }
```

3. **Named constructors** → Clear code
```dart
CategoryModel.fromJson(json)
CartItem.empty()
```

4. **Final variables** → Immutable data
```dart
final String name;  // ✅ Cannot change
String name;        // ❌ Can change
```

5. **Private classes with underscore**
```dart
class _MyWidgetState extends State<MyWidget> { }
```

---

### Q17: What is the difference between StatelessWidget and StatefulWidget?

**Answer:**

| StatelessWidget | StatefulWidget |
|-----------------|----------------|
| Cannot change | Can change with setState |
| No state | Has State object |
| Simpler | More complex |
| Better performance | Slightly slower |

**When to use StatelessWidget:**
- Static UI
- Data comes from outside (Cubit, Provider)
- Widget shows same thing always

**When to use StatefulWidget:**
- Internal state (counter, form input)
- Animations
- Local changes only

```dart
// StatelessWidget - data from Cubit
class ProductCard extends StatelessWidget {
  final Product product;
  // ...
}

// StatefulWidget - internal counter
class QuantitySelector extends StatefulWidget {
  int quantity = 1;  // Changes internally
}
```

---

## 📱 Project-Specific Questions

### Q18: Explain the guest user flow in your app.

**Answer:**

Guest flow means user can use app **without login**.

**How it works:**

1. First time → App calls API to get `guest_id`
```dart
// API: GET /guestcart/v1/guestid
Response: { "guest_id": "guest_abc123" }
```

2. Save `guest_id` locally using SharedPreferences
```dart
await prefs.setString('guest_id', guestId);
```

3. Use `guest_id` for all cart operations
```dart
// Add to cart
POST /guestcart/v1/cart
{
  "guest_id": "guest_abc123",
  "product_id": 456,
  "quantity": 1
}
```

4. Guest can:
   - ✅ Browse products
   - ✅ Add to cart
   - ✅ Remove from cart
   - ❌ Cannot checkout (needs login)

---

### Q19: How does the Cart feature work?

**Answer:**

**Cart Flow:**

```
User taps "Add to Cart"
    ↓
CategoriesPage calls CartCubit.addToCart()
    ↓
CartCubit calls AddToCartUseCase
    ↓
UseCase calls CartRepository.addToCart()
    ↓
Repository calls API (POST /guestcart/v1/cart)
    ↓
API returns updated cart
    ↓
CartCubit emits CartLoaded(newCart)
    ↓
UI updates automatically
```

**Cart States:**
```dart
CartInitial → First state
CartLoading → Calling API
CartLoaded  → Has cart items
CartError   → Something wrong
```

---

### Q20: How do you cache images?

**Answer:**

Using `cached_network_image` package:

```dart
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

**Benefits:**
- Downloads image once
- Saves to device cache
- Shows placeholder while loading
- Shows error if image fails
- Works offline after first load

---

## 💡 General Flutter Questions

### Q21: What is a Widget?

**Answer:**
Everything in Flutter is a Widget. It's a **description** of UI, not the actual UI.

Types:
- **Text** → Shows text
- **Container** → Box with styling
- **Row** → Horizontal layout
- **Column** → Vertical layout
- **ListView** → Scrollable list

---

### Q22: What is BuildContext?

**Answer:**
BuildContext is the **location** of a widget in the widget tree.

Used to:
- Get theme: `Theme.of(context)`
- Get screen size: `MediaQuery.of(context).size`
- Navigate: `Navigator.of(context).push(...)`
- Get Cubit: `context.read<CartCubit>()`

---

### Q23: What is the difference between `context.read()` and `context.watch()`?

**Answer:**

| context.read() | context.watch() |
|---------------|-----------------|
| Gets Cubit once | Listens to changes |
| Does NOT rebuild | Rebuilds on change |
| Use in: onPressed, initState | Use in: build method |

```dart
// read - for actions
onPressed: () {
  context.read<CartCubit>().addToCart(...);
}

// watch - for UI
Widget build(context) {
  final state = context.watch<CartCubit>().state;
  return Text(state.count.toString());
}
```

---

## 🎤 Tips for Interview

1. **Don't memorize** → Understand the concepts
2. **Be honest** → Say "I don't know" if you don't know
3. **Explain simply** → Use examples from your project
4. **Ask questions** → If question is unclear, ask
5. **Show confidence** → You built this app, you know it!

**Common phrases:**
- "In my project, I used..."
- "The reason I chose this approach is..."
- "This makes the code more..."
- "For example, in the Cart feature..."

---

## 📝 Quick Review Checklist

Before interview, make sure you can explain:

- [ ] 3 layers of Clean Architecture
- [ ] What is Entity vs Model
- [ ] What is Use Case
- [ ] What is Repository Pattern
- [ ] How Cubit works (State → Cubit → UI)
- [ ] What is DI and GetIt
- [ ] How localization works
- [ ] How error handling works (Exception → Failure → State)
- [ ] How API calls are made
- [ ] Guest user flow
- [ ] Cart feature flow

**Good luck! 🍀**
