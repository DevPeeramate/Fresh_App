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
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false, 
        title: const Text(
          "Favorites",
          style: TextStyle(
            color: Colors.orange,
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
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
            return const Center(
              child: Text(
                "No favorites added yet",
                style: TextStyle(fontSize: 18)
              )
            );
          }

          return ListView.builder(
            itemCount: favoriteItems.length,
            itemBuilder: (context, index) {
              var favoriteItem = favoriteItems[index].data();
              String docID = favoriteItems[index].id;

              return Dismissible(
                key: Key(docID),
                direction: DismissDirection.endToStart, // เลื่อนซ้ายเพื่อลบ
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white, size: 30), // ไอคอนถังขยะ
                ),
                onDismissed: (direction) {
                  removeFromFavorites(docID);
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(
                      favoriteItem["image"],
                      width: 50,
                      height: 50,
                    ),
                    title: Text(favoriteItem["name"]),
                    subtitle: Text("Price: \$${favoriteItem["price"]}"),
                    trailing: const Icon(Icons.favorite, color: Colors.red), // แสดงรูปหัวใจสีแดง
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: favoriteItem),
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
    );
  }
}
