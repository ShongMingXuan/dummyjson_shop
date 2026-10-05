  import 'package:flutter/material.dart';
  import 'package:dummyjson_shop/services/product_service.dart';
  import 'package:dummyjson_shop/models/product.dart';

  enum ProductListStatus { loading, empty, error, loaded }

  class ProductProvider extends ChangeNotifier {
    static const _pageSize = 10;
    
    final ProductService _productService;
    
    ProductListStatus _status = ProductListStatus.loading;
    List<Product> _products = <Product>[]; 
    String? _errorMessage;
    bool _isLoadingMore = false;
    bool _hasMore = true;
    int _skip = 0;


    ProductListStatus get status => _status;
    List<Product> get products => _products;
    String? get errorMessage => _errorMessage;
    bool get isLoadingMore => _isLoadingMore;
    bool get hasMore => _hasMore;

    ProductProvider(this._productService);

    Future<void> loadFirstPage(String accessToken) async {
      _status = ProductListStatus.loading;
      _errorMessage = null;
      notifyListeners();

      try {
        final fetchedProducts = await _productService.fetchProducts(
          accessToken: accessToken,
          limit: _pageSize,
          skip: 0,
        );

        _products = fetchedProducts;
        _skip = fetchedProducts.length;
        _hasMore = fetchedProducts.length == _pageSize;

        if (_products.isEmpty) {
          _status = ProductListStatus.empty;
        } else {
          _status = ProductListStatus.loaded;
        }
      } catch (e) {
        _errorMessage = e.toString();
        _status = ProductListStatus.error;
      }

      notifyListeners();
    }


    Future<void> loadMore(String accessToken) async {
      if (_isLoadingMore || !_hasMore) return;
      _isLoadingMore = true;
      notifyListeners();

      try {
        final fetchedProducts = await _productService.fetchProducts(
          accessToken: accessToken,
          limit: _pageSize,
          skip: _skip,
        );

        _products.addAll(fetchedProducts);
        _skip += fetchedProducts.length;
        _hasMore = fetchedProducts.length == _pageSize;
      } catch (e) {
        _errorMessage = e.toString();
      } finally {
        _isLoadingMore = false;
        notifyListeners();
      }
    }
    
  }