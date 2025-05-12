import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product_detail_page.dart';

class HomeProductsPage extends StatefulWidget {
  final String userId;

  const HomeProductsPage({super.key, required this.userId});

  @override
  _HomeProductsPageState createState() => _HomeProductsPageState();
}

class _HomeProductsPageState extends State<HomeProductsPage> {
  Set<String> favoriteProductIds = {};

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final favSnapshot = await FirebaseFirestore.instance
        .collection('favorites')
        .where('userId', isEqualTo: widget.userId)
        .get();

    setState(() {
      favoriteProductIds =
          favSnapshot.docs.map((doc) => doc['productId'] as String).toSet();
    });
  }

  Future<void> toggleFavorite(
      String productId, Map<String, dynamic> product) async {
    final favRef = FirebaseFirestore.instance.collection('favorites');
    final existing = await favRef
        .where('userId', isEqualTo: widget.userId)
        .where('productId', isEqualTo: productId)
        .get();

    if (existing.docs.isNotEmpty) {
      await favRef.doc(existing.docs.first.id).delete();
      favoriteProductIds.remove(productId);
    } else {
      await favRef.add({
        'userId': widget.userId,
        'productId': productId,
        'title': product['title'],
        'price': product['price'],
        'imageUrl': product['imageUrl'],
        'description': product['description'],
      });
      favoriteProductIds.add(productId);
    }

    setState(() {}); // UI yenile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
        FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Bir hata oluştu"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Henüz ürün yok"));
          }

          final products = snapshot.data!.docs;

          return GridView.builder(
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final doc = products[index];
              final productData = doc.data();
              final productId = doc.id;

              final isFav = favoriteProductIds.contains(productId);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(
                        product: productData,
                        productId: productId,
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                Text(
                                  productData['title'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("${productData['price']} ₺"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.black,
                          ),
                          onPressed: () =>
                              toggleFavorite(productId, productData),
                        ),
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
