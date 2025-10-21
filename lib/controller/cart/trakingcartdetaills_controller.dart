import 'package:softel/core/class/crud.dart';
import 'package:softel/core/services/services.dart';
import 'package:softel/data/model/cart.dart';
import 'package:softel/data/model/command.dart';
import 'package:softel/data/model/product.dart';
import 'package:get/get.dart';
import 'package:softel/linkapi.dart';
import 'package:softel/view/widget/dialog.dart';

class TrakingcartdetaillsController extends GetxController {
  MyServices myServices = Get.find();
  Crud crud = Crud();
  Dialogfun dialogfun = Dialogfun();
  List<CartModel> data = [];
  RxDouble totalcountproducts = 0.0.obs;
  Command command = Command();
  RxBool isloading = false.obs;

  String totalprice() {
    double total = 0.0;
    for (var element in data) {
      total += (element.cddMontant ?? 0.0);
    }
    return total.toStringAsFixed(2);
  }

  Future<void> view() async {
    isloading.value = true;
    var response = await crud.get("${AppLink.cart}/${command.cdeID}");
    if (response.statusCode == 200) {
      isloading.value = false;
      data = (response.body as List).map((e) => CartModel.fromJson(e)).toList();
    } else if (response.statusCode == 404) {
      isloading.value = false;
      data = [];
    } else {
      isloading.value = false;
      dialogfun.showSnackError("Error ${response.statusCode}", response.body['message']);
      data = [];
    }
    update();
  }

  Future<Product?> getdartbyid(int productsid) async {
    return null;
  }

  @override
  void onInit() {
    command = Get.arguments['Command'];
    view();
    super.onInit();
  }
}
