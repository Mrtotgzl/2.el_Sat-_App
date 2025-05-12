import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../products/product_detail_page.dart';

class CartPage extends StatefulWidget {
  final String userId;

  const CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartProducts = [];
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    final cartDoc = await FirebaseFirestore.instance
        .collection('cart')
        .doc(widget.userId)
        .get();

    final productIds = List<String>.from(cartDoc.data()?['items'] ?? []);

    List<Map<String, dynamic>> temp = [];
    double sum = 0;

    for (String id in productIds) {
      final productDoc =
      await FirebaseFirestore.instance.collection('products').doc(id).get();
      final data = productDoc.data();
      if (data != null) {
        data['id'] = id;
        temp.add(data);
        sum += double.tryParse(data['price'].toString()) ?? 0;
      }
    }

    setState(() {
      cartProducts = temp;
      totalPrice = sum;
    });
  }

  Future<void> removeFromCart(String productId) async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(widget.userId)
        .update({
      'items': FieldValue.arrayRemove([productId])
    });
    fetchCartItems();
  }

  Future<bool> isFavorite(String productId) async {
    final favs = await FirebaseFirestore.instance
        .collection('favorites')
        .where('userId', isEqualTo: widget.userId)
        .where('productId', isEqualTo: productId)
        .get();

    return favs.docs.isNotEmpty;
  }

  Future<void> toggleFavorite(String productId, Map<String, dynamic> product) async {
    final favRef = FirebaseFirestore.instance.collection('favorites');
    final favSnapshot = await favRef
        .where('userId', isEqualTo: widget.userId)
        .where('productId', isEqualTo: productId)
        .get();

    if (favSnapshot.docs.isNotEmpty) {
      await favRef.doc(favSnapshot.docs.first.id).delete();
    } else {
      await favRef.add({
        'userId': widget.userId,
        'productId': productId,
        'title': product['title'],
        'price': product['price'],
        'imageUrl': product['imageUrl'],
        'description': product['description'],
      });
    }

    setState(() {}); // UI'yı yenile
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sepetim")),
      body: cartProducts.isEmpty
          ? const Center(child: Text("Sepetiniz boş"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartProducts[index];
                return ListTile(
                  leading: Image.network(product['imageUrl'], width: 60),
                  title: Text(product['title']),
                  subtitle: Text("${product['price']} ₺"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(
                          product: product,
                          productId: product['id'],
                          userId: widget.userId,
                        ),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeFromCart(product['id']),
                      ),
                      FutureBuilder<bool>(
                        future: isFavorite(product['id']),
                        builder: (context, snapshot) {
                          final isFav = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : null,
                            ),
                            onPressed: () =>
                                toggleFavorite(product['id'], product),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Toplam: $totalPrice ₺",
                style: const TextStyle(fontSize: 18)),
          )
        ],
      ),
    );
  }
}
