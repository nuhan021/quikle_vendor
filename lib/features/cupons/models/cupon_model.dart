class CouponModel {
  int id;
  String title;
  String description;
  String code;
  int discount;
  int? productId; // null = apply to all products
  List<dynamic> items;
  DateTime? createdAt;

  CouponModel({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discount,
    this.productId,
    required this.items,
    this.createdAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      code: json['cupon'],
      discount: json['discount'],
      productId: json['product_id'],
      items: json['items'] ?? [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
