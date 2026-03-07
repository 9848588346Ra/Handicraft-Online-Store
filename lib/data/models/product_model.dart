/// Product model for admin-managed products.
class ProductModel {
  final String id;
  final String title;
  final String price;
  final String imagePath;
  final String category;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.imagePath,
    this.category = 'General',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'imagePath': imagePath,
        'category': category,
      };

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        price: json['price'] as String? ?? '',
        imagePath: json['imagePath'] as String? ?? '',
        category: json['category'] as String? ?? 'General',
      );

  ProductModel copyWith({
    String? id,
    String? title,
    String? price,
    String? imagePath,
    String? category,
  }) =>
      ProductModel(
        id: id ?? this.id,
        title: title ?? this.title,
        price: price ?? this.price,
        imagePath: imagePath ?? this.imagePath,
        category: category ?? this.category,
      );
}
