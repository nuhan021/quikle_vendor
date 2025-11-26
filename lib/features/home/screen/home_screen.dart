import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quikle_vendor/core/utils/constants/colors.dart';
import 'package:quikle_vendor/features/home/widgets/rider_assign/rider_assignment_dialogs_widget.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controller/home_controller.dart';
import '../widgets/orders_overview_widget.dart';
import '../widgets/pending_actions_widget.dart';
import '../widgets/recent_orders_widget.dart';
import '../widgets/restaurant_header_widget.dart';
import '../widgets/dashboard_option.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppbarScreen(title: "Home"),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        RestaurantHeaderWidget(),
                        SizedBox(height: 20),
                        DashboardOptions(),
                        SizedBox(height: 20),
                        OrdersOverviewWidget(),
                        SizedBox(height: 20),
                        PendingActionsWidget(),
                        SizedBox(height: 20),
                        RecentOrdersWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            RiderAssignmentDialogsWidget(),
          ],
        ),
      ),
    );
  }
}
