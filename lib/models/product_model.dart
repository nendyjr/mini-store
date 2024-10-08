class Product {
  final String internalId;
  final int id;
  final int? categoryId;
  final String? categoryName;
  final String? sku;
  final String? name;
  final String? description;
  final int? weight;
  final int? width;
  final int? length;
  final int? height;
  final String? image;
  final int? harga;

  Product({
    required this.internalId,
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.sku,
    required this.name,
    required this.description,
    required this.weight,
    required this.width,
    required this.length,
    required this.height,
    required this.image,
    required this.harga,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      internalId: json['_id'],
      id: json['id'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      sku: json['sku'],
      name: json['name'],
      description: json['description'],
      weight: json['weight'],
      width: json['width'],
      length: json['length'],
      height: json['height'],
      image: json['image'],
      harga: json['harga'],
    );
  }

  // Convert Product to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      '_id': internalId,
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'sku': sku,
      'name': name,
      'description': description,
      'weight': weight,
      'width': width,
      'length': length,
      'height': height,
      'image': image,
      'harga': harga,
    };
  }

  Map<String, dynamic> addProductToJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'sku': sku,
      'name': name,
      'description': description,
      'weight': weight,
      'width': width,
      'length': length,
      'height': height,
      'image': image,
      'harga': harga,
    };
  }
}
