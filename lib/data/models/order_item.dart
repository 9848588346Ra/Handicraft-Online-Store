/// Order item model for My Orders (ongoing/completed).
class OrderItem {
  final String orderId;
  final String productName;
  final String imagePath;
  final String price;
  final String address;
  final String date;
  final String userEmail;

  OrderItem({
    required this.orderId,
    required this.productName,
    required this.imagePath,
    required this.price,
    required this.address,
    required this.date,
    this.userEmail = '',
  });

  OrderItem copyWith({
    String? orderId,
    String? productName,
    String? imagePath,
    String? price,
    String? address,
    String? date,
    String? userEmail,
  }) =>
      OrderItem(
        orderId: orderId ?? this.orderId,
        productName: productName ?? this.productName,
        imagePath: imagePath ?? this.imagePath,
        price: price ?? this.price,
        address: address ?? this.address,
        date: date ?? this.date,
        userEmail: userEmail ?? this.userEmail,
      );

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'productName': productName,
        'imagePath': imagePath,
        'price': price,
        'address': address,
        'date': date,
        'userEmail': userEmail,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderId: json['orderId'] as String? ?? '',
        productName: json['productName'] as String? ?? '',
        imagePath: json['imagePath'] as String? ?? '',
        price: json['price'] as String? ?? '',
        address: json['address'] as String? ?? '',
        date: json['date'] as String? ?? '',
        userEmail: json['userEmail'] as String? ?? '',
      );
}
