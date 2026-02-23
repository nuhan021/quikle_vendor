class Product {
  final int id;
  final String title;
  final String description;
  final int categoryId;
  final int subcategoryId;
  final int subSubcategoryId;
  final String? subSubcategoryName;
  final String? subSubcategoryAvatar;
  final String price;
  final int discount;
  final String discountedPrice;
  final String sellPrice;
  final double ratings;
  final int totalReviews;
  final RatingsSummary ratingsSummary;
  final int stock;
  final int totalSale;
  final bool popular;
  final bool freeDelivery;
  final bool hotDeals;
  final bool flashSale;
  final double weight;
  final int vendorId;
  final String? shopImage;
  final String shopName;
  final String image;
  final bool isOTC;
  final bool isInStock;
  final bool newArrival;
  final bool todayDeals;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.subcategoryId,
    required this.subSubcategoryId,
    this.subSubcategoryName,
    this.subSubcategoryAvatar,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.sellPrice,
    required this.ratings,
    required this.totalReviews,
    required this.ratingsSummary,
    required this.stock,
    required this.totalSale,
    required this.popular,
    required this.freeDelivery,
    required this.hotDeals,
    required this.flashSale,
    required this.weight,
    required this.vendorId,
    this.shopImage,
    required this.shopName,
    required this.image,
    required this.isOTC,
    required this.isInStock,
    required this.newArrival,
    required this.todayDeals,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: json['category_id'] as int? ?? 0,
      subcategoryId: json['subcategory_id'] as int? ?? 0,
      subSubcategoryId: json['sub_subcategory_id'] as int? ?? 0,
      subSubcategoryName: json['sub_subcategory_name'] as String?,
      subSubcategoryAvatar: json['sub_subcategory_avatar'] as String?,
      price: json['price'] as String? ?? '0.0',
      discount: json['discount'] as int? ?? 0,
      discountedPrice: json['discounted_price'] as String? ?? '0.0',
      sellPrice: json['sell_price'] as String? ?? '0.0',
      ratings: (json['ratings'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      ratingsSummary: RatingsSummary.fromJson(
        json['ratings_summery'] as Map<String, dynamic>,
      ),
      stock: json['stock'] as int? ?? 0,
      totalSale: json['total_sale'] as int? ?? 0,
      popular: json['popular'] as bool? ?? false,
      freeDelivery: json['free_delivery'] as bool? ?? false,
      hotDeals: json['hot_deals'] as bool? ?? false,
      flashSale: json['flash_sale'] as bool? ?? false,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      vendorId: json['vendor_id'] as int? ?? 0,
      shopImage: json['shop_image'] as String?,
      shopName: json['shop_name'] as String? ?? '',
      image: json['image'] as String? ?? '',
      isOTC:
          (json['isOTC'] as bool?) ?? (json['isSignature'] as bool?) ?? false,
      isInStock: json['is_in_stock'] as bool? ?? true,
      newArrival: json['new_arrival'] as bool? ?? false,
      todayDeals: json['today_deals'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category_id': categoryId,
      'subcategory_id': subcategoryId,
      'sub_subcategory_id': subSubcategoryId,
      'sub_subcategory_name': subSubcategoryName,
      'sub_subcategory_avatar': subSubcategoryAvatar,
      'price': price,
      'discount': discount,
      'discounted_price': discountedPrice,
      'sell_price': sellPrice,
      'ratings': ratings,
      'total_reviews': totalReviews,
      'ratings_summery': ratingsSummary.toJson(),
      'stock': stock,
      'total_sale': totalSale,
      'popular': popular,
      'free_delivery': freeDelivery,
      'hot_deals': hotDeals,
      'flash_sale': flashSale,
      'weight': weight,
      'vendor_id': vendorId,
      'shop_image': shopImage,
      'shop_name': shopName,
      'image': image,
      'isOTC': isOTC,
      'is_in_stock': isInStock,
      'new_arrival': newArrival,
      'today_deals': todayDeals,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class RatingsSummary {
  final int oneStar;
  final int twoStars;
  final int threeStars;
  final int fourStars;
  final int fiveStars;

  RatingsSummary({
    required this.oneStar,
    required this.twoStars,
    required this.threeStars,
    required this.fourStars,
    required this.fiveStars,
  });

  factory RatingsSummary.fromJson(Map<String, dynamic> json) {
    return RatingsSummary(
      oneStar: (json['1'] as num?)?.toInt() ?? 0,
      twoStars: (json['2'] as num?)?.toInt() ?? 0,
      threeStars: (json['3'] as num?)?.toInt() ?? 0,
      fourStars: (json['4'] as num?)?.toInt() ?? 0,
      fiveStars: (json['5'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '1': oneStar,
      '2': twoStars,
      '3': threeStars,
      '4': fourStars,
      '5': fiveStars,
    };
  }
}
