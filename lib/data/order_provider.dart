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

  List<OrderItem> getOngoingOrdersForUser(String userEmail) {
    if (userEmail.isEmpty) return [];
    return _ongoingOrders.where((o) => o.userEmail == userEmail).toList();
  }

  List<OrderItem> getCompletedOrdersForUser(String userEmail) {
    if (userEmail.isEmpty) return [];
    return _completedOrders.where((o) => o.userEmail == userEmail).toList();
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ongoingJson = prefs.getString(_keyOngoing);
      final completedJson = prefs.getString(_keyCompleted);
      if (ongoingJson != null) {
        final list = jsonDecode(ongoingJson) as List<dynamic>?;
        if (list != null) {
          _ongoingOrders.clear();
          final Map<String, String> dateAddressToOrderId = {};
          for (final e in list) {
            if (e is Map) {
              final item = OrderItem.fromJson(Map<String, dynamic>.from(e));
              String orderId = item.orderId;
              if (orderId.isEmpty) {
                final key = '${item.date}|${item.address}';
                orderId = dateAddressToOrderId.putIfAbsent(key, () => 'legacy_${DateTime.now().millisecondsSinceEpoch}_${dateAddressToOrderId.length}');
                _ongoingOrders.add(item.copyWith(orderId: orderId));
              } else {
                _ongoingOrders.add(item);
              }
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

  void addOngoingOrder(List<CartItem> items, String address, {String userEmail = ''}) {
    final date = _formatDate(DateTime.now());
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    for (final item in items) {
      for (var i = 0; i < item.quantity; i++) {
        _ongoingOrders.add(OrderItem(
          orderId: orderId,
          productName: item.name,
          imagePath: item.imagePath,
          price: '\$ ${item.price.toStringAsFixed(2)}',
          address: address,
          date: date,
          userEmail: userEmail,
        ));
      }
    }
    notifyListeners();
    _saveToStorage();
  }

  void updateOrderAddress(String orderId, String newAddress) {
    var updated = false;
    for (var i = 0; i < _ongoingOrders.length; i++) {
      if (_ongoingOrders[i].orderId == orderId) {
        _ongoingOrders[i] = _ongoingOrders[i].copyWith(address: newAddress);
        updated = true;
      }
    }
    if (updated) {
      notifyListeners();
      _saveToStorage();
    }
  }

  void removeOrder(String orderId) {
    _ongoingOrders.removeWhere((o) => o.orderId == orderId);
    notifyListeners();
    _saveToStorage();
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
