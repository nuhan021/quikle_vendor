class MyProfileModel {
  final String shopName;
  final String ownerName;
  final String email;
  final String phone;
  final String address;
  final String accountStatus;
  final String servicesOffered;
  final String contactPerson;
  final String openingHours;
  final String panelLicense;
  final String tinNumber;
  final String? photo;
  final bool isActive;

  MyProfileModel({
    required this.shopName,
    required this.ownerName,
    required this.email,
    required this.phone,
    required this.address,
    required this.accountStatus,
    required this.servicesOffered,
    required this.contactPerson,
    required this.openingHours,
    required this.panelLicense,
    required this.tinNumber,
    this.photo,
    required this.isActive,
  });

  /// Create from VendorDetailsModel
  factory MyProfileModel.fromVendorDetails(Map<String, dynamic> json) {
    final openTime = json['open_time'] as String?;
    final closeTime = json['close_time'] as String?;
    final openingHours = (openTime != null && closeTime != null)
        ? "$openTime - $closeTime"
        : "9:00 AM - 8:00 PM";

    final isActive = json['is_active'] == true || json['is_active'] == 1;

    return MyProfileModel(
      shopName: json['shop_name']?.toString() ?? 'Tandoori Tarang',
      ownerName: json['owner_name']?.toString() ?? 'Vikash Rajput',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '+963-172-345678',
      address:
          json['location_name']?.toString() ??
          'House 34, Road 12, Dhanmondi, Dhaka',
      accountStatus: isActive ? 'Active' : 'Inactive',
      servicesOffered: 'Describe services offered',
      contactPerson: json['owner_name']?.toString() ?? 'Vikram Rajput',
      openingHours: openingHours,
      panelLicense: 'Not Provided',
      tinNumber: json['nid']?.toString() ?? '+963-172-345678',
      photo: json['photo'] as String?,
      isActive: isActive,
    );
  }

  /// Convert to JSON for updates
  Map<String, dynamic> toJson() {
    return {
      'shop_name': shopName,
      'owner_name': ownerName,
      'email': email,
      'phone': phone,
      'location_name': address,
      'photo': photo,
      'is_active': isActive,
    };
  }

  /// Create a copy with modified fields
  MyProfileModel copyWith({
    String? shopName,
    String? ownerName,
    String? email,
    String? phone,
    String? address,
    String? accountStatus,
    String? servicesOffered,
    String? contactPerson,
    String? openingHours,
    String? panelLicense,
    String? tinNumber,
    String? photo,
    bool? isActive,
  }) {
    return MyProfileModel(
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      accountStatus: accountStatus ?? this.accountStatus,
      servicesOffered: servicesOffered ?? this.servicesOffered,
      contactPerson: contactPerson ?? this.contactPerson,
      openingHours: openingHours ?? this.openingHours,
      panelLicense: panelLicense ?? this.panelLicense,
      tinNumber: tinNumber ?? this.tinNumber,
      photo: photo ?? this.photo,
      isActive: isActive ?? this.isActive,
    );
  }
}
