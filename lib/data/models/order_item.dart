/// Order item model for My Orders (ongoing/completed).
class OrderItem {
  final String productName;
  final String imagePath;
  final String price;
  final String address;
  final String date;

  OrderItem({
    required this.productName,
    required this.imagePath,
    required this.price,
    required this.address,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'imagePath': imagePath,
        'price': price,
        'address': address,
        'date': date,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productName: json['productName'] as String? ?? '',
        imagePath: json['imagePath'] as String? ?? '',
        price: json['price'] as String? ?? '',
        address: json['address'] as String? ?? '',
        date: json['date'] as String? ?? '',
      );
}
