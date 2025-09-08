import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/icon_path.dart';
import '../../../core/utils/constants/image_path.dart';
import '../../home/screen/home_screen.dart';
import '../../orders/screen/orders_screen.dart';
import '../../products/screen/products_screen.dart';
import '../../profile/account/screen/account_screen.dart';
import '../controller/navbar_controller.dart';
import '../widget/navbar_items.dart';
import '../widget/profile_navbar_item.dart';

class NavbarScreen extends StatelessWidget {
  NavbarScreen({super.key});

  final NavbarController controller = Get.put(NavbarController());

  final pages = [
    HomeScreen(),
    OrdersScreen(),
    ProductsScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          height: 108,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
            border: Border(
              top: BorderSide(
                color: AppColors.primary, // yellow line
                width: 2,
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavbarItems(
                iconPath: IconPath.home,
                label: 'Home',
                selected: controller.currentIndex.value == 0,
                onTap: () => controller.changeTab(0),
              ),
              NavbarItems(
                iconPath: IconPath.order,
                label: 'All Orders',
                selected: controller.currentIndex.value == 1,
                onTap: () => controller.changeTab(1),
              ),
              NavbarItems(
                iconPath: IconPath.product,
                label: 'Products',
                selected: controller.currentIndex.value == 2,
                onTap: () => controller.changeTab(2),
              ),
              ProfileNavbarItem(
                imagePath: ImagePath.profile,
                label: 'Ananya',
                selected: controller.currentIndex.value == 3,
                onTap: () => controller.changeTab(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
