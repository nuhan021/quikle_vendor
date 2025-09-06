import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';

class StoreInfoWidget extends StatelessWidget {
  const StoreInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Obx(() {
      final store = controller.store.value;
      if (store == null) return const SizedBox();

      return Card(
        color: ,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              /// Store Logo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: const Icon(
                  Icons.restaurant,
                  size: 30,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),

              /// Store Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: store.isOpen ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          store.isOpen
                              ? "Open • Until ${store.closingTime}"
                              : "Closed",
                          style: TextStyle(
                            fontSize: 13,
                            color: store.isOpen ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Toggle
              Switch(
                value: store.isOpen,
                onChanged: (_) => controller.toggleStoreStatus(),
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
      );
    });
  }
}
