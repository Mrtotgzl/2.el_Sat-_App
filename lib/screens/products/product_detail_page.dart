import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;
  final String productId;
  final String userId;

  ProductDetailPage({
    Key? key,
    required this.product,
    required this.productId,
    required this.userId,
  }) : super(key: key);

  Future<void> addToCart() async {
    final cartRef = FirebaseFirestore.instance.collection('cart').doc(userId);

    final cartDoc = await cartRef.get();
    if (cartDoc.exists) {
      // Listeye ekle
      await cartRef.update({
        'items': FieldValue.arrayUnion([productId])
      });
    } else {
      // Yeni doküman oluştur
      await cartRef.set({
        'items': [productId]
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['title'] ?? 'Ürün Detayı')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image.network(product['imageUrl'], height: 250, fit: BoxFit.cover),
          const SizedBox(height: 16),
          Text(product['title'] ?? '',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('${product['price']} ₺',
              style: const TextStyle(fontSize: 18, color: Colors.green)),
          const SizedBox(height: 8),
          Text('Kategori: ${product['category']}'),
          Text('Marka: ${product['brand']}'),
          Text('Durum: ${product['condition']}'),
          const SizedBox(height: 16),
          Text(product['description'] ?? ''),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await addToCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ürün sepete eklendi")),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Sepete Ekle'),
          ),

        ],
      ),
    );
  }
}
