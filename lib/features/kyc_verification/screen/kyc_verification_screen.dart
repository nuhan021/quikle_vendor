import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/custom_button.dart';
import '../../../../core/common/widgets/custom_textfield.dart';
import '../../../routes/app_routes.dart';
import '../../appbar/screen/appbar_screen.dart';
import '../controller/kyc_verification_controller.dart';

class KycVerificationScreen extends StatelessWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KycVerificationController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: const AppbarScreen(title: "KYC Verification"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Location Section (MOVED TO TOP)
              Text(
                "Business Location",
                style: getTextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              /// Address Search Field
              CustomTextField(
                label: "",
                hintText: "Search location by address",
                onChanged: (value) => controller.searchAddress.value = value,
                suffixIcon: Obx(
                  () => controller.isSearching.value
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () => controller.searchLocationFromAddress(
                            controller.searchAddress.value,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),

              if (controller.address.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    controller.address.value,
                    style: getTextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ),
              const SizedBox(height: 8),

              /// Google Map
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black26),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        controller.latitude.value == 0.0
                            ? 23.7806
                            : controller.latitude.value,
                        controller.longitude.value == 0.0
                            ? 90.2794
                            : controller.longitude.value,
                      ),
                      zoom: 13,
                    ),
                    onMapCreated: (GoogleMapController mapController) {
                      controller.setMapController(mapController);
                    },
                    onTap: (LatLng pos) =>
                        controller.setMapLocation(pos.latitude, pos.longitude),
                    markers: {
                      if (controller.latitude.value != 0.0)
                        Marker(
                          markerId: const MarkerId("selected"),
                          position: LatLng(
                            controller.latitude.value,
                            controller.longitude.value,
                          ),
                        ),
                    },
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// File Upload Section (MOVED TO BOTTOM)
              Text(
                "KYC Documents",
                style: getTextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: controller.pickKycFiles,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Tap to upload KYC files",
                      style: getTextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Show uploaded files with progress bars
              for (int i = 0; i < controller.kycFiles.length; i++)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              controller.kycFiles[i].path.split('/').last,
                              style: getTextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.red,
                            ),
                            onPressed: () => controller.removeKycFile(i),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      LinearProgressIndicator(
                        value: controller.uploadProgress[i],
                        color: Colors.black,
                        backgroundColor: Colors.grey.shade300,
                        minHeight: 5,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),

              /// NID Field
              CustomTextField(
                label: "National ID (NID)",
                hintText: "Enter your NID number",
                controller: controller.nidController,
              ),
              const SizedBox(height: 20),

              /// Submit Button
              CustomButton(
                text: controller.isSubmitting.value
                    ? "Submitting..."
                    : "Submit",
                onPressed: controller.isSubmitting.value
                    ? () {}
                    : () async {
                        await controller.submitKyc();
                        // Ensure navigation even if controller fails
                        // (controller already calls navigation, but this is a fallback)
                        Get.offAllNamed(AppRoute.kycApprovalScreen);
                      },
                height: 50,
                borderRadius: 10,
                backgroundColor: controller.isSubmitting.value
                    ? Colors.grey
                    : Colors.black,
                textColor: Colors.white,
                fontSize: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
