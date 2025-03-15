import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final user = FirebaseAuth.instance.currentUser;

  void removeItem(String docID) {
    FirebaseFirestore.instance.collection("cart").doc(docID).delete();
  }

  void updateQuantity(String docID, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(docID);
    } else {
      FirebaseFirestore.instance.collection("cart").doc(docID).update({
        "quantity": newQuantity,
      });
    }
  }

  void checkoutCart() {
    if (user == null) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Checkout"),
          content: const Text("Are you sure you want to place this order?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                var cartItems = await FirebaseFirestore.instance
                    .collection("cart")
                    .where("userID", isEqualTo: user!.uid)
                    .get();

                for (var item in cartItems.docs) {
                  item.reference.delete();
                }

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Order placed successfully!")),
                );
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart",style: TextStyle(color: Colors.orange, fontSize: 22, fontWeight: FontWeight.bold),)),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("cart")
            .where("userID", isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var cartItems = snapshot.data!.docs;

          if (cartItems.isEmpty) {
            return const Center(child: Text("Your cart is empty", style: TextStyle(fontSize: 18)));
          }

          double total = 0;
          for (var item in cartItems) {
            var product = item.data();
            double price = (product["price"] is String) 
                ? double.tryParse(product["price"]) ?? 0 
                : product["price"].toDouble();
            int quantity = product["quantity"] ?? 1;
            total += price * quantity;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var cartItem = cartItems[index].data();
                    String docID = cartItems[index].id;

                    return Dismissible(
                      key: Key(docID),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        removeItem(docID);
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: Image.network(cartItem["image"], width: 50, height: 50),
                          title: Text(cartItem["name"]),
                          subtitle: Text("Price: \$${cartItem["price"]}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  updateQuantity(docID, cartItem["quantity"] - 1);
                                },
                              ),
                              Text(cartItem["quantity"].toString(), style: const TextStyle(fontSize: 18)),
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Colors.green),
                                onPressed: () {
                                  updateQuantity(docID, cartItem["quantity"] + 1);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Total: \$${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: checkoutCart,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: const Text("Checkout", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
