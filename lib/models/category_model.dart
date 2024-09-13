class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  // Convert JSON to Category object
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }

  // Convert Category object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
