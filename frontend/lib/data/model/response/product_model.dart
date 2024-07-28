class ProductModel {
  int totalSize;
  dynamic limit;
  dynamic offset;
  List<Product> products;

  ProductModel({
    required this.totalSize,
    this.limit,
    this.offset,
    required this.products,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      totalSize: json['total_size'] ??
          0, // Присваиваем 0, если 'total_size' отсутствует или null
      limit: json['limit'],
      offset: json['offset'],
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [], // Присваиваем пустой список, если 'products' отсутствует или null
    );
  }

  Map<String, dynamic> toJson() => {
        'total_size': totalSize,
        'limit': limit,
        'offset': offset,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  int id;
  String name;
  String description;
  String image;
  double price;
  List<Variation> variations;
  List<AddOn> addOns;
  double tax;
  String availableTimeStarts;
  String availableTimeEnds;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  List<dynamic> attributes;
  List<CategoryId> categoryIds;
  List<ChoiceOption> choiceOptions;
  double discount;
  String discountType;
  String taxType;
  int setMenu;
  int branchId;
  dynamic colors;
  int popularityCount;
  String productType;
  int wishlistCount;
  List<dynamic> rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.variations,
    required this.addOns,
    required this.tax,
    required this.availableTimeStarts,
    required this.availableTimeEnds,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.attributes,
    required this.categoryIds,
    required this.choiceOptions,
    required this.discount,
    required this.discountType,
    required this.taxType,
    required this.setMenu,
    required this.branchId,
    this.colors,
    required this.popularityCount,
    required this.productType,
    required this.wishlistCount,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0, // Присваиваем 0, если 'id' отсутствует или null
      name: json['name'] ??
          '', // Присваиваем пустую строку, если 'name' отсутствует или null
      description: json['description'] ??
          '', // Присваиваем пустую строку, если 'description' отсутствует или null
      image: json['image'] ??
          '', // Присваиваем пустую строку, если 'image' отсутствует или null
      price: (json['price'] ?? 0.0)
          .toDouble(), // Присваиваем 0.0, если 'price' отсутствует или null
      variations: (json['variations'] != null)
          ? List<Variation>.from(
              json['variations'].map((x) => Variation.fromJson(x)))
          : [], // Присваиваем пустой список, если 'variations' отсутствует или null
      addOns: (json['add_ons'] != null)
          ? List<AddOn>.from(json['add_ons'].map((x) => AddOn.fromJson(x)))
          : [], // Присваиваем пустой список, если 'add_ons' отсутствует или null
      tax: (json['tax'] ?? 0.0)
          .toDouble(), // Присваиваем 0.0, если 'tax' отсутствует или null
      availableTimeStarts: json['available_time_starts'] ??
          '', // Присваиваем пустую строку, если 'available_time_starts' отсутствует или null
      availableTimeEnds: json['available_time_ends'] ??
          '', // Присваиваем пустую строку, если 'available_time_ends' отсутствует или null
      status: json['status'] ??
          0, // Присваиваем 0, если 'status' отсутствует или null
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ??
          DateTime
              .now(), // Присваиваем текущее время, если 'created_at' отсутствует или null
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ??
          DateTime
              .now(), // Присваиваем текущее время, если 'updated_at' отсутствует или null
      attributes: json['attributes'] ??
          [], // Присваиваем пустой список, если 'attributes' отсутствует или null
      categoryIds: (json['category_ids'] != null)
          ? List<CategoryId>.from(
              json['category_ids'].map((x) => CategoryId.fromJson(x)))
          : [], // Присваиваем пустой список, если 'category_ids' отсутствует или null
      choiceOptions: (json['choice_options'] != null)
          ? List<ChoiceOption>.from(
              json['choice_options'].map((x) => ChoiceOption.fromJson(x)))
          : [], // Присваиваем пустой список, если 'choice_options' отсутствует или null
      discount: (json['discount'] ?? 0.0)
          .toDouble(), // Присваиваем 0.0, если 'discount' отсутствует или null
      discountType: json['discount_type'] ??
          '', // Присваиваем пустую строку, если 'discount_type' отсутствует или null
      taxType: json['tax_type'] ??
          '', // Присваиваем пустую строку, если 'tax_type' отсутствует или null
      setMenu: json['set_menu'] ??
          0, // Присваиваем 0, если 'set_menu' отсутствует или null
      branchId: json['branch_id'] ??
          0, // Присваиваем 0, если 'branch_id' отсутствует или null
      colors: json[
          'colors'], // Может оставить как dynamic, если нет явного ожидания типа
      popularityCount: json['popularity_count'] ??
          0, // Присваиваем 0, если 'popularity_count' отсутствует или null
      productType: json['product_type'] ??
          '', // Присваиваем пустую строку, если 'product_type' отсутствует или null
      wishlistCount: json['wishlist_count'] ??
          0, // Присваиваем 0, если 'wishlist_count' отсутствует или null
      rating: json['rating'] ??
          [], // Присваиваем пустой список, если 'rating' отсутствует или null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'price': price,
      'variations': List<dynamic>.from(variations.map((x) => x.toJson())),
      'add_ons': List<dynamic>.from(addOns.map((x) => x.toJson())),
      'tax': tax,
      'available_time_starts': availableTimeStarts,
      'available_time_ends': availableTimeEnds,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'attributes': attributes,
      'category_ids': List<dynamic>.from(categoryIds.map((x) => x.toJson())),
      'choice_options':
          List<dynamic>.from(choiceOptions.map((x) => x.toJson())),
      'discount': discount,
      'discount_type': discountType,
      'tax_type': taxType,
      'set_menu': setMenu,
      'branch_id': branchId,
      'colors': colors,
      'popularity_count': popularityCount,
      'product_type': productType,
      'wishlist_count': wishlistCount,
      'rating': List<dynamic>.from(rating),
    };
  }
}

class CategoryId {
  String id;
  int position;

  CategoryId({
    required this.id,
    required this.position,
  });

  factory CategoryId.fromJson(Map<String, dynamic> json) {
    return CategoryId(
      id: json['id'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'position': position,
      };
}

// Доработка других классов аналогичным образом...
class Variation {
  // Define properties
  final int id;
  final String name;

  // Constructor
  Variation({required this.id, required this.name});

  // fromJson method
  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'],
      name: json['name'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class AddOn {
  // Define properties
  final int id;
  final String name;
  final double price;

  // Constructor
  AddOn({required this.id, required this.name, required this.price});

  // fromJson method
  factory AddOn.fromJson(Map<String, dynamic> json) {
    return AddOn(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}

class ChoiceOption {
  // Define properties
  final int id;
  final String name;
  final List<String> options;

  // Constructor
  ChoiceOption({required this.id, required this.name, required this.options});

  // fromJson method
  factory ChoiceOption.fromJson(Map<String, dynamic> json) {
    var optionsFromJson = json['options'];
    List<String> optionsList = List<String>.from(optionsFromJson);

    return ChoiceOption(
      id: json['id'],
      name: json['name'],
      options: optionsList,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'options': options,
    };
  }
}
