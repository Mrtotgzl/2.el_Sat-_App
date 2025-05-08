// home_products_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'product_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProductsPage extends StatefulWidget {
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

  void loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favorites') ?? [];
    setState(() {
      favoriteProductIds = favs.toSet();
    });
  }

  void toggleFavorite(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteProductIds.contains(productId)) {
        favoriteProductIds.remove(productId);
      } else {
        favoriteProductIds.add(productId);
      }
      prefs.setStringList('favorites', favoriteProductIds.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('products')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final products = snapshot.data!.docs;

        return GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 0.7),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isFavorite = favoriteProductIds.contains(product.id);
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ProductDetailPage(productData: product),
                ));
              },
              child: GridTile(
                header: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                    onPressed: () => toggleFavorite(product.id),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(product['imageUrl'], fit: BoxFit.cover),
                    ),
                    SizedBox(height: 4),
                    Text(product['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${product['price']} ₺'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
