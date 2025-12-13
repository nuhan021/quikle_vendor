class Prescription {
  final int id;
  final int userId;
  final String userName;
  final String imagePath;
  final String status;
  final String notes;
  final String uploadedAt;

  Prescription({
    required this.id,
    required this.userId,
    required this.userName,
    required this.imagePath,
    required this.status,
    required this.notes,
    required this.uploadedAt,
  });

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      userName: json['user_name'] as String,
      imagePath: json['image_path'] as String,
      status: json['status'] as String? ?? 'pending',
      notes: json['notes'] as String? ?? '',
      uploadedAt: json['uploaded_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'image_path': imagePath,
      'status': status,
      'notes': notes,
      'uploaded_at': uploadedAt,
    };
  }
}
