import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final user = FirebaseAuth.instance.currentUser;

  void removeFromFavorites(String docID) {
    FirebaseFirestore.instance.collection("favorites").doc(docID).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("favorites")
            .where("userID", isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var favoriteItems = snapshot.data!.docs;

          if (favoriteItems.isEmpty) {
            return const Center(child: Text("No favorites added yet", style: TextStyle(fontSize: 18)));
          }

          return ListView.builder(
            itemCount: favoriteItems.length,
            itemBuilder: (context, index) {
              var favoriteItem = favoriteItems[index].data() as Map<String, dynamic>;
              String docID = favoriteItems[index].id;

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(favoriteItem["image"], width: 50, height: 50),
                  title: Text(favoriteItem["name"]),
                  subtitle: Text("Price: \$${favoriteItem["price"]}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: favoriteItem),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          removeFromFavorites(docID);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
