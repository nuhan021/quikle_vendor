import 'package:quikle_vendor/features/authentication/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the CategoryController
    final CategoryController controller = Get.put(CategoryController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        backgroundColor: Color(0xFF103161),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            // Add New Category Section
            GestureDetector(
              onTap: () {
                controller.addCategory(); // Add category when clicked
              },
              child: Row(children: [Icon(Icons.add), Text('Add new category')]),
            ),
            SizedBox(height: 10),
            // "Add your own" Section with new userId
            GestureDetector(
              onTap: () {
                controller.addCategory(); // Add a new category when clicked
              },
              child: Row(
                children: [
                  Icon(Icons.add),
                  Text('Add your own'), // Show "Add your own"
                ],
              ),
            ),
            SizedBox(height: 20),
            // Category List Section
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return GestureDetector(
                      onTap: () {
                        // Handle category tap (for editing or viewing)
                      },
                      child: ListTile(
                        title: Text(category.categoryName ?? ''),
                        subtitle: Text(
                          'UserId: ${category.userId}\nCreated: ${category.createdAt}\nUpdated: ${category.updatedAt}',
                          style: getTextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            // New Category TextField for adding categories
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller.categoryController,
                decoration: InputDecoration(
                  hintText: 'Enter new category name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
