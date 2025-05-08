import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailPage extends StatelessWidget {
  final DocumentSnapshot productData;

  ProductDetailPage({required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productData['title'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.network(productData['imageUrl'], height: 250, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(productData['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(productData['description']),
            SizedBox(height: 8),
            Text('Fiyat: ${productData['price']} ₺', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Kategori: ${productData['category']}'),
            Text('Marka: ${productData['brand']}'),
            Text('Durum: ${productData['condition']}'),
          ],
        ),
      ),
    );
  }
}
