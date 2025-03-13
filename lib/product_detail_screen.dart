import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final user = FirebaseAuth.instance.currentUser;
  int quantity = 1; // จำนวนสินค้าที่เพิ่มลงตะกร้า
  bool isFavorite = false;
  String? favoriteDocID;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  // ตรวจสอบว่าสินค้าอยู่ใน Favorites หรือไม่
  void checkIfFavorite() async {
    if (user == null) return;

    var snapshot = await FirebaseFirestore.instance
        .collection("favorites")
        .where("userID", isEqualTo: user!.uid)
        .where("name", isEqualTo: widget.product["name"])
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        isFavorite = true;
        favoriteDocID = snapshot.docs.first.id;
      });
    }
  }

  // เพิ่ม / ลบสินค้าใน Favorites
  void toggleFavorite() {
    if (user == null) {
      print("User not logged in");
      return;
    }

    if (isFavorite) {
      FirebaseFirestore.instance.collection("favorites").doc(favoriteDocID).delete().then((_) {
        setState(() {
          isFavorite = false;
          favoriteDocID = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${widget.product['name']} removed from favorites!")),
        );
      });
    } else {
      FirebaseFirestore.instance.collection("favorites").add({
        "userID": user!.uid,
        "name": widget.product["name"],
        "price": widget.product["price"],
        "image": widget.product["image"],
        "timestamp": FieldValue.serverTimestamp(),
      }).then((docRef) {
        setState(() {
          isFavorite = true;
          favoriteDocID = docRef.id;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${widget.product['name']} added to favorites!")),
        );
      });
    }
  }

  // เพิ่มสินค้าในตะกร้า
  void addToCart() {
    if (user == null) {
      print("User not logged in");
      return;
    }

    FirebaseFirestore.instance.collection("cart").add({
      "userID": user!.uid,
      "name": widget.product["name"],
      "price": widget.product["price"],
      "image": widget.product["image"],
      "quantity": quantity,
      "timestamp": FieldValue.serverTimestamp(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.product['name']} added to cart!")),
      );
    }).catchError((error) {
      print("Failed to add to cart: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product["name"])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(widget.product["image"], height: 200),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.product["name"], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                  onPressed: toggleFavorite, // กดแล้วเพิ่มหรือลบออกจาก Favorite
                ),
              ],
            ),
            Text("\$${widget.product["price"]} / unit", style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 10),
            const Text(
              "Golden ripe fruits delivered to your house in the most hygienic way...",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addToCart,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Add To Cart", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
