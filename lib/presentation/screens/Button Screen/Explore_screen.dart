import 'package:flutter/material.dart';
import 'product_detail_screen.dart';

// Consistent with Shop, Cart, Account design
const Color _primaryPurple = Color(0xFF5E35B1);

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _searchCategories = [
    'All',
    'Felt Toys',
    'Decorations',
    'Accessories',
    'Home Decor',
  ];

  final List<_CategoryItem> _allProducts = [
    _CategoryItem('Felt Dogs', 'assets/images/Dog.jpeg', '\$ 10', 'Felt Toys'),
    _CategoryItem('Felt Cats', 'assets/images/Cats.jpeg', '\$ 20', 'Felt Toys'),
    _CategoryItem(
      'Felt Snowman Ball',
      'assets/images/balls.webp',
      '\$ 12',
      'Felt Toys',
    ),
    _CategoryItem(
      'Felt Hanging',
      'assets/images/TreeHanging.jpeg',
      '\$ 18',
      'Decorations',
    ),
    _CategoryItem('Felt Bird', 'assets/images/Bird.jpeg', '\$ 14', 'Felt Toys'),
    _CategoryItem(
      'Felt Snowman',
      'assets/images/Snowman.jpeg',
      '\$ 12',
      'Decorations',
    ),
    _CategoryItem(
      'Felt Owl',
      'assets/images/owlpurse.jpg',
      '\$ 10',
      'Felt Toys',
    ),
    _CategoryItem(
      'Felt Women',
      'assets/images/4angels.webp',
      '\$ 15',
      'Felt Toys',
    ),
    _CategoryItem(
      'Angel Figurine',
      'assets/images/Angel.webp',
      '\$ 15',
      'Decorations',
    ),
    _CategoryItem(
      'Christmas Ornaments',
      'assets/images/Christmas Ornaments.png',
      '\$ 8',
      'Decorations',
    ),
    _CategoryItem(
      'Leaf Purse',
      'assets/images/leaf purse.webp',
      '\$ 22',
      'Accessories',
    ),
    _CategoryItem(
      'Handcrafted Hat',
      'assets/images/hat.webp',
      '\$ 18',
      'Accessories',
    ),
    _CategoryItem(
      'Woven Rugs',
      'assets/images/rugs.webp',
      '\$ 45',
      'Home Decor',
    ),
    _CategoryItem(
      'Felt Shoes',
      'assets/images/shoes.webp',
      '\$ 28',
      'Accessories',
    ),
    _CategoryItem(
      'Coasters',
      'assets/images/coasters.webp',
      '\$ 12',
      'Home Decor',
    ),
    _CategoryItem(
      'Square Coasters',
      'assets/images/Squarecoasters.jpeg',
      '\$ 14',
      'Home Decor',
    ),
    _CategoryItem(
      'Decorative Patterns',
      'assets/images/patterns.avif',
      '\$ 16',
      'Home Decor',
    ),
    _CategoryItem(
      'Artisan Workshop',
      'assets/images/factory.jpg',
      '\$ 35',
      'Home Decor',
    ),
  ];

  List<_CategoryItem> get _filteredProducts {
    if (_selectedCategory == 'All') return _allProducts;
    return _allProducts.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSearchByCategory(),
              const SizedBox(height: 20),
              _buildCategoryGrid(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'open sans bold',
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Discover & browse all products',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search Store',
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500, size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchByCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Search by category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'open sans bold',
              color: Colors.grey.shade800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: _searchCategories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? _primaryPurple : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? _primaryPurple
                            : Colors.grey.shade100,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'open sans bold',
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.82,
            ),
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              return _CategoryCard(item: _filteredProducts[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String label;
  final String imagePath;
  final String price;
  final String category;

  _CategoryItem(
    this.label,
    this.imagePath,
    this.price, [
    this.category = 'All',
  ]);
}

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;

  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productName: item.label,
              imagePath: item.imagePath,
              price: item.price,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  item.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey.shade100,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey.shade400,
                    ),
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
                    item.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'open sans bold',
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _primaryPurple,
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
}
