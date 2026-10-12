import 'package:dummyjson_shop/providers/auth_provider.dart';
import 'package:dummyjson_shop/providers/cart_provider.dart';
import 'package:dummyjson_shop/providers/product_provider.dart';
import 'package:dummyjson_shop/screens/cart_screen.dart';
import 'package:dummyjson_shop/screens/home_screen.dart';
import 'package:dummyjson_shop/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {

  int _index = 0;

  @override
  
  Widget build(BuildContext context) {
    final isLoggedIn = context.select<AuthProvider, bool>((a) => a.isLoggedIn);
    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<CartProvider>().clearCart();
        context.read<ProductProvider>().clear();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: const [
          HomeScreen(),
          CartScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}