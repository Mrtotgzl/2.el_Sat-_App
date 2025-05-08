import 'package:flutter/material.dart';
import 'package:satis_app/screens/products/add_product_page.dart';
import 'package:satis_app/screens/products/home_products_page.dart';
import 'package:satis_app/screens/ui/favorites_page.dart'; // EKLENDİ

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    HomeProductsPage(),            // Ana sayfa
    FavoritesPage(),               // Favoriler SAYFASI EKLENDİ
    AddProductPage(),              // Ürün ekleme
    Center(child: Text("Sepetim")),
    Center(child: Text("Hesabım")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "İkinci Nefes",
          style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 30,
            fontFamily: "Pacifico",
          ),
        ),
        centerTitle: true,
      ),
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoriler"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ürün Ekle"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Sepet"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Hesabım"),
        ],
      ),
    );
  }
}
