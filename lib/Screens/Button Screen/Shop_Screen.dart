import 'package:flutter/material.dart';

const Color primaryPurple = Color(0xFF5E35B1);
const Color customRed = Color(0xFFE53935);
const Color lightBlue = Color.fromARGB(255, 253, 254, 255);

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ================= APP BAR =================
appBar: AppBar(
  centerTitle: true,
  automaticallyImplyLeading: false,
  title: Column(
    children: [
      Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/image 8.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 4),
      const Text(
        'HANDICRAFT ONLINE STORE',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: primaryPurple,
        ),
      ),
    ],
  ),
),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 12),

            // ================= BANNER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AspectRatio(
                aspectRatio: 16 / 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/Felting-Shoe-upper2.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ================= DOT INDICATOR =================
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(true),
                _buildDot(false),
                _buildDot(false),
              ],
            ),

            const SizedBox(height: 20),

            // ================= EXCLUSIVE OFFER =================
            _sectionHeader('Exclusive Offer'),

            const SizedBox(height: 12),

            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  ProductCard(
                    title: 'Felt Dogs',
                    price: '\$10',
                    imagePath: 'assets/images/imageh2.webp',
                  ),
                  SizedBox(width: 15),
                  ProductCard(
                    title: 'Felt Cats',
                    price: '\$20',
                    imagePath: 'assets/images/imageh3.webp',
                  ),
                  SizedBox(width: 15),
                  ProductCard(
                    title: 'Handmade Item',
                    price: '\$15',
                    imagePath: 'assets/images/imageh4.webp',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= BEST SELLING =================
            _sectionHeader('Best Selling'),

            const SizedBox(height: 12),

            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  ProductCard(
                    title: 'Ornaments',
                    price: '\$8',
                    imagePath: 'assets/images/imageh5.webp',
                    showImageOnly: true,
                  ),
                  SizedBox(width: 15),
                  ProductCard(
                    title: 'Elf Head',
                    price: '\$12',
                    imagePath: 'assets/images/imageh6.avif',
                    showImageOnly: true,
                  ),
                  SizedBox(width: 15),
                  ProductCard(
                    title: 'Wreath',
                    price: '\$25',
                    imagePath: 'assets/images/imageh7.jpg',
                    showImageOnly: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ================= SECTION HEADER =================
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'See all',
            style: TextStyle(
              fontSize: 16,
              color: primaryPurple.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ================= DOT =================
  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 20 : 6,
      decoration: BoxDecoration(
        color: isActive ? primaryPurple : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// ================= PRODUCT CARD =================
class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;
  final bool showImageOnly;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
    this.showImageOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // PRODUCT IMAGE
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          if (!showImageOnly)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryPurple,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          debugPrint('Added $title');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: primaryPurple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
