/// Shared cart item model used by CartProvider and CartScreen.
class CartItem {
  final String name;
  final String imagePath;
  final double price;
  final int quantity;

  CartItem(this.name, this.imagePath, this.price, this.quantity);

  CartItem copyWith({int? quantity}) {
    return CartItem(name, imagePath, price, quantity ?? this.quantity);
  }
}
