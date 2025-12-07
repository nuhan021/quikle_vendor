import 'package:get/get.dart';

class NavbarController extends GetxController {
  var currentIndex = 0.obs;

  // Callback for Products tab refresh
  Function? onProductsTabSelected;

  void changeTab(int index) {
    currentIndex.value = index;

    // Call the callback when Products tab (index 3) is selected
    if (index == 3 && onProductsTabSelected != null) {
      onProductsTabSelected!();
    }
  }
}
