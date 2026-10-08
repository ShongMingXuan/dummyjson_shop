import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      
      body: items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Image.network(
                    item.product.thumbnailUrl,
                    width: 56,
                    height: 56,
                    errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
                  ),
                  title: Text(item.product.title),
                  subtitle: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                  // your job: trailing with - , quantity, + buttons
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          cart.decreaseItem(item.product);
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cart.addItem(item.product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete), 
                        onPressed: () => cart.removeItem(item.product),
                      ),
                    ],
                  ),
                );
              },
            ),

      bottomNavigationBar: items.isEmpty? null
      : Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: cart.clearCart,
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
    );
  }
}