class CategoryModel {
  final int? id;
  final String? name;
  final String? image;
  final String? description;
  final int? parentId;
  final int? position;
  final int? status;
  final String? createdAt;
  final String? updatedAt;

  CategoryModel({
    this.id,
    this.name,
    this.image,
    this.description,
    this.parentId,
    this.position,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      parentId: json['parent_id'],
      position: json['position'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
    };
  }
}
