import 'package:get/get.dart';
import 'package:softel/core/class/crud.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/cart.dart';
import 'package:softel/data/model/command.dart';
import 'package:softel/data/model/product.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class TrakingcartdetaillsController extends GetxController {
  final MyServices myServices = Get.find<MyServices>();
  final Crud crud = Crud();
  final Dialogfun dialogfun = Dialogfun();

  final data = <CartModel>[].obs;
  final RxDouble totalcountproducts = 0.0.obs;
  Command command = Command();
  final RxBool isloading = false.obs;

  String totalprice() {
    double total = 0.0;
    for (var element in data) {
      total += (element.cddMontant ?? 0.0);
    }
    return total.toStringAsFixed(2);
  }

  Future<void> view() async {
    isloading.value = true;
    try {
      final response = await crud.get("${AppLink.cart}/${command.cdeID}");
      if (response.statusCode == 200 && response.body is List) {
        final items = (response.body as List).map((e) => CartModel.fromJson(e)).toList();
        data.assignAll(items);
      } else if (response.statusCode == 404) {
        data.clear();
      } else {
        data.clear();
        dialogfun.showSnackError("Error ${response.statusCode}", response.body?['message']?.toString() ?? '');
      }
    } catch (e) {
      data.clear();
    } finally {
      isloading.value = false;
    }
  }

  Future<Product?> getdartbyid(int productsid) async {
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['Command'] is Command) {
      command = args['Command'] as Command;
    }
    view();
  }
}

