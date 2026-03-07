import 'package:flutter/material.dart';
import 'package:handicraft_online_store/data/product_provider.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/product_detail_screen.dart';
import 'package:handicraft_online_store/presentation/widgets/product_image.dart';

const Color _primaryPurple = Color(0xFF5E35B1);

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    super.key,
    this.onAddToCart,
  });

  final void Function(BuildContext context, String title, String imagePath, double price)? onAddToCart;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'All';
  final _searchController = TextEditingController();

  static const List<_ExploreProduct> _allProducts = [
    _ExploreProduct('Felt Dogs', '\$10', 'assets/images/imageh2.webp', 'Felt Toys'),
    _ExploreProduct('Felt Cats', '\$20', 'assets/images/imageh3.webp', 'Felt Toys'),
    _ExploreProduct('Felt Snowman Ball', '\$15', 'assets/images/imageh4.webp', 'Felt Toys'),
    _ExploreProduct('Felt Hanging', '\$10', 'assets/images/imageh2.webp', 'Decorations'),
    _ExploreProduct('Felt Bird', '\$18', 'assets/images/imageh3.webp', 'Decorations'),
    _ExploreProduct('Felt Snowman', '\$15', 'assets/images/imageh7.jpg', 'Decorations'),
    _ExploreProduct('Felt Owl', '\$24', 'assets/images/imageh4.webp', 'Accessories'),
    _ExploreProduct('Felt Women', '\$20', 'assets/images/imageh5.webp', 'Decorations'),
    _ExploreProduct('Angel Figurine', '\$15', 'assets/images/imageh3.webp', 'Decorations'),
    _ExploreProduct('Christmas Ornaments', '\$12', 'assets/images/imageh5.webp', 'Decorations'),
    _ExploreProduct('Leaf Purse', '\$22', 'assets/images/imageh4.webp', 'Accessories'),
    _ExploreProduct('Handcrafted Hat', '\$18', 'assets/images/imageh5.webp', 'Accessories'),
    _ExploreProduct('Woven Rugs', '\$45', 'assets/images/imageh6.avif', 'Home Decor'),
    _ExploreProduct('Felt Shoes', '\$28', 'assets/images/imageh7.jpg', 'Accessories'),
    _ExploreProduct('Coasters', '\$8', 'assets/images/imageh5.webp', 'Home Decor'),
    _ExploreProduct('Square Coasters', '\$10', 'assets/images/imageh2.webp', 'Home Decor'),
    _ExploreProduct('Decorative Patterns', '\$16', 'assets/images/imageh6.avif', 'Decorations'),
    _ExploreProduct('Artisan Workshop', '\$35', 'assets/images/imageh7.jpg', 'Home Decor'),
  ];

  static const List<String> _categories = ['All', 'Felt Toys', 'Decorations', 'Accessories', 'Home Decor'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_ExploreProduct> get _filteredProducts {
    var list = List<_ExploreProduct>.from(_allProducts);
    final adminProducts = ProductProvider.instance.products
        .map((p) => _ExploreProduct(p.title, p.price, p.imagePath, p.category))
        .toList();
    list = [...list, ...adminProducts];
    if (_selectedCategory != 'All') {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((p) => p.title.toLowerCase().contains(query)).toList();
    }
    return list;
  }

  static double _parsePrice(String price) {
    final match = RegExp(r'[\d.]+').firstMatch(price);
    if (match != null) return double.tryParse(match.group(0) ?? '0') ?? 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildCategoryChips(),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'All Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'open sans bold'),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListenableBuilder(
                listenable: ProductProvider.instance,
                builder: (context, _) => _buildProductGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.search, color: _primaryPurple, size: 26),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find Products',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'open sans bold', color: Colors.black87),
                ),
                Text('Discover & browse all products', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey.shade600, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search Store',
                  hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: _categories.map((c) {
          final selected = c == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? _primaryPurple : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: selected ? _primaryPurple : Colors.grey.shade200),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: Center(
                  child: Text(
                    c,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductGrid() {
    final products = _filteredProducts;
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                title: p.title,
                price: p.price,
                imagePath: p.imagePath,
                onAddToCart: widget.onAddToCart,
              ),
            ),
          ),
          onAddToCart: widget.onAddToCart != null
              ? () {
                  final price = _parsePrice(p.price);
                  widget.onAddToCart!(context, p.title, p.imagePath, price);
                }
              : null,
        );
      },
    );
  }
}

class _ExploreProduct {
  final String title;
  final String price;
  final String imagePath;
  final String category;
  const _ExploreProduct(this.title, this.price, this.imagePath, this.category);
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.title,
    required this.price,
    required this.imagePath,
    required this.onTap,
    this.onAddToCart,
  });

  final String title;
  final String price;
  final String imagePath;
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
              child: ProductImage(
                imagePath: imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                  const SizedBox(height: 4),
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
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: _primaryPurple,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 18),
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
