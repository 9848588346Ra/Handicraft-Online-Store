import 'package:flutter/material.dart';
import 'package:handicraft_online_store/data/cart_provider.dart';
import 'package:handicraft_online_store/data/models/cart_item.dart';

const Color _primaryPurple = Color(0xFF5E35B1);

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    this.description,
    this.onAddToCart,
  });

  final String title;
  final String price;
  final String imagePath;
  final String? description;
  final void Function(BuildContext context, String title, String imagePath, double price)? onAddToCart;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isFavorite = false;
  bool _detailExpanded = true;

  static double _parsePrice(String price) {
    final match = RegExp(r'[\d.]+').firstMatch(price);
    if (match != null) return double.tryParse(match.group(0) ?? '0') ?? 0;
    return 0;
  }

  void _addToCart() {
    final price = _parsePrice(widget.price);
    final item = CartItem(widget.title, widget.imagePath, price, _quantity);
    CartProvider.instance.addItem(item);
    if (widget.onAddToCart != null) {
      widget.onAddToCart!(context, widget.title, widget.imagePath, price);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.title} (x$_quantity) added to cart'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desc = widget.description ?? 'Handcrafted with care. Premium quality materials.';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Detail',
          style: TextStyle(fontFamily: 'open sans bold', fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: _primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            onPressed: () => setState(() => _isFavorite = !_isFavorite),
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 280,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Image.asset(
                widget.imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 64),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'open sans bold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1pcs, Price',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _qtyButton(() => setState(() => _quantity = (_quantity - 1).clamp(1, 99)), Icons.remove),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                      _qtyButton(() => setState(() => _quantity = (_quantity + 1).clamp(1, 99)), Icons.add),
                      const Spacer(),
                      Text(
                        widget.price,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _primaryPurple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildDetailSection(desc),
                  const SizedBox(height: 24),
                  _buildReviewSection(),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _addToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'open sans bold'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(VoidCallback onTap, IconData icon) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildDetailSection(String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _detailExpanded = !_detailExpanded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Product Detail',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'open sans bold'),
              ),
              Icon(
                _detailExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 24,
              ),
            ],
          ),
        ),
        if (_detailExpanded) ...[
          const SizedBox(height: 12),
          Text(
            desc,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
          ),
        ],
      ],
    );
  }

  Widget _buildReviewSection() {
    return Row(
      children: [
        const Text('Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        ...List.generate(5, (i) => Icon(Icons.star, size: 20, color: Colors.orange.shade400)),
        const SizedBox(width: 8),
        Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade600),
      ],
    );
  }
}
