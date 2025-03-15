import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_detail_screen.dart';
import 'product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final List<String> categories = ["Fruits", "Vegetables", "Meat", "Fish", "Beverage"];
  final Random random = Random();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> searchResults = [];
  List<Map<String, dynamic>> popularDeals = []; 
  bool isLoading = true; // ✅ ตัวแปรสถานะโหลดข้อมูล

  @override
  void initState() {
    super.initState();
    loadPopularDeals(); // ✅ โหลด Popular Deals เมื่อเปิดแอป
  }

  void loadPopularDeals() async {
    setState(() {
      isLoading = true; // 🔄 เริ่มโหลดข้อมูล
    });

    List<Map<String, dynamic>> products = await getRandomProducts(3);
    
    setState(() {
      popularDeals = products;
      isLoading = false; // ✅ โหลดเสร็จแล้ว
    });
  }

  void searchProducts(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    List<Map<String, dynamic>> allProducts = [];

    for (var category in categories) {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(category).get();
      for (var doc in snapshot.docs) {
        Map<String, dynamic> product = doc.data() as Map<String, dynamic>;
        if (product["name"].toLowerCase().contains(query.toLowerCase())) {
          allProducts.add(product);
        }
      }
    }

    setState(() {
      searchResults = allProducts;
    });
  }

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
            const Text("FreshApp",
                style: TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🔎 Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    searchProducts(value);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // 📂 Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Categories",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Text("See All",
                      style: TextStyle(color: Colors.orange, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    CategoryItem("Fruits", FontAwesomeIcons.apple, context),
                    CategoryItem(
                        "Vegetables", FontAwesomeIcons.carrot, context),
                    CategoryItem(
                        "Meat", FontAwesomeIcons.drumstickBite, context),
                    CategoryItem("Fish", FontAwesomeIcons.fish, context),
                    CategoryItem(
                        "Beverage", FontAwesomeIcons.wineBottle, context),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ⭐ Popular Deals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Popular Deals",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const Text("See All",
                      style: TextStyle(color: Colors.orange, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 10),

              // 🔥 แสดงตัวโหลดก่อนแสดงข้อมูล
              isLoading
                  ? const Center(child: CircularProgressIndicator()) // 🔄 กำลังโหลดข้อมูล
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: popularDeals.length,
                      itemBuilder: (context, index) {
                        var product = popularDeals[index];

                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: Image.network(product["image"], width: 50, height: 50),
                            title: Text(product["name"]),
                            subtitle: Text("Price: ${product["price"]}"),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailScreen(product: product),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

              // 🔍 Search Results
              if (searchController.text.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Text("Search Results",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                searchResults.isEmpty
                    ? const Center(
                        child: Text("No Result",
                            style: TextStyle(fontSize: 16, color: Colors.grey)))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          var product = searchResults[index];

                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: Image.network(product["image"], width: 50, height: 50),
                              title: Text(product["name"]),
                              subtitle: Text("Price: ${product["price"]} THB"),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 📌 ดึงสินค้าสุ่มจากทุกหมวดหมู่ (โหลดครั้งเดียว)
  Future<List<Map<String, dynamic>>> getRandomProducts(int count) async {
    List<Map<String, dynamic>> allProducts = [];

    for (var category in categories) {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(category).get();
      for (var doc in snapshot.docs) {
        allProducts.add(doc.data() as Map<String, dynamic>);
      }
    }

    allProducts.shuffle();
    return allProducts.take(count).toList();
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
