class CategoryId {
  final String? id;
  final int? position;

  CategoryId({
    this.id,
    this.position,
  });

  factory CategoryId.fromJson(Map<String, dynamic> json) {
    return CategoryId(
      id: json['id'].toString(),
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
    };
  }
}
