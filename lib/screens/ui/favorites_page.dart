import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:satis_app/screens/products/product_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({Key? key, required String userId}) : super(key: key);

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> removeFavorite(String favDocId) async {
    await FirebaseFirestore.instance.collection('favorites').doc(favDocId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final favoriteDocs = snapshot.data!.docs;

        if (favoriteDocs.isEmpty) {
          return const Center(child: Text('Favori ürün bulunamadı.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: favoriteDocs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final doc = favoriteDocs[index];
            final productData = doc.data() as Map<String, dynamic>;
            final favDocId = doc.id;
            final productId = productData['productId'];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailPage(
                      product: productData,
                      productId: productId,
                      userId: userId,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Card(
                    elevation: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            productData['imageUrl'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(productData['title'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${productData['price']} ₺',
                                  style: TextStyle(color: Colors.grey[700])),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        removeFavorite(favDocId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Favorilerden çıkarıldı")),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
