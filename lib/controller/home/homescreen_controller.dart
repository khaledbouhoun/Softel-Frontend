import 'package:get/get.dart';

/// Clean, decoupled HomeScreenController managing bottom navigation tab state.
class HomeScreenController extends GetxController {
  /// Reactive tab index
  final RxInt initialTab = 0.obs;

  /// Set of tabs that have been visited/loaded so far
  final RxSet<int> loadedTabs = <int>{0}.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['initialTab'] is int) {
      final tab = args['initialTab'] as int;
      initialTab.value = tab;
      loadedTabs.add(tab);
    }
  }

  /// Change active tab index cleanly and mark it as loaded
  void changeTab(int index) {
    loadedTabs.add(index);
    initialTab.value = index;
  }
}

