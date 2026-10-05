import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:dummyjson_shop/utils/jwt_utils.dart';


void main()
{
  test('JWT Decoding Test', () {
    // Example JWT token (replace with a valid token for real testing)
    const jwtToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJlbWlseXMiLCJlbWFpbCI6ImVtaWx5LmpvaG5zb25AeC5kdW1teWpzb24uY29tIiwiZmlyc3ROYW1lIjoiRW1pbHkiLCJsYXN0TmFtZSI6IkpvaG5zb24iLCJnZW5kZXIiOiJmZW1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL2VtaWx5cy8xMjgiLCJpYXQiOjE3OTExNjQ2NDgsImV4cCI6MTc5MTE2ODI0OH0.oDd214q32FxNT_w6ZUH12G0DRzJVcusoAv00P3E4s78';
    final decodedPayload = decodePayload(jwtToken);
    // Add assertions to verify the decoded payload
    expect(decodedPayload['id'], equals(1));
    expect(decodedPayload['username'], equals('emilys'));
  });

  test('Token Expiration Test', () {
    // Example expired JWT token (replace with an actual expired token for real testing)
    const expiredJwtToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwidXNlcm5hbWUiOiJlbWlseXMiLCJlbWFpbCI6ImVtaWx5LmpvaG5zb25AeC5kdW1teWpzb24uY29tIiwiZmlyc3ROYW1lIjoiRW1pbHkiLCJsYXN0TmFtZSI6IkpvaG5zb24iLCJnZW5kZXIiOiJmZW1hbGUiLCJpbWFnZSI6Imh0dHBzOi8vZHVtbXlqc29uLmNvbS9pY29uL2VtaWx5cy8xMjgiLCJpYXQiOjE3OTExNjQ2NDgsImV4cCI6MTc5MTE2ODI0OH0.oDd214q32FxNT_w6ZUH12G0DRzJVcusoAv00P3E4s78';
    final isExpired = isTokenExpired(expiredJwtToken);
    expect(isExpired, equals(true));
  });

    test('token from the past is expired', () {
    expect(isTokenExpired(fakeToken(nowSeconds() - 60)), true);
  });

  test('token one hour in the future is not expired', () {
    expect(isTokenExpired(fakeToken(nowSeconds() + 3600)), false);
  });
}