import 'package:dummyjson_shop/providers/cart_provider.dart';
import 'package:dummyjson_shop/theme/app_theme.dart';
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
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProducts());
  }

  void _onSearch(String text) {
    final token = context.read<AuthProvider>().accessToken;
    if (token == null) return;
    context.read<ProductProvider>().search(text, token);
  }

  void _onScroll() {
    final provider = context.read<ProductProvider>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (provider.hasMore &&
          !provider.isLoadingMore &&
          !provider.loadMoreFailed) {
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
          itemCount: provider.products.length +
              ((provider.isLoadingMore || provider.loadMoreFailed) ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= provider.products.length) {
              if (provider.loadMoreFailed) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      const Text("Couldn't load more products"),
                      TextButton(
                        onPressed: () {
                          final token =
                              context.read<AuthProvider>().accessToken;
                          if (token != null) {
                            context.read<ProductProvider>().loadMore(token);
                          }
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final product = provider.products[index];
            final bandColor = AppTheme
                .bandColors[(index ~/ 10) % AppTheme.bandColors.length];
            return Card(
              color: bandColor,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.thumbnailUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
                title: Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    context.read<CartProvider>().addItem(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} added to cart'),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final cartCount =
        context.select<CartProvider, int>((cart) => cart.itemCount);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_cart),
            ),
            tooltip: 'Cart',
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search products',
                prefixIcon: Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearch,
            ),
          ),
          Expanded(child: _buildBody(provider)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}