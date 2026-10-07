import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProducts());
  }

  void _onScroll() {
    final provider = context.read<ProductProvider>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!provider.isLoadingMore && provider.hasMore) {
        final token = context.read<AuthProvider>().accessToken;
        if (token != null) {
          provider.loadMore(token);
        }
      }
    }
  }

  void _loadProducts() {
    final token = context.read<AuthProvider>().accessToken;
    if (token == null) {
      // no token on this screen means something is wrong, so go back to login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }
    context.read<ProductProvider>().loadFirstPage(token);
  }

  Future<void> _logout() async {
    await context.read<AuthProvider>().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _buildBody(ProductProvider provider) {
    switch (provider.status) {
      case ProductListStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ProductListStatus.empty:
        return const Center(child: Text('No products'));

      case ProductListStatus.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.errorMessage ?? 'Something went wrong'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadProducts, // same function as the first load
                child: const Text('Retry'),
              ),
            ],
          ),
        );

      case ProductListStatus.loaded:
        return ListView.builder(
          controller: _scrollController,
          itemCount: provider.products.length + (provider.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= provider.products.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            final product = provider.products[index];
            return ListTile(
              leading: Image.network(
                product.thumbnailUrl,
                width: 56,
                height: 56,
                errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
              ),
              title: Text(product.title),
              subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(provider),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();   
    super.dispose();
  }
}