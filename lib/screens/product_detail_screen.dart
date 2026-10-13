import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product,required this.color});

  final Product product;
  final Color color;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
                  margin: EdgeInsets.zero,
                  color: color,      // try lightPink or lightGreen too
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.network(
                      product.thumbnailUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(product.description),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Selector<CartProvider, int>(
            selector: (_, cart) => cart.quantityOf(product),
            builder: (context, quantity, _) {
              if (quantity == 0) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CartProvider>().addItem(product);
                    },
                    child: const Text('Add to cart'),
                  ),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      context.read<CartProvider>().decreaseItem(product);
                    },
                  ),
                  Text( 
                    '$quantity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      context.read<CartProvider>().addItem(product);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}