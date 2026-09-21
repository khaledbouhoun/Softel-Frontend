# 🏗️ GetX Clean Architecture - Best Practices Guide

## 📋 Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Project Structure](#project-structure)
3. [Dependency Injection](#dependency-injection)
4. [Screen Patterns](#screen-patterns)
5. [State Management](#state-management)
6. [Anti-Patterns to Avoid](#anti-patterns-to-avoid)
7. [Performance Tips](#performance-tips)

---

## Architecture Overview

### Three-Layer Architecture

```
┌─────────────────────────────────────────┐
│           UI LAYER (Views)              │
│    - GetView, Stateless/Stateful       │
│    - No business logic here             │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│      PRESENTATION LAYER (Controllers)   │
│    - GetxController, GetBuilder/Obx    │
│    - Manage UI state and logic          │
└─────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────┐
│         DATA LAYER (Services)           │
│    - API calls, Database, SharedPref   │
│    - Business logic, data transformation│
└─────────────────────────────────────────┘
```

---

## Project Structure

```
lib/
├── core/
│   ├── base/                          # Base classes
│   │   └── base_controller.dart      # Abstract base controller
│   ├── bindings/
│   │   └── initial_bindings.dart     # Global services only
│   ├── middleware/                    # Route middleware
│   ├── services/                      # Global services (API, DB, Storage)
│   ├── constants/
│   ├── functions/
│   └── localization/
│
├── features/                          # ⭐ Feature-based modules
│   ├── auth/
│   │   ├── bindings/
│   │   │   ├── login_binding.dart
│   │   │   ├── signup_binding.dart
│   │   │   └── company_binding.dart
│   │   ├── controller/
│   │   │   ├── login_controller.dart
│   │   │   ├── signup_controller.dart
│   │   │   └── company_controller.dart
│   │   └── view/
│   │       ├── login_screen.dart
│   │       ├── signup_screen.dart
│   │       └── company_screen.dart
│   │
│   ├── home/
│   │   ├── bindings/
│   │   │   └── home_binding.dart
│   │   ├── controller/
│   │   │   ├── home_controller.dart
│   │   │   └── homescreen_controller.dart
│   │   └── view/
│   │       ├── home_screen.dart
│   │       └── home_page.dart
│   │
│   ├── product/
│   │   ├── bindings/
│   │   │   └── product_details_binding.dart
│   │   ├── controller/
│   │   │   └── product_details_controller.dart
│   │   └── view/
│   │       └── product_details_screen.dart
│   │
│   ├── search/
│   ├── cart/
│   ├── tracking/
│   └── families/
│
├── routes/
│   └── routes.dart                    # Route definitions with bindings
│
├── main.dart                          # App entry point
└── firebase_options.dart
```

---

## Dependency Injection

### ✅ DO: Proper Binding Pattern

```dart
// ✅ CORRECT: Feature-specific binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Use lazyPut for controllers
    Get.lazyPut(() => HomeScreenController());
    Get.lazyPut(() => HomeController());
    
    // Use put for repositories/services if needed
    Get.put(HomeRepository());
  }
}
```

### ❌ DON'T: Anti-patterns

```dart
// ❌ WRONG: Get.put() inside build()
@override
Widget build(BuildContext context) {
  Get.put(HomeController());  // Called every rebuild!
  return Container();
}

// ❌ WRONG: Get.put() in middleware
class MyMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    Get.put(SomeController());  // ❌ Wrong place
    return null;
  }
}

// ❌ WRONG: Controllers in InitialBindings
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());       // ❌ Should be in HomeBinding
    Get.put(UserController());       // ❌ Should be in AuthBinding
    Get.put(ProductController());    // ❌ Should be in ProductBinding
  }
}
```

---

## Screen Patterns

### Pattern 1: GetView (Recommended for Most Screens)

```dart
// ✅ BEST: Using GetView - automatic controller injection
class HomeScreenRefactored extends GetView<HomeScreenController> {
  const HomeScreenRefactored({super.key});

  @override
  Widget build(BuildContext context) {
    // controller is automatically available from GetView<T>
    return Scaffold(
      body: GetBuilder<HomeScreenController>(
        builder: (ctrl) => Text(ctrl.title),
      ),
    );
  }
}
```

### Pattern 2: Manual Find (When you need multiple controllers)

```dart
// ✅ GOOD: When you need multiple controllers
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productCtrl = Get.find<ProductDetailsController>();
    final cartCtrl = Get.find<CartController>();

    return Scaffold(
      body: GetBuilder<ProductDetailsController>(
        builder: (ctrl) => Column(
          children: [
            Text(ctrl.product.name),
            ElevatedButton(
              onPressed: () => cartCtrl.addToCart(ctrl.product),
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Pattern 3: Stateless with GetX (No controller reference)

```dart
// ✅ When screen has no state
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
```

---

## State Management

### Use GetBuilder for Simple State

```dart
// ✅ GOOD: GetBuilder for non-reactive state
class ProductListScreen extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (ctrl) => ListView.builder(
        itemCount: ctrl.products.length,
        itemBuilder: (context, index) => Text(ctrl.products[index].name),
      ),
      // Better performance than Obx
    );
  }
}
```

### Use Obx for Reactive State

```dart
// ✅ GOOD: Obx for reactive state management
class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.isLoading.value
            ? LoadingWidget()
            : CustomProductList(products: controller.products),
      ),
    );
  }
}

// In Controller:
class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Product> products = <Product>[].obs;

  void fetchProducts() async {
    isLoading.value = true;
    try {
      products.value = await api.getProducts();
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

## Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: Get.put() in Build

```dart
// ❌ WRONG
@override
Widget build(BuildContext context) {
  Get.put(MyController()); // Called on every rebuild!
  return Container();
}

// ✅ CORRECT
@override
Widget build(BuildContext context) {
  // Use GetView or Get.find()
  return GetBuilder<MyController>(builder: (ctrl) => Container());
}
```

### ❌ Anti-Pattern 2: Blocking UI with Middleware

```dart
// ❌ WRONG: Heavy logic in middleware
class MyMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Don't do heavy operations here
    final user = fetchUserFromDB(); // ❌ Blocks navigation
    return null;
  }
}

// ✅ CORRECT: Middleware for only redirect logic
class MyMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Only read from cache/prefs
    final token = Get.find<MyServices>().getToken();
    
    if (token == null) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
```

### ❌ Anti-Pattern 3: Controllers in Global Bindings

```dart
// ❌ WRONG: All controllers registered upfront
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
    Get.put(ProductController());
    Get.put(CartController());
    Get.put(CheckoutController());
    Get.put(ProfileController());
    // Every controller registered globally = memory waste
  }
}

// ✅ CORRECT: Only services in global, controllers in features
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put(DatabaseService(), permanent: true);
    Get.lazyPut(() => LocaleController(), fenix: true);
  }
}

// Then in feature bindings
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
```

### ❌ Anti-Pattern 4: Using Obx for Everything

```dart
// ❌ WRONG: Over-use of Obx causes excessive rebuilds
class UserListScreen extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      // ListView rebuilds entire list on any state change
      itemCount: controller.users.length,
      itemBuilder: (_, index) => Obx(
        () => UserTile(user: controller.users[index]),
      ),
    ));
  }
}

// ✅ CORRECT: GetBuilder for list, Obx only for reactive items
class UserListScreen extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (ctrl) => ListView.builder(
        itemCount: ctrl.users.length,
        itemBuilder: (_, index) => Obx(
          () => UserTile(
            user: ctrl.users[index],
            isSelected: ctrl.selectedUserId == ctrl.users[index].id,
          ),
        ),
      ),
    );
  }
}
```

---

## Performance Tips

### 1. Use lazyPut for Controllers

```dart
// ✅ Controller created only when first accessed
Get.lazyPut(() => HeavyController());

// ❌ Controller created immediately
Get.put(HeavyController());
```

### 2. Use permanent: true Only for Services

```dart
// ✅ Service stays in memory for app lifetime
Get.put(ApiService(), permanent: true);

// ❌ Don't use permanent for controllers
Get.put(HomeController(), permanent: true); // Memory leak!
```

### 3. Prefer GetBuilder Over Obx

```dart
// ✅ BETTER: GetBuilder for simple state updates
GetBuilder<ProductController>(
  builder: (ctrl) => Text(ctrl.productCount),
)

// ⚠️  Obx adds overhead for reactive state
Obx(() => Text(controller.productCount.value))
```

### 4. Dispose Resources in onClose()

```dart
class MyController extends GetxController {
  final StreamSubscription? _subscription;

  @override
  void onClose() {
    // Clean up resources
    _subscription?.cancel();
    super.onClose();
  }
}
```

### 5. Avoid Get.isRegistered() in Build

```dart
// ❌ WRONG: Checking registration in build
@override
Widget build(BuildContext context) {
  if (Get.isRegistered<MyController>()) {
    // Do something
  }
  return Container();
}

// ✅ CORRECT: Use try-catch or ensure binding exists
try {
  final ctrl = Get.find<MyController>();
} catch (e) {
  // Handle controller not found
}
```

---

## Migration Checklist

- [ ] Move all controllers to feature folders
- [ ] Create `*_binding.dart` for each feature
- [ ] Remove all `Get.put()` calls from UI code
- [ ] Update all routes to use bindings
- [ ] Replace screens with `GetView` pattern
- [ ] Update `InitialBindings` to only contain services
- [ ] Test that controllers are created/disposed properly
- [ ] Verify no memory leaks using Dart DevTools
- [ ] Update Middleware to only handle redirects
- [ ] Remove controllers from Global Bindings

---

## Example: Complete Feature Implementation

### **Step 1: Create Controller**

```dart
// lib/features/product/controller/product_details_controller.dart
class ProductDetailsController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rx<Product> product = Product().obs;

  @override
  void onInit() {
    super.onInit();
    loadProduct();
  }

  void loadProduct() async {
    isLoading.value = true;
    try {
      product.value = await Get.find<ApiService>().getProduct();
    } finally {
      isLoading.value = false;
    }
  }
}
```

### **Step 2: Create Binding**

```dart
// lib/features/product/bindings/product_details_binding.dart
class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProductDetailsController());
  }
}
```

### **Step 3: Create View**

```dart
// lib/features/product/view/product_details_screen.dart
class ProductDetailsScreen extends GetView<ProductDetailsController> {
  const ProductDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Obx(
        () => controller.isLoading.value
            ? const LoadingWidget()
            : ProductDetailsWidget(product: controller.product.value),
      ),
    );
  }
}
```

### **Step 4: Add to Routes**

```dart
// lib/routes.dart
GetPage(
  name: AppRoute.productDetails,
  page: () => const ProductDetailsScreen(),
  binding: ProductDetailsBinding(),
),
```

That's it! 🎉

---

## Summary

✅ **DO:**
- Use GetView for most screens
- Create bindings for each feature
- Use lazyPut for controllers
- Put only services in InitialBindings
- Keep middleware lightweight
- Dispose resources in onClose()

❌ **DON'T:**
- Use Get.put() in build()
- Put controllers in global bindings
- Use Obx for everything
- Register controllers upfront
- Add business logic to middleware
- Forget to dispose resources
