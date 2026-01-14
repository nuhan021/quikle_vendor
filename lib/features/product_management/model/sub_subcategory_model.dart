class SubSubcategoryModel {
  final int id;
  final String name;
  final String? description;
  final String? avatar;
  final String createdAt;
  final SubcategoryInfo subcategory;

  SubSubcategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.avatar,
    required this.createdAt,
    required this.subcategory,
  });

  factory SubSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubSubcategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['created_at'] as String,
      subcategory: SubcategoryInfo.fromJson(
        json['subcategory'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'created_at': createdAt,
      'subcategory': subcategory.toJson(),
    };
  }
}

class SubcategoryInfo {
  final int id;
  final String name;
  final CategoryInfo category;

  SubcategoryInfo({
    required this.id,
    required this.name,
    required this.category,
  });

  factory SubcategoryInfo.fromJson(Map<String, dynamic> json) {
    return SubcategoryInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      category: CategoryInfo.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toJson(),
    };
  }
}

class CategoryInfo {
  final int id;
  final String name;

  CategoryInfo({
    required this.id,
    required this.name,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
