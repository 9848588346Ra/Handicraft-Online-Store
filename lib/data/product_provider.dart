import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:handicraft_online_store/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _keyProducts = 'admin_products';

/// Manages products for admin add/edit/remove. Persists to SharedPreferences.
class ProductProvider extends ChangeNotifier {
  ProductProvider._() {
    _load();
  }
  static final ProductProvider _instance = ProductProvider._();
  static ProductProvider get instance => _instance;

  final List<ProductModel> _products = [];
  List<ProductModel> get products => List.unmodifiable(_products);

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_keyProducts);
      if (json != null) {
        final list = jsonDecode(json) as List<dynamic>?;
        _products.clear();
        if (list != null) {
          for (final e in list) {
            if (e is Map<String, dynamic>) {
              _products.add(ProductModel.fromJson(e));
            }
          }
        }
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _keyProducts,
        jsonEncode(_products.map((p) => p.toJson()).toList()),
      );
      notifyListeners();
    } catch (_) {}
  }

  Future<void> addProduct(ProductModel product) async {
    final id = product.id.isEmpty ? DateTime.now().millisecondsSinceEpoch.toString() : product.id;
    _products.add(product.copyWith(id: id));
    await _save();
  }

  Future<void> updateProduct(ProductModel product) async {
    final i = _products.indexWhere((p) => p.id == product.id);
    if (i >= 0) {
      _products[i] = product;
      await _save();
    }
  }

  Future<void> removeProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    await _save();
  }

  ProductModel? getProduct(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
