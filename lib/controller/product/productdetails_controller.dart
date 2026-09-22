import 'dart:core';

import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/services/cart_state_service.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/cart.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class ProductDetailsController extends GetxController {
  // ---------------------------------------------------------------------------
  // Dependencies
  // ---------------------------------------------------------------------------

  final MyServices myServices = Get.find<MyServices>();
  final CartStateService cartStateService = Get.find<CartStateService>();

  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();

  // ---------------------------------------------------------------------------
  // Product
  // ---------------------------------------------------------------------------

  late Product product;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  /// True when the product is being handled through the cart screen.
  bool fromcart = false;

  /// True when a request is currently running.
  final RxBool isloading = false.obs;

  /// Selected unit type.
  ///
  /// true  -> colis/unit mode
  /// false -> individual units mode
  final RxBool isUnitSelected = true.obs;

  // ---------------------------------------------------------------------------
  // Quantity / Price
  // ---------------------------------------------------------------------------

  final RxDouble totalprice = 0.0.obs;
  final RxDouble qtyinput = 0.0.obs;
  final RxDouble coulis = 0.0.obs;
  final RxDouble unites = 0.0.obs;

  // ---------------------------------------------------------------------------
  // Other
  // ---------------------------------------------------------------------------

  bool confirm = false;

  late String usersid;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  void _initializeData() {
    usersid = myServices.sharedPreferences.getString('id')?.toString() ?? '';

    final arguments = Get.arguments;

    if (arguments is Map && arguments['product'] is Product) {
      product = arguments['product'] as Product;
    } else {
      product = Product();
    }

    fromcart = arguments is Map && arguments['fromcart'] == true;

    qtyinput.value = product.artQte ?? 0.0;

    calculate();
  }

  // ---------------------------------------------------------------------------
  // Add / Update Product
  // ---------------------------------------------------------------------------

  Future<void> storeCommand() async {
    if (isloading.value) return;

    isloading.value = true;

    try {
      final data = _buildStoreCommandData();

      final response = await crud.post(AppLink.storeProduct, data);

      if (response.statusCode == 201) {
        final quantity = _selectedQuantity;

        // Stop loading before leaving the page.
        isloading.value = false;

        // Return the quantity to Home immediately.
        _closeWithResult(quantity);

        // Refresh cart count without blocking navigation.
        cartStateService.fetchCartCount();

        return;
      }

      if (response.statusCode == 422) {
        _handleValidationError(response);
        return;
      }

      _showGenericError();
    } catch (e) {
      _showGenericError();
    } finally {
      isloading.value = false;
    }
  }
  // ---------------------------------------------------------------------------
  // Delete Product From Cart
  // ---------------------------------------------------------------------------

  Future<void> deletefromcart() async {
    if (isloading.value) return;

    isloading.value = true;

    try {
      final cartItem = await _findCartItem();

      if (cartItem == null) {
        _showGenericError();
        return;
      }

      final response = await crud.delete(AppLink.deleteCart, {'CddID': cartItem.cddID, 'CddArtNo': cartItem.cddArtNo});

      if (response.statusCode == 200) {
        await _refreshCartCount();

        // 0 means that the product is no longer in the cart.
        _closeWithResult(0.0);

        return;
      }

      _showGenericError();
    } catch (e) {
      _showGenericError();
    } finally {
      isloading.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Build Store Request
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _buildStoreCommandData() {
    final hasPackaging = (product.artColisageNom ?? '').isNotEmpty;

    final quantity = _selectedQuantity;

    return {
      'CddArt': product.artNo,
      'CddColisage': '01',

      'CddColis': hasPackaging ? (isUnitSelected.value ? coulis.value : qtyinput.value) : 0,

      'CddUntCol': hasPackaging ? (product.artUntCol ?? 0) : 0,

      'CddQte': quantity,

      'CddPrix': product.artPrix ?? 0,

      'CddMontant': totalprice.value,
    };
  }

  // ---------------------------------------------------------------------------
  // Cart
  // ---------------------------------------------------------------------------

  Future<CartModel?> _findCartItem() async {
    final response = await crud.get(AppLink.cart);

    if (response.statusCode != 200 || response.body is! List) {
      return null;
    }

    final items = (response.body as List).map((item) => CartModel.fromJson(item)).toList();

    return items.firstWhereOrNull((item) => item.cddArtNo == product.artNo);
  }

  Future<void> _refreshCartCount() async {
    await cartStateService.fetchCartCount();
  }

  // ---------------------------------------------------------------------------
  // Navigation Result
  // ---------------------------------------------------------------------------

  double get _selectedQuantity {
    return isUnitSelected.value ? qtyinput.value : unites.value;
  }

  void _closeWithResult(double result) {
    if (fromcart) {
      Get.back(result: true);
    } else {
      Get.back(result: result);
    }
  }

  // ---------------------------------------------------------------------------
  // Error Handling
  // ---------------------------------------------------------------------------

  void _handleValidationError(dynamic response) {
    String errorMessage = '';

    if (response.body is Map && response.body['errors'] is Map) {
      final Map<String, dynamic> errors = Map<String, dynamic>.from(response.body['errors']);

      for (final entry in errors.entries) {
        final value = entry.value;

        if (value is List) {
          errorMessage += '${value.join(', ')}\n';
        } else {
          errorMessage += '$value\n';
        }
      }
    }

    if (errorMessage.trim().isEmpty) {
      errorMessage = 'something_went_wrong'.tr;
    }

    dialogfun.showSnackError('something_went_wrong'.tr, errorMessage.trim());
  }

  void _showGenericError() {
    dialogfun.showSnackError('error'.tr, 'something_went_wrong'.tr);
  }

  void _showSuccessMessage(String message) {
    dialogfun.showSnackSuccess('success'.tr, message);
  }

  // ---------------------------------------------------------------------------
  // Unit Type
  // ---------------------------------------------------------------------------

  void toggleUnitType(int index) {
    isUnitSelected.value = index == 0;

    if (isUnitSelected.value) {
      coulis.value = qtyinput.value;
      qtyinput.value = unites.value;
      unites.value = 0.0;
    } else {
      qtyinput.value = coulis.value;

      final unitsPerColis = product.artUntCol ?? 0;

      unites.value = unitsPerColis > 1 ? qtyinput.value * unitsPerColis : unites.value;
    }

    calculate();
  }

  // ---------------------------------------------------------------------------
  // Price / Quantity Calculation
  // ---------------------------------------------------------------------------

  void calculate() {
    final hasPackaging = (product.artColisageNom ?? '').isNotEmpty;

    final unitsPerColis = product.artUntCol ?? 1;

    if (hasPackaging) {
      if (unitsPerColis != 0) {
        coulis.value = (qtyinput.value ~/ unitsPerColis).toDouble();
      } else {
        coulis.value = 0.0;
      }

      if (isUnitSelected.value) {
        if (unitsPerColis != 0) {
          unites.value = qtyinput.value % unitsPerColis;
        } else {
          unites.value = 0.0;
        }
      } else {
        unites.value = qtyinput.value * (product.artUntCol ?? 0);
      }
    }

    if (isUnitSelected.value) {
      totalprice.value = qtyinput.value * (product.artPrix ?? 0);
    } else {
      totalprice.value = unites.value * (product.artPrix ?? 0);
    }
  }

  // ---------------------------------------------------------------------------
  // Quantity Controls
  // ---------------------------------------------------------------------------

  void incrementQty() {
    qtyinput.value++;
    calculate();
  }

  void decrementQty() {
    if (qtyinput.value > 0) {
      qtyinput.value--;
    }

    calculate();
  }

  void decrementQtyHold() {
    if (qtyinput.value <= 0) return;

    qtyinput.value = 1;

    if ((product.artColisageNom ?? '').isNotEmpty) {
      final unitsPerColis = product.artUntCol ?? 1;

      coulis.value = unitsPerColis != 0 ? (qtyinput.value ~/ unitsPerColis).toDouble() : 0.0;

      unites.value = unitsPerColis != 0 ? qtyinput.value % unitsPerColis : 0.0;
    }

    calculate();
  }
}
