class VendorDetailsModel {
  final int id;
  final String shopName;
  final String? email;
  final String phone;
  final String? photo;
  final String? ownerName;
  final String type;
  final bool isActive;
  final String? openTime;
  final String? closeTime;
  final bool isCompleted;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String nid;
  final String? kycDocument;
  final String? kycStatus;

  VendorDetailsModel({
    required this.id,
    required this.shopName,
    this.email,
    required this.phone,
    this.photo,
    this.ownerName,
    required this.type,
    required this.isActive,
    this.openTime,
    this.closeTime,
    required this.isCompleted,
    this.latitude,
    this.longitude,
    this.locationName,
    required this.nid,
    this.kycDocument,
    this.kycStatus,
  });

  /// Convert JSON to Model
  factory VendorDetailsModel.fromJson(Map<String, dynamic> json) {
    return VendorDetailsModel(
      id: json['id'] as int,
      shopName: json['shop_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      photo: json['photo'] as String?,
      ownerName: json['owner_name'] as String?,
      type: json['type'] as String,
      isActive: json['is_active'] as bool,
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      isCompleted: json['is_completed'] as bool,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      locationName: json['location_name'] as String?,
      nid: json['nid'] as String,
      kycDocument: json['kyc_document'] as String?,
      kycStatus: json['kyc_status'] as String?,
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_name': shopName,
      'email': email,
      'phone': phone,
      'photo': photo,
      'owner_name': ownerName,
      'type': type,
      'is_active': isActive,
      'open_time': openTime,
      'close_time': closeTime,
      'is_completed': isCompleted,
      'latitude': latitude,
      'longitude': longitude,
      'location_name': locationName,
      'nid': nid,
      'kyc_document': kycDocument,
      'kyc_status': kycStatus,
    };
  }

  /// Create a copy with modified fields
  VendorDetailsModel copyWith({
    int? id,
    String? shopName,
    String? email,
    String? phone,
    String? photo,
    String? ownerName,
    String? type,
    bool? isActive,
    String? openTime,
    String? closeTime,
    bool? isCompleted,
    double? latitude,
    double? longitude,
    String? locationName,
    String? nid,
    String? kycDocument,
    String? kycStatus,
  }) {
    return VendorDetailsModel(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      ownerName: ownerName ?? this.ownerName,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      isCompleted: isCompleted ?? this.isCompleted,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      nid: nid ?? this.nid,
      kycDocument: kycDocument ?? this.kycDocument,
      kycStatus: kycStatus ?? this.kycStatus,
    );
  }

  @override
  String toString() {
    return 'VendorDetailsModel(id: $id, shopName: $shopName, email: $email, phone: $phone, type: $type, isActive: $isActive, nid: $nid, kycStatus: $kycStatus)';
  }
}
