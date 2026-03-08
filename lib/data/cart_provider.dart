import 'package:flutter/foundation.dart';
import 'package:handicraft_online_store/data/models/cart_item.dart';

/// Shared cart state used by Shop and Cart screens.
class CartProvider extends ChangeNotifier {
  CartProvider._();
  static final CartProvider _instance = CartProvider._();
  static CartProvider get instance => _instance;

  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get total =>
      _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(CartItem item) {
    final existing = _items.indexWhere((i) =>
        i.name == item.name && i.imagePath == item.imagePath && i.price == item.price);
    if (existing >= 0) {
      _items[existing] = _items[existing].copyWith(
          quantity: _items[existing].quantity + item.quantity);
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void updateQuantity(int index, int delta) {
    if (index < 0 || index >= _items.length) return;
    final newQty = _items[index].quantity + delta;
    if (newQty >= 1) {
      _items[index] = _items[index].copyWith(quantity: newQty);
      notifyListeners();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  /// Removes multiple items by indices. Indices are removed from highest to
  /// lowest to avoid index shifting issues.
  void removeItemsAtIndices(List<int> indices) {
    if (indices.isEmpty) return;
    final sorted = List<int>.from(indices)..sort((a, b) => b.compareTo(a));
    for (final i in sorted) {
      if (i >= 0 && i < _items.length) {
        _items.removeAt(i);
      }
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
