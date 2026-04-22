class ProductCategoryModel {
  final int id;
  final String name;
  final String slug;
  final String image;
  final DateTime creationAt;
  final DateTime updatedAt;

  const ProductCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.creationAt,
    required this.updatedAt,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
      creationAt: DateTime.tryParse(json['creationAt'] ?? '') ?? DateTime(1970),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime(1970),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
      'creationAt': creationAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static List<ProductCategoryModel> listFromJson(List<dynamic> list) {
    return list
        .map((e) => ProductCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<ProductCategoryModel> listFromDynamic(dynamic json) {
    if (json is List<dynamic>) {
      return listFromJson(json);
    }
    return const <ProductCategoryModel>[];
  }
}

class ProductModel {
  final int id;
  final String title;
  final String slug;
  final double price;
  final String description;
  final ProductCategoryModel category;
  final List<String> images;
  final DateTime creationAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.creationAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] ?? '',
      category: ProductCategoryModel.fromJson(
        json['category'] as Map<String, dynamic>? ?? <String, dynamic>{},
      ),
      images: (json['images'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      creationAt: DateTime.tryParse(json['creationAt'] ?? '') ?? DateTime(1970),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime(1970),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'description': description,
      'category': category.toJson(),
      'images': images,
      'creationAt': creationAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static List<ProductModel> listFromJson(List<dynamic> list) {
    return list
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<ProductModel> listFromDynamic(dynamic json) {
    if (json is List<dynamic>) {
      return listFromJson(json);
    }
    return const <ProductModel>[];
  }
}
