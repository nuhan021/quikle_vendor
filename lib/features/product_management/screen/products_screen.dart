import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/product_management/widgets/filter_product_widget.dart';
import 'package:quikle_vendor/features/profile/my_profile/controller/my_profile_controller.dart';
import '../../../core/utils/constants/colors.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controllers/products_controller.dart';
import '../controllers/add_product_controller.dart';
import '../widgets/products_search_widget.dart';
import '../widgets/products_action_buttons_widget.dart';
import '../widgets/products_low_stock_alert_widget.dart';
import '../widgets/products_list_widget.dart';
import '../widgets/delete_product_dialog_widget.dart';
import '../../../core/widgets/shimmer_widget.dart';

class ProductsScreen extends StatelessWidget {
  final bool onInit;

  const ProductsScreen({super.key, this.onInit = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductsController());
    Get.put(AddProductController());

    // Safe access to MyProfileController
    final myProfileController = Get.isRegistered<MyProfileController>()
        ? Get.find<MyProfileController>()
        : null;

    if (onInit) {
      controller.fetchProducts();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Products"),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.beakYellow,
              onRefresh: () async {
                // Start loading state for shimmer - ensure it shows
                controller.isLoading.value = true;

                // Force UI update
                await Future.delayed(const Duration(milliseconds: 100));

                // Keep shimmer visible for at least 1 second to ensure it's visible
                final fetchFuture = controller.fetchProducts();
                final shimmerTimer = Future.delayed(const Duration(seconds: 1));

                // Wait for both: fetch to complete OR minimum shimmer time
                await Future.wait([fetchFuture, shimmerTimer]);

                // Ensure loading is turned off
                controller.isLoading.value = false;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Show warning if KYC is not verified
                    if (myProfileController != null)
                      Obx(
                        () => myProfileController.shouldDisableFeatures.value
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  border: Border.all(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  myProfileController
                                          .kycStatusMessage
                                          .value
                                          .isNotEmpty
                                      ? myProfileController
                                            .kycStatusMessage
                                            .value
                                      : 'Verify KYC to manage products',
                                  style: TextStyle(
                                    color: Colors.red.shade900,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                    ProductsSearchWidget(),
                    ProductsActionButtonsWidget(),
                    ProductsLowStockAlertWidget(),
                    Obx(
                      () => controller.isLoading.value
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: const Center(
                                child: ListShimmerSkeleton(itemCount: 6),
                              ),
                            )
                          : myProfileController != null &&
                                myProfileController
                                    .shouldDisableFeatures
                                    .value &&
                                myProfileController.kycStatus.value
                                        .toLowerCase() !=
                                    'submitted'
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: const Center(
                                child: Text(
                                  'Verify KYC to view products',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          : const ProductsListWidget(),
                    ),
                  ],
                ),
              ),
            ),

            // Modals and Dialogs
            Obx(
              () => controller.showFilterProductModal.value
                  ? FilterProductWidget()
                  : Container(),
            ),

            Obx(
              () => controller.showDeleteDialog.value
                  ? DeleteProductDialogWidget()
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
