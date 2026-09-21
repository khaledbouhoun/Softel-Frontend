import 'package:get/get.dart';

/// Base controller for all app controllers
/// Provides common functionality like loading states, error handling
abstract class BaseController extends GetxController {
  /// Global loading state
  final RxBool isLoading = false.obs;

  /// Global error message
  final RxString errorMessage = ''.obs;

  /// Show loading state
  void setLoading(bool value) {
    isLoading.value = value;
  }

  /// Set error message
  void setError(String message) {
    errorMessage.value = message;
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Handle API/Business logic errors
  void handleError(dynamic error) {
    setError(error.toString());
    setLoading(false);
  }

  @override
  void onClose() {
    isLoading.close();
    errorMessage.close();
    super.onClose();
  }
}
