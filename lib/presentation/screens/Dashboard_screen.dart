import 'package:flutter/material.dart';
import 'package:handicraft_online_store/data/cart_provider.dart';
import 'package:handicraft_online_store/data/models/cart_item.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/account_screen.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/cart_screen.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/explore_screen.dart';
import 'package:handicraft_online_store/presentation/screens/Button Screen/shop_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onAddToCart(
    BuildContext context,
    String title,
    String imagePath,
    double price,
  ) {
    final item = CartItem(title, imagePath, price, 1);
    CartProvider.instance.addItem(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title added to cart'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lstBottomScreen = [
      ShopScreen(
        onAddToCart: (ctx, title, imagePath, price) =>
            _onAddToCart(ctx, title, imagePath, price),
      ),
      const ExploreScreen(),
      CartScreen(onContinueShopping: () => setState(() => _selectedIndex = 0)),
      AccountScreen(onNavigateToShop: () => setState(() => _selectedIndex = 0)),
    ];
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Bottom-Navigation", style: TextStyle(fontFamily: "open sans bold")),
      //   centerTitle: true,
      //   backgroundColor: const Color.fromARGB(255, 121, 136, 105),
      // ),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: "Shop"),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        selectedItemColor: const Color.fromARGB(255, 197, 67, 253),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
