import 'package:softel/core/constant/routesstr.dart';
import 'package:softel/core/middleware/mymiddleware.dart';
import 'package:softel/core/middleware/mymiddlewareproduct.dart';

// Feature Bindings
import 'package:softel/features/auth/bindings/company_binding.dart';
import 'package:softel/features/auth/bindings/login_binding.dart';
import 'package:softel/features/auth/bindings/signup_binding.dart';
import 'package:softel/features/home/bindings/home_binding.dart';
import 'package:softel/features/product/bindings/product_details_binding.dart';
import 'package:softel/features/search/bindings/search_binding.dart';
import 'package:softel/features/cart/bindings/cart_binding.dart';
import 'package:softel/features/tracking/bindings/tracking_binding.dart';
import 'package:softel/features/families/bindings/families_binding.dart';

// Views
import 'package:softel/view/screen/auth/company.dart';
import 'package:softel/view/screen/auth/login.dart';
import 'package:softel/view/screen/auth/signup.dart';
import 'package:softel/view/screen/auth/splachscreen.dart';
import 'package:softel/view/screen/cart/cart.dart';
import 'package:softel/view/screen/home/homescreen.dart';
import 'package:softel/view/screen/product/search_page.dart';
import 'package:softel/view/screen/settings/language.dart';
import 'package:softel/view/screen/famille/famillesdetailes.dart';
import 'package:softel/view/screen/product/productdetails.dart';
import 'package:softel/view/screen/famille/soufamillespage.dart';
import 'package:softel/view/screen/traking/traking.dart';
import 'package:softel/view/screen/home/new_arrivals_page.dart';
import 'package:softel/view/screen/traking/trakingcartdetaills.dart';
import 'package:get/get.dart';

/// ✅ REFACTORED ROUTES WITH PROPER BINDINGS
///
/// KEY IMPROVEMENTS:
/// 1. Each route has its own binding for dependency injection
/// 2. Controllers are created on-demand when route is accessed
/// 3. Bindings use lazyPut for optimal memory management
/// 4. No Get.put() calls inside UI code
/// 5. Clear separation of concerns

final List<GetPage<dynamic>> routes = [
  /// Language Selection - Initial route
  GetPage(name: "/", page: () => Language(), middlewares: [MyMiddleWare()]),

  /// Language Change
  GetPage(name: AppRoute.languagechange, page: () => Languagechange()),

  /// Splash Screen
  GetPage(
    name: AppRoute.splachscreen,
    page: () => const Splachscreen(),
    binding: BindingsBuilder(() => Get.lazyPut(() => Splachscreencontroller())),
  ),

  /// Company Selection
  GetPage(name: AppRoute.company, page: () => const CompanyPage(), binding: CompanyBinding()),

  /// Login
  GetPage(name: AppRoute.login, page: () => const Login(), binding: LoginBinding()),

  /// Sign Up
  GetPage(name: AppRoute.signUp, page: () => const SignUp(), binding: SignUpBinding()),

  /// Home Screen - Main navigation hub
  /// Contains: Home, Families, Orders, Settings
  GetPage(name: AppRoute.homeScreen, page: () => const HomeScreen(), binding: HomeBinding(), middlewares: [Mymiddlewareproduct()]),

  /// Home Page (Alternative route)
  GetPage(name: AppRoute.homepage, page: () => const HomeScreen(), binding: HomeBinding(), middlewares: [Mymiddlewareproduct()]),

  /// Search Page
  GetPage(name: AppRoute.search, page: () => const SearchPage(), binding: SearchBinding()),

  /// Shopping Cart
  GetPage(name: AppRoute.cart, page: () => const Cart(), binding: CartBinding()),

  /// Families Details (Category)
  GetPage(name: AppRoute.famillesdetailes, page: () => const Famillesdetailes(), binding: FamiliesBinding()),

  /// Sub-families Page
  GetPage(name: AppRoute.soufamilles, page: () => const Soufamillespage(), binding: FamiliesBinding()),

  /// Product Details
  GetPage(name: AppRoute.productdetails, page: () => const ProductDetails(), binding: ProductDetailsBinding()),

  /// Tracking Details (Order Tracking)
  GetPage(name: AppRoute.trakingdetails, page: () => const TrakingDetails(), binding: TrackingBinding()),

  /// Tracking Cart Details
  GetPage(name: AppRoute.trakingcartdetaills, page: () => const Trakingcartdetaills(), binding: TrackingDetailsBinding()),

  /// New Arrivals Page
  GetPage(name: AppRoute.newArrivals, page: () => const NewArrivalsPage()),
];
