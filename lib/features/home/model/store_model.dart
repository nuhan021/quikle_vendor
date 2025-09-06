class StoreModel {
  final String name;
  final String logoUrl;
  final bool isOpen;
  final String closingTime;

  StoreModel({
    required this.name,
    required this.logoUrl,
    required this.isOpen,
    required this.closingTime,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      isOpen: json['isOpen'] ?? false,
      closingTime: json['closingTime'] ?? '',
    );
  }

  StoreModel copyWith({
    String? name,
    String? logoUrl,
    bool? isOpen,
    String? closingTime,
  }) {
    return StoreModel(
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      isOpen: isOpen ?? this.isOpen,
      closingTime: closingTime ?? this.closingTime,
    );
  }
}
