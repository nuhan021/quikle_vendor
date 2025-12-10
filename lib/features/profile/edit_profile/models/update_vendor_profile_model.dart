class UpdateVendorProfileRequest {
  final String ownerName;
  final String openTime;  // e.g. "11:00:00"
  final String closeTime; // e.g. "22:00:00"

  UpdateVendorProfileRequest({
    required this.ownerName,
    required this.openTime,
    required this.closeTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'owner_name': ownerName,
      'open_time': openTime,
      'close_time': closeTime,
    };
  }
}
