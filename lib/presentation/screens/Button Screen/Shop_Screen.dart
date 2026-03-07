import 'package:flutter/material.dart';
import 'category_products_screen.dart';
import 'product_detail_screen.dart';

// Design colors matching the reference - clean, professional look
const Color _primaryPurple = Color(0xFF5E35B1);
const Color _lightBlue = Color(0xFFE3F2FD);

double _parsePrice(String priceStr) {
  final match = RegExp(r'[\d.]+').firstMatch(priceStr);
  return match != null ? double.tryParse(match.group(0) ?? '0') ?? 0 : 0;
}

class ProductData {
  final String title;
  final String price;
  final String imagePath;
  final String? description;

  ProductData({
    required this.title,
    required this.price,
    required this.imagePath,
    this.description,
  });
}

class ShopScreen extends StatefulWidget {
  final void Function(
    BuildContext context,
    String title,
    String imagePath,
    double price,
  )? onAddToCart;

  const ShopScreen({super.key, this.onAddToCart});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _PromoSlide {
  final String title;
  final String subtitle;
  final Color titleColor;
  final List<Color> gradientColors;
  final IconData topRightIcon;
  final Color topRightIconColor;
  final IconData bottomLeftIcon;
  final Color bottomLeftIconColor;
  final IconData bottomRightIcon;
  final Color bottomRightIconColor;

  _PromoSlide({
    required this.title,
    required this.subtitle,
    required this.titleColor,
    required this.gradientColors,
    required this.topRightIcon,
    required this.topRightIconColor,
    required this.bottomLeftIcon,
    required this.bottomLeftIconColor,
    required this.bottomRightIcon,
    required this.bottomRightIconColor,
  });
}

class _PromoBannerCard extends StatelessWidget {
  final _PromoSlide slide;

  const _PromoBannerCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: slide.gradientColors,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: 20,
              top: 12,
              child: Icon(
                slide.topRightIcon,
                size: 40,
                color: slide.topRightIconColor,
              ),
            ),
            Positioned(
              right: 55,
              bottom: 16,
              child: Icon(
                slide.bottomRightIcon,
                size: 24,
                color: slide.bottomRightIconColor,
              ),
            ),
            Positioned(
              left: 20,
              bottom: 12,
              child: Icon(
                slide.bottomLeftIcon,
                size: 32,
                color: slide.bottomLeftIconColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slide.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: slide.titleColor,
                      fontFamily: 'open sans bold',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slide.subtitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _primaryPurple,
                      fontFamily: 'open sans bold',
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

class _ShopScreenState extends State<ShopScreen> {
  int _bannerIndex = 0;
  late PageController _bannerController;

  static final List<_PromoSlide> _promoSlides = [
    _PromoSlide(
      title: 'Christmas Offer',
      subtitle: 'Get Up To 40% OFF',
      titleColor: Color(0xFF2E7D32),
      gradientColors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9), Color(0xFFE3F2FD)],
      topRightIcon: Icons.card_giftcard,
      topRightIconColor: Color(0xFFE57373),
      bottomLeftIcon: Icons.forest,
      bottomLeftIconColor: Color(0xFF66BB6A),
      bottomRightIcon: Icons.ac_unit,
      bottomRightIconColor: Color(0xFF90CAF9),
    ),
    _PromoSlide(
      title: 'Handcrafted Sale',
      subtitle: 'Up To 30% OFF',
      titleColor: Color(0xFF5E35B1),
      gradientColors: [Color(0xFFEDE7F6), Color(0xFFF3E5F5), Color(0xFFE8EAF6)],
      topRightIcon: Icons.workspace_premium,
      topRightIconColor: Color(0xFF7E57C2),
      bottomLeftIcon: Icons.handyman,
      bottomLeftIconColor: Color(0xFF9575CD),
      bottomRightIcon: Icons.star,
      bottomRightIconColor: Color(0xFFB39DDB),
    ),
    _PromoSlide(
      title: 'New Arrivals',
      subtitle: 'Fresh Handmade Items',
      titleColor: Color(0xFF00838F),
      gradientColors: [Color(0xFFE0F7FA), Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
      topRightIcon: Icons.new_releases,
      topRightIconColor: Color(0xFF26C6DA),
      bottomLeftIcon: Icons.inventory_2,
      bottomLeftIconColor: Color(0xFF4DD0E1),
      bottomRightIcon: Icons.shopping_bag,
      bottomRightIconColor: Color(0xFF80DEEA),
    ),
    _PromoSlide(
      title: 'Free Shipping',
      subtitle: 'On Orders Over \$50',
      titleColor: Color(0xFF1565C0),
      gradientColors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)],
      topRightIcon: Icons.local_shipping,
      topRightIconColor: Color(0xFF1976D2),
      bottomLeftIcon: Icons.delivery_dining,
      bottomLeftIconColor: Color(0xFF42A5F5),
      bottomRightIcon: Icons.shopping_cart,
      bottomRightIconColor: Color(0xFF64B5F6),
    ),
    _PromoSlide(
      title: 'Limited Time Deal',
      subtitle: '25% OFF Selected Items',
      titleColor: Color(0xFFC62828),
      gradientColors: [Color(0xFFFFEBEE), Color(0xFFFFCDD2), Color(0xFFF8BBD9)],
      topRightIcon: Icons.timer,
      topRightIconColor: Color(0xFFE53935),
      bottomLeftIcon: Icons.discount,
      bottomLeftIconColor: Color(0xFFEF5350),
      bottomRightIcon: Icons.local_offer,
      bottomRightIconColor: Color(0xFFF48FB1),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.88);
    _bannerController.addListener(_onBannerPageChanged);
  }

  void _onBannerPageChanged() {
    final page = _bannerController.page;
    if (page != null) {
      final index = (page.round()).clamp(0, _promoSlides.length - 1);
      if (index != _bannerIndex && mounted) {
        setState(() => _bannerIndex = index);
      }
    }
  }

  @override
  void dispose() {
    _bannerController.removeListener(_onBannerPageChanged);
    _bannerController.dispose();
    super.dispose();
  }

  static final List<ProductData> _exclusiveProducts = [
    ProductData(
      title: 'Felt Dogs',
      price: '\$ 10',
      imagePath: 'assets/images/Dog.jpeg',
    ),
    ProductData(
      title: 'Felt Cats',
      price: '\$ 20',
      imagePath: 'assets/images/Cats.jpeg',
    ),
    ProductData(
      title: 'Handmade Balls',
      price: '\$ 15',
      imagePath: 'assets/images/balls.webp',
    ),
    ProductData(
      title: 'Coasters',
      price: '\$ 12',
      imagePath: 'assets/images/coasters.webp',
    ),
  ];

  static final List<ProductData> _bestSellingProducts = [
    ProductData(
      title: 'Felt Christmas Man',
      price: '\$ 20',
      imagePath: 'assets/images/TreeHanging.jpeg',
      description:
          'Handcrafted Decorative Christmas Man For Decorating Christmas Tree.',
    ),
    ProductData(
      title: 'Christmas Ornaments',
      price: '\$ 8',
      imagePath: 'assets/images/Christmas Ornaments.png',
    ),
    ProductData(
      title: 'Snowman',
      price: '\$ 12',
      imagePath: 'assets/images/Snowman.jpeg',
    ),
    ProductData(
      title: 'Tree Hanging',
      price: '\$ 25',
      imagePath: 'assets/images/TreeHanging.jpeg',
    ),
    ProductData(
      title: 'Bird Decoration',
      price: '\$ 18',
      imagePath: 'assets/images/Bird.jpeg',
    ),
  ];

  static final List<ProductData> _newArrivalsProducts = [
    ProductData(
      title: 'Leaf Purse',
      price: '\$ 22',
      imagePath: 'assets/images/leaf purse.webp',
    ),
    ProductData(
      title: 'Handcrafted Hat',
      price: '\$ 18',
      imagePath: 'assets/images/hat.webp',
    ),
    ProductData(
      title: 'Woven Rugs',
      price: '\$ 45',
      imagePath: 'assets/images/rugs.webp',
    ),
    ProductData(
      title: 'Felt Shoes',
      price: '\$ 28',
      imagePath: 'assets/images/shoes.webp',
    ),
    ProductData(
      title: 'Pattern Coasters',
      price: '\$ 14',
      imagePath: 'assets/images/Squarecoasters.jpeg',
    ),
  ];

  static final List<ProductData> _handcraftedProducts = [
    ProductData(
      title: 'Angel Figurine',
      price: '\$ 15',
      imagePath: 'assets/images/Angel.webp',
    ),
    ProductData(
      title: 'Owl Purse',
      price: '\$ 24',
      imagePath: 'assets/images/owlpurse.jpg',
    ),
    ProductData(
      title: '4 Angels Set',
      price: '\$ 32',
      imagePath: 'assets/images/4angels.webp',
    ),
    ProductData(
      title: 'Decorative Patterns',
      price: '\$ 16',
      imagePath: 'assets/images/patterns.avif',
    ),
  ];

  static final List<ProductData> _feltToysProducts = [
    ProductData(
      title: 'Felt Dogs',
      price: '\$ 10',
      imagePath: 'assets/images/Dog.jpeg',
    ),
    ProductData(
      title: 'Felt Cats',
      price: '\$ 20',
      imagePath: 'assets/images/Cats.jpeg',
    ),
    ProductData(
      title: 'Handmade Balls',
      price: '\$ 15',
      imagePath: 'assets/images/balls.webp',
    ),
    ProductData(
      title: 'Bird Decoration',
      price: '\$ 18',
      imagePath: 'assets/images/Bird.jpeg',
    ),
    ProductData(
      title: 'Owl Purse',
      price: '\$ 24',
      imagePath: 'assets/images/owlpurse.jpg',
    ),
    ProductData(
      title: '4 Angels Set',
      price: '\$ 32',
      imagePath: 'assets/images/4angels.webp',
    ),
    ProductData(
      title: 'Felt Christmas Man',
      price: '\$ 20',
      imagePath: 'assets/images/TreeHanging.jpeg',
      description:
          'Handcrafted Decorative Christmas Man For Decorating Christmas Tree.',
    ),
    ProductData(
      title: 'Snowman',
      price: '\$ 12',
      imagePath: 'assets/images/Snowman.jpeg',
    ),
  ];

  static final List<ProductData> _decorationsProducts = [
    ProductData(
      title: 'Felt Christmas Man',
      price: '\$ 20',
      imagePath: 'assets/images/TreeHanging.jpeg',
      description:
          'Handcrafted Decorative Christmas Man For Decorating Christmas Tree.',
    ),
    ProductData(
      title: 'Christmas Ornaments',
      price: '\$ 8',
      imagePath: 'assets/images/Christmas Ornaments.png',
    ),
    ProductData(
      title: 'Snowman',
      price: '\$ 12',
      imagePath: 'assets/images/Snowman.jpeg',
    ),
    ProductData(
      title: 'Tree Hanging',
      price: '\$ 25',
      imagePath: 'assets/images/TreeHanging.jpeg',
    ),
    ProductData(
      title: 'Bird Decoration',
      price: '\$ 18',
      imagePath: 'assets/images/Bird.jpeg',
    ),
    ProductData(
      title: 'Angel Figurine',
      price: '\$ 15',
      imagePath: 'assets/images/Angel.webp',
    ),
    ProductData(
      title: 'Decorative Patterns',
      price: '\$ 16',
      imagePath: 'assets/images/patterns.avif',
    ),
  ];

  static final List<ProductData> _homeDecorProducts = [
    ProductData(
      title: 'Woven Rugs',
      price: '\$ 45',
      imagePath: 'assets/images/rugs.webp',
    ),
    ProductData(
      title: 'Coasters',
      price: '\$ 12',
      imagePath: 'assets/images/coasters.webp',
    ),
    ProductData(
      title: 'Pattern Coasters',
      price: '\$ 14',
      imagePath: 'assets/images/Squarecoasters.jpeg',
    ),
    ProductData(
      title: 'Felt Christmas Man',
      price: '\$ 20',
      imagePath: 'assets/images/TreeHanging.jpeg',
      description:
          'Handcrafted Decorative Christmas Man For Decorating Christmas Tree.',
    ),
    ProductData(
      title: 'Snowman',
      price: '\$ 12',
      imagePath: 'assets/images/Snowman.jpeg',
    ),
  ];

  static final List<ProductData> _accessoriesProducts = [
    ProductData(
      title: 'Leaf Purse',
      price: '\$ 22',
      imagePath: 'assets/images/leaf purse.webp',
    ),
    ProductData(
      title: 'Handcrafted Hat',
      price: '\$ 18',
      imagePath: 'assets/images/hat.webp',
    ),
    ProductData(
      title: 'Felt Shoes',
      price: '\$ 28',
      imagePath: 'assets/images/shoes.webp',
    ),
    ProductData(
      title: 'Owl Purse',
      price: '\$ 24',
      imagePath: 'assets/images/owlpurse.jpg',
    ),
    ProductData(
      title: 'Coasters',
      price: '\$ 12',
      imagePath: 'assets/images/coasters.webp',
    ),
  ];

  void _navigateToCategory(
    BuildContext context,
    String title,
    List<ProductData> products,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProductsScreen(
          categoryTitle: title,
          products: products,
          onAddToCart: widget.onAddToCart,
        ),
      ),
    );
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
            const SizedBox(height: 16),
            _buildPromoBanner(),
            const SizedBox(height: 8),
            _buildCarouselDots(),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(
                      'Exclusive Offer',
                      onSeeAll: () => _navigateToCategory(
                        context,
                        'Exclusive Offer',
                        _exclusiveProducts,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildExclusiveOffers(),
                    const SizedBox(height: 28),
                    _sectionHeader(
                      'Best Selling',
                      onSeeAll: () => _navigateToCategory(
                        context,
                        'Best Selling',
                        _bestSellingProducts,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBestSelling(),
                    const SizedBox(height: 28),
                    _sectionHeader(
                      'New Arrivals',
                      onSeeAll: () => _navigateToCategory(
                        context,
                        'New Arrivals',
                        _newArrivalsProducts,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildNewArrivals(),
                    const SizedBox(height: 28),
                    _buildShopByCategory(),
                    const SizedBox(height: 28),
                    _sectionHeader(
                      'Handcrafted Favorites',
                      onSeeAll: () => _navigateToCategory(
                        context,
                        'Handcrafted Favorites',
                        _handcraftedProducts,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildHandcraftedFavorites(),
                    const SizedBox(height: 28),
                    _buildWhyShopWithUs(),
                    const SizedBox(height: 24),
                  ],
                ),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.store, color: _primaryPurple, size: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HANDICRAFT',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'open sans bold',
                    color: Color(0xFF3D5AFE),
                  ),
                ),
                Text(
                  'ONLINE STORE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return SizedBox(
      height: 140,
      child: PageView.builder(
        controller: _bannerController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(),
        itemCount: _promoSlides.length,
        itemBuilder: (context, index) {
          final slide = _promoSlides[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _PromoBannerCard(slide: slide),
          );
        },
      ),
    );
  }

  Widget _buildCarouselDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_promoSlides.length, (index) {
        final isActive = index == _bannerIndex;
        return GestureDetector(
          onTap: () {
            _bannerController.animateToPage(
              index,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            width: isActive ? 20 : 6,
            decoration: BoxDecoration(
              color: isActive ? _primaryPurple : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }

  Widget _sectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'open sans bold',
              color: Colors.black87,
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              'See all',
              style: TextStyle(
                fontSize: 15,
                color: _primaryPurple.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExclusiveOffers() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (int i = 0; i < _exclusiveProducts.length; i++) ...[
            if (i > 0) const SizedBox(width: 14),
            _ProductCard(
              title: _exclusiveProducts[i].title,
              price: _exclusiveProducts[i].price,
              imagePath: _exclusiveProducts[i].imagePath,
              onAddToCart: widget.onAddToCart,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBestSelling() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (int i = 0; i < _bestSellingProducts.length; i++) ...[
            if (i > 0) const SizedBox(width: 14),
            _ProductCard(
              title: _bestSellingProducts[i].title,
              price: _bestSellingProducts[i].price,
              imagePath: _bestSellingProducts[i].imagePath,
              description: _bestSellingProducts[i].description,
              onAddToCart: widget.onAddToCart,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNewArrivals() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (int i = 0; i < _newArrivalsProducts.length; i++) ...[
            if (i > 0) const SizedBox(width: 14),
            _ProductCard(
              title: _newArrivalsProducts[i].title,
              price: _newArrivalsProducts[i].price,
              imagePath: _newArrivalsProducts[i].imagePath,
              onAddToCart: widget.onAddToCart,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShopByCategory() {
    final categories = [
      _CategoryItem(
        'Felt Toys',
        Icons.toys_outlined,
        _primaryPurple,
        _feltToysProducts,
      ),
      _CategoryItem(
        'Decorations',
        Icons.emoji_events_outlined,
        Colors.orange.shade700,
        _decorationsProducts,
      ),
      _CategoryItem(
        'Home Decor',
        Icons.home_outlined,
        Colors.teal.shade600,
        _homeDecorProducts,
      ),
      _CategoryItem(
        'Accessories',
        Icons.checkroom_outlined,
        Colors.pink.shade600,
        _accessoriesProducts,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shop by Category',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'open sans bold',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
            children: categories
                .map(
                  (c) => _CategoryCard(
                    label: c.label,
                    icon: c.icon,
                    color: c.color,
                    onTap: () =>
                        _navigateToCategory(context, c.label, c.products),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHandcraftedFavorites() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          for (int i = 0; i < _handcraftedProducts.length; i++) ...[
            if (i > 0) const SizedBox(width: 14),
            _ProductCard(
              title: _handcraftedProducts[i].title,
              price: _handcraftedProducts[i].price,
              imagePath: _handcraftedProducts[i].imagePath,
              onAddToCart: widget.onAddToCart,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWhyShopWithUs() {
    final features = [
      _FeatureItem(
        Icons.local_shipping_outlined,
        'Free Shipping',
        'On orders over \$50',
      ),
      _FeatureItem(Icons.verified_outlined, 'Handmade', '100% artisan crafted'),
      _FeatureItem(
        Icons.workspace_premium_outlined,
        'Quality',
        'Premium materials',
      ),
      _FeatureItem(
        Icons.support_agent_outlined,
        'Support',
        '24/7 customer care',
      ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_primaryPurple.withOpacity(0.08), _lightBlue],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Shop With Us',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'open sans bold',
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _FeatureTile(features[0])),
              Expanded(child: _FeatureTile(features[1])),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _FeatureTile(features[2])),
              Expanded(child: _FeatureTile(features[3])),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String label;
  final IconData icon;
  final Color color;
  final List<ProductData> products;

  _CategoryItem(this.label, this.icon, this.color, this.products);
}

class _CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _CategoryCard({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;

  _FeatureItem(this.icon, this.title, this.subtitle);
}

class _FeatureTile extends StatelessWidget {
  final _FeatureItem item;

  const _FeatureTile(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryPurple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 20, color: _primaryPurple),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;
  final String? description;
  final void Function(
    BuildContext context,
    String title,
    String imagePath,
    double price,
  )?
  onAddToCart;

  const _ProductCard({
    required this.title,
    required this.price,
    required this.imagePath,
    this.description,
    this.onAddToCart,
  });

  void _openProductDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          productName: title,
          imagePath: imagePath,
          price: price,
          description: description,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openProductDetail(context),
      child: Container(
        width: 150,
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'open sans bold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _primaryPurple,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (onAddToCart != null) {
                            onAddToCart!(
                              context,
                              title,
                              imagePath,
                              _parsePrice(price),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _primaryPurple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: _primaryPurple,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '4.5',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _primaryPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.add_shopping_cart,
                  color: _primaryPurple,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
