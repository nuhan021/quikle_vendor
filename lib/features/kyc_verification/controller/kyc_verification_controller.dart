import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class KycVerificationController extends GetxController {
  /// -------------------- Observables --------------------
  var kycFiles = <File>[].obs; // multiple files
  var uploadProgress = <double>[].obs; // progress for each file (0.0–1.0)
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = "".obs;
  var isSubmitting = false.obs;
  var searchAddress = "".obs; // for address search
  var isSearching = false.obs;

  /// Map Controller
  late GoogleMapController mapController;

  /// -------------------- Pick Multiple Files --------------------
  Future<void> pickKycFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'png', 'pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        kycFiles.clear();
        uploadProgress.clear();

        for (final file in result.files) {
          if (file.path != null) {
            kycFiles.add(File(file.path!));
            uploadProgress.add(0.0);
          }
        }

        /// Simulate fake upload progress (mocking real upload)
        for (int i = 0; i < kycFiles.length; i++) {
          for (int j = 1; j <= 10; j++) {
            await Future.delayed(const Duration(milliseconds: 100));
            uploadProgress[i] = j / 10;
            uploadProgress.refresh();
          }
        }

        Get.snackbar("Uploaded", "${kycFiles.length} file(s) selected");
      } else {
        Get.snackbar("Cancelled", "No files selected");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick files: $e");
    }
  }

  /// -------------------- Pick Location --------------------
  Future<void> pickCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Denied",
          "Please enable location permissions from settings",
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Reverse geocoding
      final placemarks = await placemarkFromCoordinates(
        latitude.value,
        longitude.value,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        address.value =
            "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}";
      }

      Get.snackbar("Success", "Location fetched successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to get location: $e");
    }
  }

  /// -------------------- Map Tap --------------------
  Future<void> setMapLocation(double lat, double lng) async {
    latitude.value = lat;
    longitude.value = lng;

    // Log location selection
    log('📍 Location Selected from Map:');
    log('   Latitude: $lat');
    log('   Longitude: $lng');

    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        address.value =
            "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}";
        log('   Address: ${address.value}');
      }
    } catch (_) {}
  }

  /// -------------------- Search Location from Address --------------------
  Future<void> searchLocationFromAddress(String addressQuery) async {
    if (addressQuery.trim().isEmpty) {
      Get.snackbar("Error", "Please enter an address");
      return;
    }

    try {
      isSearching.value = true;
      final locations = await locationFromAddress(addressQuery);

      if (locations.isNotEmpty) {
        final location = locations.first;
        latitude.value = location.latitude;
        longitude.value = location.longitude;

        // Log location from address search
        log('🔍 Location Found from Address Search:');
        log('   Query: "$addressQuery"');
        log('   Latitude: ${location.latitude}');
        log('   Longitude: ${location.longitude}');

        // Get readable address from coordinates
        final placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          address.value =
              "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}";
          print('   Address: ${address.value}');
        }

        Get.snackbar("Success", "Location found on map!");
        searchAddress.value = ""; // Clear search field

        // Animate camera to searched location
        Future.delayed(const Duration(milliseconds: 300), () {
          mapController.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(location.latitude, location.longitude),
              15,
            ),
          );
        });
      } else {
        Get.snackbar("Not Found", "Address not found. Try another search.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to search address: $e");
    } finally {
      isSearching.value = false;
    }
  }

  /// -------------------- Set Map Controller --------------------
  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  /// -------------------- Submit --------------------
  Future<void> submitKyc() async {
    if (kycFiles.isEmpty) {
      Get.snackbar("Error", "Please upload at least one KYC document");
      return;
    }

    if (latitude.value == 0.0 || longitude.value == 0.0) {
      Get.snackbar("Error", "Please select your business location");
      return;
    }

    try {
      isSubmitting.value = true;

      // Log KYC submission data
      log('\n📤 KYC Submission Log:');
      log('   Files Count: ${kycFiles.length}');
      for (int i = 0; i < kycFiles.length; i++) {
        log('   File $i: ${kycFiles[i].path.split('/').last}');
      }
      log('   Location:');
      log('     Latitude: ${latitude.value}');
      log('     Longitude: ${longitude.value}');
      log('     Address: ${address.value}');
      log('   Sending to Backend...');

      // TODO: integrate actual multipart API call
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar("Success", "KYC submitted successfully!");
    } catch (e) {
      Get.snackbar("Error", "Submission failed: $e");
    } finally {
      isSubmitting.value = false;
    }
  }
}
