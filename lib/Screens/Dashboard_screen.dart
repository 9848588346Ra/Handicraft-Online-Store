import 'package:flutter/material.dart';
import 'package:mitho_bakery/Screens/Button%20Screen/Account_screen.dart';
import 'package:mitho_bakery/Screens/Button%20Screen/Cart_screen.dart';
import 'package:mitho_bakery/Screens/Button%20Screen/Explore_screen.dart';
import 'package:mitho_bakery/Screens/Button%20Screen/Shop_Screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
   const ShopScreen(),
   const CartScreen(),
   const ExploreScreen(),  
   const AccountScreen(),
  
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Bottom-Navigation",
      //   style: TextStyle(fontFamily: "open sans bold"
      //   // style: TextStyle(fontFamily: "open sans italic"
      //   // style: TextStyle(fontFamily: "open sans regular"
      //   ),),
      //   centerTitle: true,
      //   backgroundColor: const Color.fromARGB(255, 121, 136, 105),
      // ),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.storefront), label: "Shop"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Cart",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.travel_explore), label: "Explore"),
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