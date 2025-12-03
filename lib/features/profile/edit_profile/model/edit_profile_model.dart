class EditProfileModel {
  final String? shopName;
  final String? ownerName;
  final String? email;
  final String? phone;
  final String? address;
  final String? openingHours;
  final String? photoPath;
  final String? businessType;
  final String? description;

  EditProfileModel({
    this.shopName,
    this.ownerName,
    this.email,
    this.phone,
    this.address,
    this.openingHours,
    this.photoPath,
    this.businessType,
    this.description,
  });

  /// Create model from JSON (from StorageService/VendorDetails)
  factory EditProfileModel.fromJson(Map<String, dynamic> json) {
    return EditProfileModel(
      shopName: json['shop_name'] as String?,
      ownerName: json['owner_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['location_name'] as String?,
      openingHours: json['opening_hours'] as String?,
      photoPath: json['photo'] as String?,
      businessType: json['type'] as String?,
      description: json['description'] as String?,
    );
  }

  /// Convert model to JSON (for StorageService)
  Map<String, dynamic> toJson() {
    return {
      'shop_name': shopName,
      'owner_name': ownerName,
      'email': email,
      'phone': phone,
      'location_name': address,
      'opening_hours': openingHours,
      'photo': photoPath,
      'type': businessType,
      'description': description,
    };
  }

  /// Create a copy with modified fields
  EditProfileModel copyWith({
    String? shopName,
    String? ownerName,
    String? email,
    String? phone,
    String? address,
    String? openingHours,
    String? photoPath,
    String? businessType,
    String? description,
  }) {
    return EditProfileModel(
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      openingHours: openingHours ?? this.openingHours,
      photoPath: photoPath ?? this.photoPath,
      businessType: businessType ?? this.businessType,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'EditProfileModel(shopName: $shopName, ownerName: $ownerName, email: $email, phone: $phone, openingHours: $openingHours)';
  }
}
