import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/linkapi.dart';

/// App-wide reactive cart state service.
///
/// Keeps the cart count synchronized between Home, ProductDetails, and Cart screens
/// without requiring any controller to find or depend on another controller.
class CartStateService extends GetxService {
  final RxInt cartCount = 0.obs;

  Future<void> fetchCartCount() async {
    try {
      final crud = Get.find<Crud>();
      final response = await crud.get(AppLink.cartCount);

      if (response.statusCode == 200 && response.body is Map) {
        final value = response.body['cartCount'];
        cartCount.value = value is int ? value : int.tryParse(value?.toString() ?? '') ?? 0;
      } else {
        cartCount.value = 0;
      }
    } catch (_) {
      cartCount.value = 0;
    }
  }

  void updateCartCount(int count) {
    cartCount.value = count < 0 ? 0 : count;
  }
}
