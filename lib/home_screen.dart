import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_app/cart_screen.dart';
import 'package:fresh_app/product_list_screen.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final List<String> categories = ["Fruits", "Vegetables", "Meat", "Fish", "Beverage"];
  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.orange),
            const SizedBox(width: 5),
            const Text("FreshApp", style: TextStyle(color: Colors.orange, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🔍 Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 📂 Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Text("See All", style: TextStyle(color: Colors.orange, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),

              Container(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    CategoryItem("Fruits", FontAwesomeIcons.apple, context),
                    CategoryItem("Vegetables", FontAwesomeIcons.carrot, context),
                    CategoryItem("Meat", FontAwesomeIcons.drumstickBite, context),
                    CategoryItem("Fish", FontAwesomeIcons.fish, context),
                    CategoryItem("Beverage", FontAwesomeIcons.wineBottle, context),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ⭐ Popular Deals - สินค้าสุ่ม 3 รายการจากทุกหมวด
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Popular Deals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Text("See All", style: TextStyle(color: Colors.orange, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),

              StreamBuilder(
                stream: getRandomProducts(3),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var products = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(product["image"], width: 50, height: 50),
                          title: Text(product["name"]),
                          subtitle: Text("Price: ${product["price"]} THB"),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(product: product),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 📌 ฟังก์ชันดึงสินค้าสุ่มจากทุกหมวดหมู่
  Stream<List<Map<String, dynamic>>> getRandomProducts(int count) async* {
    List<Map<String, dynamic>> allProducts = [];

    for (var category in categories) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(category).get();
      for (var doc in snapshot.docs) {
        allProducts.add(doc.data() as Map<String, dynamic>);
      }
    }

    allProducts.shuffle(); // 🔀 สุ่มรายการสินค้า
    yield allProducts.take(count).toList(); // 🔥 ส่งออก 3 รายการ
  }
}

// 📌 Category Item Widget
Widget CategoryItem(String title, IconData icon, BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductListScreen(category: title),
        ),
      );
    },
    child: Container(
      width: 80,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.orange[100],
            child: Icon(icon, color: Colors.orange),
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 14)),
        ],
      ),
    ),
  );
}
