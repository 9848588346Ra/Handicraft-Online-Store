import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/delivery_address.dart';

const String _keyPrefix = 'delivery_addresses_';

String _storageKey(String userEmail) =>
    '$_keyPrefix${userEmail.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}';

/// Manages user's saved delivery addresses (home, work, study). Stored per user email.
class DeliveryAddressProvider extends ChangeNotifier {
  DeliveryAddressProvider._();
  static final DeliveryAddressProvider _instance = DeliveryAddressProvider._();
  static DeliveryAddressProvider get instance => _instance;

  List<DeliveryAddress> _addresses = [];
  List<DeliveryAddress> get addresses => List.unmodifiable(_addresses);

  Future<void> load(String userEmail) async {
    if (userEmail.isEmpty) {
      _addresses = [];
      _currentUserEmail = null;
      notifyListeners();
      return;
    }
    _currentUserEmail = userEmail;
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_storageKey(userEmail));
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

  String? _currentUserEmail;

  Future<void> add(DeliveryAddress address, String userEmail) async {
    if (userEmail.isEmpty) return;
    _currentUserEmail = userEmail;
    final id = address.id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : address.id;
    final newAddr = address.copyWith(id: id);
    _addresses.add(newAddr);
    notifyListeners();
    await _save();
  }

  Future<void> update(DeliveryAddress address, String userEmail) async {
    if (userEmail.isEmpty) return;
    _currentUserEmail = userEmail;
    final i = _addresses.indexWhere((a) => a.id == address.id);
    if (i >= 0) {
      _addresses[i] = address;
      notifyListeners();
      await _save();
    }
  }

  Future<void> remove(String id, String userEmail) async {
    if (userEmail.isEmpty) return;
    _currentUserEmail = userEmail;
    _addresses.removeWhere((a) => a.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final email = _currentUserEmail;
    if (email == null || email.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey(email),
        jsonEncode(_addresses.map((a) => a.toJson()).toList()),
      );
    } catch (_) {}
  }

  void clear() {
    _addresses = [];
    notifyListeners();
  }
}
