import 'package:dummyjson_shop/screens/cart_screen.dart';
import 'package:dummyjson_shop/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  int _index = 0;
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (newIndex) {
          setState(() {
            _index = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          CartScreen(),
          Center(child: Text('Profile (next)')),
        ],
      ),
    );
  }
}