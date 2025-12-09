import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/features/earnings/screen/earnings_screen.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/icon_path.dart';
import '../../../core/utils/constants/image_path.dart';
import '../../home/screen/home_screen.dart';
import '../../order_management/screen/order_management_screen.dart';
import '../../product_management/screen/products_screen.dart';
import '../../profile/account/screen/account_screen.dart';
import '../controller/navbar_controller.dart';
import '../widget/navbar_items.dart';
import '../widget/profile_navbar_item.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen>
    with TickerProviderStateMixin {
  final NavbarController controller = Get.put(NavbarController());

  late final AnimationController _navController;
  final GlobalKey _navKey = GlobalKey();
  double _navBarHeight = 0.0;

  final pages = [
    const HomeScreen(),
    const OrderManagementScreen(),
    const EarningsScreen(),
    const ProductsScreen(onInit: true),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _navController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _navController.dispose();
    super.dispose();
  }

  void _measureNavBarHeight() {
    final ctx = _navKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final h = box.size.height;
    if (h > 0 && (h - _navBarHeight).abs() > 0.5) {
      setState(() => _navBarHeight = h);
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse &&
          _navController.value != 0.0 &&
          _navController.status != AnimationStatus.reverse) {
        _navController.reverse();
      } else if (notification.direction == ScrollDirection.forward &&
          _navController.value != 1.0 &&
          _navController.status != AnimationStatus.forward) {
        _navController.forward();
      } else if (notification.direction == ScrollDirection.idle) {
        if (_navController.value != 1.0) {
          _navController.forward();
        }
      }
    }
    if (notification is ScrollEndNotification) {
      if (_navController.value != 1.0) {
        _navController.forward();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureNavBarHeight());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: Stack(
          children: [
            Obx(
              () => IndexedStack(
                index: controller.currentIndex.value,
                children: pages,
              ),
            ),

            /// Background color extension for SafeArea bottom padding
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).padding.bottom,
              child: Container(color: Colors.black87),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 180),
                offset: const Offset(0, 0),
                child: SizeTransition(
                  axisAlignment: 1.0,
                  sizeFactor: _navController,
                  child: KeyedSubtree(
                    key: _navKey,
                    child: Obx(
                      () => SafeArea(
                        child: Container(
                          // remove SafeArea from here
                          height: 83.h,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(28),
                              topRight: Radius.circular(28),
                            ),
                            border: Border(
                              top: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          // ✅ use padding to compensate manually if needed
                          padding: EdgeInsets.only(
                            top: 5,
                            bottom: MediaQuery.of(context).padding.bottom > 0
                                ? 10
                                : 15, // keep consistency
                          ),
                          child: SafeArea(
                            top: false,
                            bottom: false, // ❌ disable bottom padding here
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
                                  iconPath: IconPath.earning,
                                  label: 'Earnings',
                                  selected: controller.currentIndex.value == 2,
                                  onTap: () => controller.changeTab(2),
                                ),
                                NavbarItems(
                                  iconPath: IconPath.product,
                                  label: 'Products',
                                  selected: controller.currentIndex.value == 3,
                                  onTap: () => controller.changeTab(3),
                                ),
                                ProfileNavbarItem(
                                  imagePath: ImagePath.profile,
                                  label: 'Ananya',
                                  selected: controller.currentIndex.value == 4,
                                  onTap: () => controller.changeTab(4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
