# Vendor Details Setup Guide

## Overview
The vendor details from the API are now stored in the `VendorController` and used throughout the app, particularly in the "My Profile" screen.

## How It Works

### 1. **VendorController** (Centralized Data Storage)
Location: `lib/features/vendor/controllers/vendor_controller.dart`

```dart
final vendorDetails = Rx<VendorDetailsModel?>(null);

void setVendorDetails(Map<String, dynamic> vendorJson) {
  vendorDetails.value = VendorDetailsModel.fromJson(vendorJson);
  log('✅ Vendor details saved in VendorController');
}

VendorDetailsModel? getVendorDetails() => vendorDetails.value;
```

### 2. **Setting Vendor Details from API**
When you receive vendor details from your welcome/registration API:

```dart
// Example in your API service or auth controller
final vendorController = Get.put(VendorController());
final vendorResponse = await apiService.getVendorDetails();
vendorController.setVendorDetails(vendorResponse);
```

### 3. **Using Vendor Details in My Profile Screen**
Location: `lib/features/profile/my_profile/controller/my_profile_controller.dart`

The `MyProfileController` automatically loads vendor details from `VendorController`:

```dart
void _loadVendorDetails() {
  final vendorController = Get.find<VendorController>();
  final details = vendorController.getVendorDetails();
  
  if (details != null) {
    // All text fields are populated with vendor data
    businessNameController.text = details.shopName;
    phoneController.text = details.phone;
    addressController.text = details.locationName ?? '';
    // ... and more fields
  }
}
```

### 4. **VendorDetailsModel Fields Available**
```dart
- id (int)
- shopName (String)
- email (String)
- phone (String)
- photo (String?)
- ownerName (String?)
- type (String)
- isActive (bool)
- openTime (String?)
- closeTime (String?)
- isCompleted (bool)
- latitude (double?)
- longitude (double?)
- locationName (String?)
- nid (String)
- kycDocument (String?)
- kycStatus (String?)
```

## Usage Flow

```
API Response
    ↓
VendorController.setVendorDetails(response)
    ↓
Store in: vendorDetails Observable
    ↓
MyProfileController._loadVendorDetails()
    ↓
Display in My Profile Screen
```

## Example Implementation

### Step 1: Save vendor details after login/registration
```dart
// In your login/registration controller
final vendorController = Get.put(VendorController());
final response = await authService.login(email, password);
vendorController.setVendorDetails(response['vendor']); // Save to controller
```

### Step 2: Access vendor details anywhere in the app
```dart
// Any controller or screen
final vendorController = Get.find<VendorController>();
final vendor = vendorController.getVendorDetails();

if (vendor != null) {
  print('Shop Name: ${vendor.shopName}');
  print('Phone: ${vendor.phone}');
  // Use vendor data...
}
```

## Benefits
✅ Centralized vendor data storage  
✅ No need to pass data between screens  
✅ Observable updates automatically refresh UI  
✅ Easy access from any controller/screen  
✅ Single source of truth for vendor information  

## Clearing Vendor Details (Logout)
```dart
final vendorController = Get.find<VendorController>();
vendorController.clearVendorDetails(); // Clears all vendor data
```
