import 'package:get/get.dart';
import '../model/store_model.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;

  /// Store info
  var store = Rxn<StoreModel>();

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    try {
      isLoading.value = true;

      /// TODO: Replace with API call
      await Future.delayed(const Duration(seconds: 1));

      store.value = StoreModel(
        name: "Tandoori Tarang",
        logoUrl: "",
        isOpen: true,
        closingTime: "10:00 PM",
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleStoreStatus() {
    if (store.value != null) {
      store.value = store.value!.copyWith(isOpen: !store.value!.isOpen);
    }
  }
}
