
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:satis_app/screens/products/product_detail_page.dart';

class HomeProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return GridView.builder(
            itemCount: snapshot.data.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing:10,
              mainAxisSpacing: 10,
              childAspectRatio: 3/1.5,
            ),
            itemBuilder: (context, index) {
              final product = snapshot.data.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(product: product)));
                },
                child: Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Image.network(product['imageUrl'], width: 45, fit: BoxFit.cover),
                    title: Text(product['title']),
                    subtitle: Text("${product['price']} ₺"),
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
/* return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              final product = snapshot.data.docs[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(product['imageUrl'], width: 50, fit: BoxFit.cover),
                  title: Text(product['title']),
                  subtitle: Text("${product['price']} ₺"),*/