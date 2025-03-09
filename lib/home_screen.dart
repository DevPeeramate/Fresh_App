import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // flutter pub add font_awesome_flutter

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Icon(Icons.location_on, color: Colors.orange),
            SizedBox(width: 5),
            Text(
              "FreshApp",
              style: TextStyle(color: Colors.orange, fontSize: 18),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView( 
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("See All",
                      style: TextStyle(color: Colors.orange, fontSize: 16)),
                ],
              ),
              SizedBox(height: 10),

              Container(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(), 
                  children: [
                    CategoryItem("Fruits", FontAwesomeIcons.apple),
                    CategoryItem("Vegetables", FontAwesomeIcons.carrot),
                    CategoryItem("Meat", FontAwesomeIcons.drumstickBite),
                    CategoryItem("Fish", FontAwesomeIcons.fish),
                    CategoryItem("Sea Food", FontAwesomeIcons.shrimp),
                    CategoryItem("Beverage", FontAwesomeIcons.wineBottle),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Popular Deals
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Popular Deals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("See All", style: TextStyle(color: Colors.orange, fontSize: 16)),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

// Category Item Widget
Widget CategoryItem(String title, IconData icon) {
  return Container(
    width: 80,
    margin: EdgeInsets.only(right: 10),
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.orange[100],
          child: Icon(icon, color: Colors.orange),
        ),
        SizedBox(height: 5),
        Text(title, style: TextStyle(fontSize: 14)),
      ],
    ),
  );
}
