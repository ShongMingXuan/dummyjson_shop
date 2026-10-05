import 'package:flutter_test/flutter_test.dart';
import 'package:dummyjson_shop/services/auth_service.dart';
import 'package:dummyjson_shop/services/product_service.dart';

void main() {
  test('fetchProducts returns products with a valid token', () async {
    final user = await AuthService().login('emilys', 'emilyspass');
    final products = await ProductService().fetchProducts(
      accessToken: user.accessToken,
      limit: 5,
    );

    print('count: ${products.length}');
    print('first: ${products.first.title}');
    expect(products.length, 5);
  });
}