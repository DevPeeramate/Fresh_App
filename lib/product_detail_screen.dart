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
  int quantity = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    if (user == null) return;

    var favSnapshot = await FirebaseFirestore.instance
        .collection("favorites")
        .where("userID", isEqualTo: user!.uid)
        .where("name", isEqualTo: widget.product["name"])
        .get();

    setState(() {
      isFavorite = favSnapshot.docs.isNotEmpty;
    });
  }

  void toggleFavorite() {
    if (user == null) return;

    if (isFavorite) {
      FirebaseFirestore.instance
          .collection("favorites")
          .where("userID", isEqualTo: user!.uid)
          .where("name", isEqualTo: widget.product["name"])
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } else {
      FirebaseFirestore.instance.collection("favorites").add({
        "userID": user!.uid,
        "name": widget.product["name"],
        "price": widget.product["price"],
        "image": widget.product["image"],
        "detail": widget.product["detail"],
        "timestamp": FieldValue.serverTimestamp(),
      });
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void addToCart() {
    if (user == null) return;

    FirebaseFirestore.instance.collection("cart").add({
      "userID": user!.uid,
      "name": widget.product["name"],
      "price": widget.product["price"],
      "image": widget.product["image"],
      "detail": widget.product["detail"],
      "quantity": quantity,
      "timestamp": FieldValue.serverTimestamp(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${widget.product['name']} added to cart!")),
      );
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
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: toggleFavorite,
                ),
              ],
            ),
            Text("\$${widget.product["price"]}", style: const TextStyle(fontSize: 18, color: Colors.orange)),
            const SizedBox(height: 10),
            Text(
              widget.product["detail"] ?? "No detail available",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
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
