import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:handicraft_online_store/data/models/cart_item.dart';
import 'package:handicraft_online_store/data/models/order_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyOngoing = 'order_provider_ongoing';
const String _keyCompleted = 'order_provider_completed';

/// Stores ongoing and completed orders. Persists to SharedPreferences.
class OrderProvider extends ChangeNotifier {
  OrderProvider._() {
    _loadFromStorage();
  }
  static final OrderProvider _instance = OrderProvider._();
  static OrderProvider get instance => _instance;

  final List<OrderItem> _ongoingOrders = [];
  final List<OrderItem> _completedOrders = [];

  List<OrderItem> get ongoingOrders => List.unmodifiable(_ongoingOrders);
  List<OrderItem> get completedOrders => List.unmodifiable(_completedOrders);

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ongoingJson = prefs.getString(_keyOngoing);
      final completedJson = prefs.getString(_keyCompleted);
      if (ongoingJson != null) {
        final list = jsonDecode(ongoingJson) as List<dynamic>?;
        if (list != null) {
          _ongoingOrders.clear();
          for (final e in list) {
            if (e is Map<String, dynamic>) {
              _ongoingOrders.add(OrderItem.fromJson(e));
            }
          }
        }
      }
      if (completedJson != null) {
        final list = jsonDecode(completedJson) as List<dynamic>?;
        if (list != null) {
          _completedOrders.clear();
          for (final e in list) {
            if (e is Map<String, dynamic>) {
              _completedOrders.add(OrderItem.fromJson(e));
            }
          }
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _keyOngoing,
        jsonEncode(_ongoingOrders.map((o) => o.toJson()).toList()),
      );
      await prefs.setString(
        _keyCompleted,
        jsonEncode(_completedOrders.map((o) => o.toJson()).toList()),
      );
    } catch (_) {}
  }

  void addOngoingOrder(List<CartItem> items, String address) {
    final date = _formatDate(DateTime.now());
    for (final item in items) {
      for (var i = 0; i < item.quantity; i++) {
        _ongoingOrders.add(OrderItem(
          productName: item.name,
          imagePath: item.imagePath,
          price: '\$ ${item.price.toStringAsFixed(2)}',
          address: address,
          date: date,
        ));
      }
    }
    notifyListeners();
    _saveToStorage();
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
