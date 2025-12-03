class VendorDetailsModel {
  final int id;
  final String shopName;
  final String email;
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
    required this.email,
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
    int parseInt(dynamic v) {
      if (v is int) return v;
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    bool parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      final s = v?.toString().toLowerCase();
      if (s == 'true') return true;
      if (s == 'false') return false;
      return false;
    }

    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return VendorDetailsModel(
      id: parseInt(json['id'] ?? json['user_id'] ?? json['vendor_id']),
      shopName: (json['shop_name'] ?? json['shopName'] ?? '').toString(),
      email: json['email'] as String,
      phone: (json['phone'] ?? '').toString(),
      photo: json['photo'] as String?,
      ownerName: json['owner_name'] as String?,
      type: (json['type'] ?? '').toString(),
      isActive: parseBool(json['is_active']),
      openTime: json['open_time'] as String?,
      closeTime: json['close_time'] as String?,
      isCompleted: parseBool(json['is_completed']),
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      locationName: json['location_name'] as String?,
      nid: (json['nid'] ?? '').toString(),
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
