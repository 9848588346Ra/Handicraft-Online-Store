import 'package:flutter/material.dart';
import 'package:handicraft_online_store/data/product_provider.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/category_products_screen.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/product_detail_screen.dart';
import 'package:handicraft_online_store/presentation/widgets/product_image.dart';

const Color _primaryPurple = Color(0xFF5E35B1);
const Color _lightBlue = Color.fromARGB(255, 253, 254, 255);

class ShopScreen extends StatefulWidget {
  const ShopScreen({
    super.key,
    this.onAddToCart,
  });

  final void Function(BuildContext context, String title, String imagePath, double price)? onAddToCart;

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final PageController _bannerController = PageController(viewportFraction: 0.88);
  int _bannerIndex = 0;

  static const List<_Product> _exclusiveOffer = [
    _Product('Felt Dogs', '\$10', 'assets/images/imageh2.webp'),
    _Product('Felt Cats', '\$20', 'assets/images/imageh3.webp'),
    _Product('Handmade Balls', '\$15', 'assets/images/imageh4.webp'),
    _Product('Coasters', '\$8', 'assets/images/imageh5.webp'),
  ];

  static const List<_Product> _bestSelling = [
    _Product('Felt Christmas Man', '\$20', 'assets/images/imageh6.avif'),
    _Product('Christmas Ornaments', '\$12', 'assets/images/imageh5.webp'),
    _Product('Snowman', '\$15', 'assets/images/imageh7.jpg'),
    _Product('Tree Hanging', '\$10', 'assets/images/imageh2.webp'),
    _Product('Bird Decoration', '\$18', 'assets/images/imageh3.webp'),
  ];

  static const List<_Product> _newArrivals = [
    _Product('Leaf Purse', '\$22', 'assets/images/imageh4.webp'),
    _Product('Handcrafted Hat', '\$18', 'assets/images/imageh5.webp'),
    _Product('Woven Rugs', '\$45', 'assets/images/imageh6.avif'),
    _Product('Felt Shoes', '\$28', 'assets/images/imageh7.jpg'),
    _Product('Pattern Coasters', '\$14', 'assets/images/imageh2.webp'),
  ];

  static const List<_Product> _handcraftedFavorites = [
    _Product('Angel Figurine', '\$15', 'assets/images/imageh3.webp'),
    _Product('Owl Purse', '\$24', 'assets/images/imageh4.webp'),
    _Product('4 Angels Set', '\$32', 'assets/images/imageh5.webp'),
    _Product('Decorative Patterns', '\$16', 'assets/images/imageh6.avif'),
  ];

  static final List<_CategoryItem> _categories = [
    _CategoryItem('Felt Toys', Icons.toys, [
      ProductData('Felt Dogs', '\$10', 'assets/images/imageh2.webp'),
      ProductData('Felt Cats', '\$20', 'assets/images/imageh3.webp'),
      ProductData('Handmade Balls', '\$15', 'assets/images/imageh4.webp'),
      ProductData('Bird Decoration', '\$18', 'assets/images/imageh3.webp'),
    ]),
    _CategoryItem('Decorations', Icons.celebration, [
      ProductData('Felt Christmas Man', '\$20', 'assets/images/imageh6.avif'),
      ProductData('Christmas Ornaments', '\$12', 'assets/images/imageh5.webp'),
      ProductData('Snowman', '\$15', 'assets/images/imageh7.jpg'),
    ]),
    _CategoryItem('Home Decor', Icons.home, [
      ProductData('Woven Rugs', '\$45', 'assets/images/imageh6.avif'),
      ProductData('Coasters', '\$8', 'assets/images/imageh5.webp'),
      ProductData('Pattern Coasters', '\$14', 'assets/images/imageh2.webp'),
    ]),
    _CategoryItem('Accessories', Icons.checkroom, [
      ProductData('Leaf Purse', '\$22', 'assets/images/imageh4.webp'),
      ProductData('Handcrafted Hat', '\$18', 'assets/images/imageh5.webp'),
      ProductData('Felt Shoes', '\$28', 'assets/images/imageh7.jpg'),
    ]),
  ];

  static const List<_BannerSlide> _banners = [
    _BannerSlide('Get Up To 40% OFF', 'Christmas Offer', [Icons.card_giftcard, Icons.ac_unit, Icons.forest]),
    _BannerSlide('Up To 30% OFF', 'Handcrafted Sale', [Icons.handyman, Icons.diamond, Icons.star]),
    _BannerSlide('Fresh Handmade Items', 'New Arrivals', [Icons.inventory_2, Icons.shopping_bag, Icons.new_releases]),
    _BannerSlide('Free Shipping', 'On Orders Over \$50', [Icons.local_shipping, Icons.delivery_dining]),
    _BannerSlide('Limited Time Deal', '25% OFF Selected Items', [Icons.timer, Icons.discount]),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController.addListener(() {
      final page = _bannerController.page?.round() ?? 0;
      if (page != _bannerIndex && mounted) setState(() => _bannerIndex = page);
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
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
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBannerCarousel(),
                  _buildDots(),
                  const SizedBox(height: 20),
                  _sectionHeader(context, 'Exclusive Offer', _exclusiveOffer),
                  _buildProductRow(context, _exclusiveOffer),
                  const SizedBox(height: 30),
                  _sectionHeader(context, 'Best Selling', _bestSelling),
                  _buildProductRow(context, _bestSelling),
                  const SizedBox(height: 30),
                  _sectionHeader(context, 'New Arrivals', _newArrivals),
                  _buildProductRow(context, _newArrivals),
                  const SizedBox(height: 30),
                  _sectionHeader(context, 'Handcrafted Favorites', _handcraftedFavorites),
                  _buildProductRow(context, _handcraftedFavorites),
                  const SizedBox(height: 30),
                  ListenableBuilder(
                    listenable: ProductProvider.instance,
                    builder: (context, _) {
                      final adminProducts = ProductProvider.instance.products;
                      if (adminProducts.isEmpty) return const SizedBox.shrink();
                      final list = adminProducts.map((p) => _Product(p.title, p.price, p.imagePath)).toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionHeader(context, 'New Additions', list),
                          _buildProductRow(context, list),
                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  ),
                  _buildShopByCategory(context),
                  const SizedBox(height: 30),
                  _buildWhyShopWithUs(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: _lightBlue,
              borderRadius: BorderRadius.circular(26),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Image.asset(
                'assets/images/image 8.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.store, color: _primaryPurple, size: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HANDICRAFT',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _primaryPurple, fontFamily: 'open sans bold'),
              ),
              Text(
                'ONLINE STORE',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _primaryPurple),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: _bannerController,
        scrollDirection: Axis.horizontal,
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final b = _banners[index];
          final gradients = [
            [const Color(0xFF5E35B1), const Color(0xFF7E57C2)],
            [const Color(0xFFE65100), const Color(0xFFFF9800)],
            [const Color(0xFF00695C), const Color(0xFF26A69A)],
            [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
            [const Color(0xFFC62828), const Color(0xFFE57373)],
          ];
          final colors = gradients[index % gradients.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          b.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'open sans bold',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          b.subtitle,
                          style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9)),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: b.icons.map((i) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(i, color: Colors.white70, size: 28),
                    )).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDots() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_banners.length, (i) {
          final active = i == _bannerIndex;
          return GestureDetector(
            onTap: () => _bannerController.animateToPage(i, duration: const Duration(milliseconds: 350), curve: Curves.easeInOutCubic),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: active ? 20 : 6,
              decoration: BoxDecoration(
                color: active ? _primaryPurple : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title, List<_Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'open sans bold'),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoryProductsScreen(
                  title: title,
                  products: products.map((p) => ProductData(p.title, p.price, p.imagePath)).toList(),
                  onAddToCart: widget.onAddToCart,
                ),
              ),
            ),
            child: Text(
              'See all',
              style: TextStyle(fontSize: 16, color: _primaryPurple.withOpacity(0.8), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, List<_Product> products) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return Padding(
            padding: EdgeInsets.only(right: index < products.length - 1 ? 15 : 0),
            child: _ProductCard(
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
                  ? () => widget.onAddToCart!(context, p.title, p.imagePath, _parsePrice(p.price))
                  : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildShopByCategory(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Shop by Category',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'open sans bold'),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: _categories.map((c) => _CategoryCard(
              title: c.title,
              icon: c.icon,
              color: _categoryColor(c.title),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryProductsScreen(
                    title: c.title,
                    products: c.products,
                    icon: c.icon,
                    onAddToCart: widget.onAddToCart,
                  ),
                ),
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }

  Color _categoryColor(String title) {
    switch (title) {
      case 'Felt Toys': return _primaryPurple;
      case 'Decorations': return Colors.orange;
      case 'Home Decor': return Colors.teal;
      case 'Accessories': return Colors.pink;
      default: return _primaryPurple;
    }
  }

  Widget _buildWhyShopWithUs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryPurple.withOpacity(0.15), _primaryPurple.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          const Text(
            'Why Shop With Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'open sans bold'),
          ),
          const SizedBox(height: 20),
          _buildFeatureRow(Icons.local_shipping, 'Free Shipping', 'On orders over \$50'),
          _buildFeatureRow(Icons.handyman, 'Handmade', '100% artisan crafted'),
          _buildFeatureRow(Icons.verified, 'Quality', 'Premium materials'),
          _buildFeatureRow(Icons.support_agent, 'Support', '24/7 customer care'),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: _primaryPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: _primaryPurple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Product {
  final String title;
  final String price;
  final String imagePath;
  const _Product(this.title, this.price, this.imagePath);
}

class _BannerSlide {
  final String title;
  final String subtitle;
  final List<IconData> icons;
  const _BannerSlide(this.title, this.subtitle, this.icons);
}

class _CategoryItem {
  final String title;
  final IconData icon;
  final List<ProductData> products;
  const _CategoryItem(this.title, this.icon, this.products);
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
        width: 160,
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
                              boxShadow: [BoxShadow(color: _primaryPurple, blurRadius: 8, spreadRadius: -2)],
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

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

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
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'open sans bold'),
            ),
          ],
        ),
      ),
    );
  }
}