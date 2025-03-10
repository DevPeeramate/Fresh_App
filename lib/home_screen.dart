import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresh_app/cart_screen.dart';
import 'package:fresh_app/product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  void addToCart(Map<String, dynamic> product) {
    if (user == null) {
      print("❌ User not logged in");
      return;
    }

    FirebaseFirestore.instance.collection("cart").add({
      "userID": user!.uid,
      "name": product["name"],
      "price": product["price"],
      "image": product["image"],
      "timestamp": FieldValue.serverTimestamp(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${product['name']} added to cart!")),
      );
    }).catchError((error) {
      print("❌ Failed to add to cart: $error");
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
            SizedBox(width: 5),
            Text("FreshApp", style: TextStyle(color: Colors.orange, fontSize: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                    CategoryItem("Fruits", FontAwesomeIcons.apple, context),
                    CategoryItem("Vegetables", FontAwesomeIcons.carrot, context),
                    CategoryItem("Meat", FontAwesomeIcons.drumstickBite, context),
                    CategoryItem("Fish", FontAwesomeIcons.fish, context),
                    CategoryItem("Beverage", FontAwesomeIcons.wineBottle, context),
                  ],
                ),
              ),
              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Popular Deals", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("See All", style: TextStyle(color: Colors.orange, fontSize: 16)),
                ],
              ),
              SizedBox(height: 10),

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Beverage").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var products = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index].data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(product["image"], width: 50, height: 50),
                          title: Text(product["name"]),
                          subtitle: Text("Price: ${product["price"]} THB"),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            onPressed: () {
                              addToCart(product);
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
}

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
    ),
  );
}
