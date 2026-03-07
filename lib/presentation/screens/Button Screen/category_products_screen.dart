import 'package:flutter/material.dart';
import 'package:handicraft_online_store/data/cart_provider.dart';
import 'package:handicraft_online_store/data/models/cart_item.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/product_detail_screen.dart';

const Color _primaryPurple = Color(0xFF5E35B1);

class ProductData {
  final String title;
  final String price;
  final String imagePath;
  final String? description;
  ProductData(this.title, this.price, this.imagePath, [this.description]);
}

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({
    super.key,
    required this.title,
    required this.products,
    this.icon,
    this.onAddToCart,
  });

  final String title;
  final List<ProductData> products;
  final IconData? icon;
  final void Function(BuildContext context, String title, String imagePath, double price)? onAddToCart;

  static double _parsePrice(String price) {
    final match = RegExp(r'[\d.]+').firstMatch(price);
    if (match != null) return double.tryParse(match.group(0) ?? '0') ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'open sans bold', fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: _primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No products',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '${products.length} products',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      return _ProductCard(
                        title: p.title,
                        price: p.price,
                        imagePath: p.imagePath,
                        description: p.description,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              title: p.title,
                              price: p.price,
                              imagePath: p.imagePath,
                              description: p.description,
                              onAddToCart: onAddToCart,
                            ),
                          ),
                        ),
                        onAddToCart: onAddToCart != null
                            ? () {
                                final price = _parsePrice(p.price);
                                CartProvider.instance.addItem(CartItem(p.title, p.imagePath, price, 1));
                                onAddToCart!(context, p.title, p.imagePath, price);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${p.title} added to cart'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(milliseconds: 500),
                                  ),
                                );
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.title,
    required this.price,
    required this.imagePath,
    this.description,
    required this.onTap,
    this.onAddToCart,
  });

  final String title;
  final String price;
  final String imagePath;
  final String? description;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'open sans bold'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryPurple),
                      ),
                      if (onAddToCart != null)
                        GestureDetector(
                          onTap: onAddToCart,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: _primaryPurple,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
