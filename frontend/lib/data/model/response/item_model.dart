import 'package:sushibox/data/model/response/category_id.dart'; // Импортируем модель CategoryId

class ItemModel {
  final int? id;
  final String? name;
  final String? image;
  final String? description;
  final int? parentId;
  final int? position;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final List<CategoryId>? categoryIds;
  final double? price;
  final List<dynamic>? variations;
  final List<dynamic>? addOns;
  final double? tax;
  final String? availableTimeStarts;
  final String? availableTimeEnds;
  final String? discountType;
  final String? taxType;
  final int? setMenu;
  final int? branchId;
  final List<dynamic>? colors;
  final int? popularityCount;
  final String? productType;

  ItemModel({
    this.id,
    this.name,
    this.image,
    this.description,
    this.parentId,
    this.position,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.categoryIds,
    this.price,
    this.variations,
    this.addOns,
    this.tax,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.discountType,
    this.taxType,
    this.setMenu,
    this.branchId,
    this.colors,
    this.popularityCount,
    this.productType,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    List<CategoryId> categoryIds = [];

    // Проверяем, является ли 'category_ids' списком
    if (json['category_ids'] != null) {
      if (json['category_ids'] is List) {
        categoryIds = (json['category_ids'] as List)
            .map((categoryId) => CategoryId.fromJson(categoryId))
            .toList();
      } else {
        // Если 'category_ids' не является списком, это может быть отдельный объект
        categoryIds.add(CategoryId.fromJson(json['category_ids']));
      }
    }

    return ItemModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      parentId: json['parent_id'],
      position: json['position'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryIds: categoryIds.isNotEmpty
          ? categoryIds
          : null, // Исправляем присвоение null, если список пуст
      price: json['price']?.toDouble(),
      variations: json['variations'],
      addOns: json['add_ons'],
      tax: json['tax']?.toDouble(),
      availableTimeStarts: json['available_time_starts'],
      availableTimeEnds: json['available_time_ends'],
      discountType: json['discount_type'],
      taxType: json['tax_type'],
      setMenu: json['set_menu'],
      branchId: json['branch_id'],
      colors: json['colors'],
      popularityCount: json['popularity_count'],
      productType: json['product_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'parent_id': parentId,
      'position': position,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category_ids': categoryIds?.map((cat) => cat.toJson()).toList(),
      'price': price,
      'variations': variations,
      'add_ons': addOns,
      'tax': tax,
      'available_time_starts': availableTimeStarts,
      'available_time_ends': availableTimeEnds,
      'discount_type': discountType,
      'tax_type': taxType,
      'set_menu': setMenu,
      'branch_id': branchId,
      'colors': colors,
      'popularity_count': popularityCount,
      'product_type': productType,
    };
  }
}
