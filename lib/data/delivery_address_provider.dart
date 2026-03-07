import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/delivery_address.dart';

const String _keyDeliveryAddresses = 'delivery_addresses';

/// Manages user's saved delivery addresses (home, work, study).
class DeliveryAddressProvider extends ChangeNotifier {
  DeliveryAddressProvider._();
  static final DeliveryAddressProvider _instance = DeliveryAddressProvider._();
  static DeliveryAddressProvider get instance => _instance;

  List<DeliveryAddress> _addresses = [];
  List<DeliveryAddress> get addresses => List.unmodifiable(_addresses);

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_keyDeliveryAddresses);
      if (json != null) {
        final list = jsonDecode(json) as List<dynamic>?;
        _addresses = (list ?? [])
            .map((e) => DeliveryAddress.fromJson(Map<String, dynamic>.from(e as Map)))
            .where((a) => a.id.isNotEmpty)
            .toList();
      } else {
        _addresses = [];
      }
      notifyListeners();
    } catch (_) {
      _addresses = [];
      notifyListeners();
    }
  }

  Future<void> add(DeliveryAddress address) async {
    final id = address.id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : address.id;
    final newAddr = address.copyWith(id: id);
    _addresses.add(newAddr);
    notifyListeners();
    await _save();
  }

  Future<void> update(DeliveryAddress address) async {
    final i = _addresses.indexWhere((a) => a.id == address.id);
    if (i >= 0) {
      _addresses[i] = address;
      notifyListeners();
      await _save();
    }
  }

  Future<void> remove(String id) async {
    _addresses.removeWhere((a) => a.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _keyDeliveryAddresses,
        jsonEncode(_addresses.map((a) => a.toJson()).toList()),
      );
    } catch (_) {}
  }

  void clear() {
    _addresses = [];
    notifyListeners();
  }
}
