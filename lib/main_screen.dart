import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'favorite_screen.dart';
import 'account_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ExploreScreen(),
    FavoriteScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.store), label: "Shop"),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
        ),

        // ✅ ใช้ floatingActionButton เพื่อให้กดได้
        floatingActionButton: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("cart")
              .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            int itemCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
            return Stack(
              alignment: Alignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartScreen()),
                    );
                  },
                  child: const Icon(Icons.shopping_cart, size: 28, color: Colors.white),
                ),

                // ✅ แสดงตัวเลขจำนวนสินค้า (Positioned ด้านขวาบน)
                if (itemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // ✅ ให้ปุ่มอยู่ขวาล่าง
      ),
    );
  }
}
