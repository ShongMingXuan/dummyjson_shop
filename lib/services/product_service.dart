import 'dart:convert';
import 'package:dummyjson_shop/services/api_exception.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts({
    required String accessToken,
    int limit = 10,
    int skip = 0,
    String query = '',
  }) async {
    final path = query.isEmpty ? 'products' : 'products/search';
    final uri = Uri.https('dummyjson.com', '/auth/$path', {
      'limit': '$limit',
      'skip': '$skip',
      if (query.isNotEmpty) 'q': query,
    });

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final productsJson = data['products'] as List<dynamic>;
      final products = productsJson.map((items) => Product.fromJson(items)).toList();
      return products;
    } 
    else {
      final body = jsonDecode(response.body);
      throw ApiException(body['message'] ?? 'Failed to fetch products', response.statusCode);
    }
  }

  
}