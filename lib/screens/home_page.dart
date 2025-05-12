import 'package:flutter/material.dart';
import 'package:satis_app/screens/products/add_product_page.dart';
import 'package:satis_app/screens/products/home_products_page.dart';
import 'package:satis_app/screens/ui/card_page.dart';
import 'package:satis_app/screens/ui/favorites_page.dart';

class HomePage extends StatefulWidget {
  final String userId;

  const HomePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeProductsPage(userId: widget.userId),
      FavoritesPage(userId: widget.userId),
      AddProductPage(),
      CartPage(userId: widget.userId),
      Center(child: Text("Hesabım")),
    ];
  }

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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
