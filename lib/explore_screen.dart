import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fresh_app/product_list_screen.dart';

// ใช้ Categories เดียวกับ HomeScreen เพื่อให้เพิ่มได้ง่าย
final List<Map<String, dynamic>> categories = [
  {"name": "Fruits", "icon": FontAwesomeIcons.apple},
  {"name": "Vegetables", "icon": FontAwesomeIcons.carrot},
  {"name": "Meat", "icon": FontAwesomeIcons.drumstickBite},
  {"name": "Fish", "icon": FontAwesomeIcons.fish},
  {"name": "Beverage", "icon": FontAwesomeIcons.wineBottle},
];

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 คอลัมน์
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var category = categories[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListScreen(category: category["name"]),
                  ),
                );
              },
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.orange[100],
                    child: Icon(category["icon"], color: Colors.orange, size: 30),
                  ),
                  const SizedBox(height: 5),
                  Text(category["name"], style: const TextStyle(fontSize: 14)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
