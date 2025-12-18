import 'package:flutter/material.dart';

const Color primaryPurple = Color(0xFF5E35B1);
const Color customRed = Color(0xFFE53935);
const Color lightBlue = Color(0xFFB3E5FC); 

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. AppBar
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
              child: const Center(
                child: Icon(Icons.palette, color: primaryPurple),
              ),
            ),
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
        actions: const [SizedBox(width: 50)], 
      ),

      // 2. Body Content (Scrollable)
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),

            // --- A. Christmas Offer Banner / Slider ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AspectRatio(
                aspectRatio: 16 / 6, // Approximate aspect ratio of the banner image
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Placeholder color
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Christmas Offer Banner\n(Image Placeholder)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // Placeholder for Page Indicator Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(true),
                _buildDot(false),
                _buildDot(false),
              ],
            ),

            const SizedBox(height: 20),

            // --- B. Exclusive Offer Section Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Exclusive Offer',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 16,
                      color: primaryPurple.withOpacity(0.8), // Use a slightly transparent primary color
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 15),

            // --- C. Exclusive Offer Product List (Horizontal Scroll) ---
            SizedBox(
              height: 220, // Height for the horizontal list items
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: const [
                  ProductCardPlaceholder(
                    title: 'Felt Dogs',
                    price: '\$ 10',
                  ),
                  SizedBox(width: 15),
                  ProductCardPlaceholder(
                    title: 'Felt Cats',
                    price: '\$ 20',
                  ),
                  SizedBox(width: 15),
                  ProductCardPlaceholder(
                    title: 'Other Item',
                    price: '\$ 15',
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),

            const SizedBox(height: 30),
            
            // --- D. Best Selling Section Header ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Best Selling',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
            ),
            
            const SizedBox(height: 15),

            // --- E. Best Selling Product List (Horizontal Scroll) ---
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: const [
                  ProductCardPlaceholder(
                    title: 'Ornaments',
                    price: '\$ 8',
                    showImageOnly: true, // Example for different card style
                  ),
                  SizedBox(width: 15),
                  ProductCardPlaceholder(
                    title: 'Elf Head',
                    price: '\$ 12',
                    showImageOnly: true,
                  ),
                  SizedBox(width: 15),
                  ProductCardPlaceholder(
                    title: 'Wreath',
                    price: '\$ 25',
                    showImageOnly: true,
                  ),
                  SizedBox(width: 15),
                ],
              ),
            ),
            const SizedBox(height: 20), // Extra space at the bottom
          ],
        ),
      ),
    );
  }

  // Helper function for the dot indicator
  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 6.0,
      width: isActive ? 20.0 : 6.0,
      decoration: BoxDecoration(
        color: isActive ? primaryPurple : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// --- Placeholder Widget for Product Cards ---
class ProductCardPlaceholder extends StatelessWidget {
  final String title;
  final String price;
  final bool showImageOnly;

  const ProductCardPlaceholder({
    super.key,
    required this.title,
    required this.price,
    this.showImageOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150, // Fixed width for the cards
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Placeholder for the Product Image
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200], // Image background color
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.image, size: 50, color: Colors.grey[400]),
            ),
          ),

          // Product details (only for the 'Exclusive Offer' style)
          if (!showImageOnly)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: primaryPurple,
                        ),
                      ),
                      // Add to Cart Button
                      InkWell(
                        onTap: () {
                          print('Added $title to cart');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryPurple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
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
