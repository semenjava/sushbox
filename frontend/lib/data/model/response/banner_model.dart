class BannerModel {
  final int? id;
  final String? title;
  final String? image;
  final int? productId;
  final int? status;
  final String? createdAt;
  final String? updatedAt;
  final int? categoryId;

  BannerModel({
    this.id,
    this.title,
    this.image,
    this.productId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      productId: json['product_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'product_id': productId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category_id': categoryId,
    };
  }
}
