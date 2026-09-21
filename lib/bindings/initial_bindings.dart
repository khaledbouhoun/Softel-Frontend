import 'package:softel/core/class/crud.dart';
import 'package:softel/core/constant/color.dart';
import 'package:softel/core/localization/changelocal.dart';
import 'package:softel/core/services/services.dart';
import 'package:get/get.dart';

/// Initial Bindings Layer
///
/// ✅ BEST PRACTICES:
/// - Only put GLOBAL SERVICES and singleton instances here
/// - Use Get.put() for permanent, app-wide services
/// - Use permanent: true for services needed throughout app lifetime
/// - Controllers should NOT be here - they go to individual feature bindings
///
/// ✅ When to use Initial Bindings:
/// - SharedPreferences wrapper
/// - API Client / HTTP Client
/// - Database instances
/// - Global utilities
/// - Locale/Theme controller (if app-wide)
///
/// ❌ DO NOT put here:
/// - Page-specific controllers (use feature bindings)
/// - UI controllers (use feature bindings)

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // Core utilities - permanent services
    Get.put(Crud(), permanent: true);
    Get.put(AppColor(), permanent: true);

    // Global state management - LocaleController for theme and language
    // This is app-wide, so it stays here
    // Note: Using Put() instead of lazyPut() because it needs to exist
    // when GetMaterialApp tries to access it at startup
  }
}
