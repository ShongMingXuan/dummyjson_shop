import 'dart:convert';
import 'package:dummyjson_shop/services/api_exception.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/userProfile.dart';

class AuthService {
  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password,}),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      final body = jsonDecode(response.body);
      throw ApiException(body['message'] ?? 'Failed to login', response.statusCode);
    }
  }

    
    Future<UserProfile> getCurrentUser(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/auth/me'),
      headers: {'Authorization': 'Bearer $accessToken'},
    ).timeout(const Duration(seconds: 10));
     if (response.statusCode == 200) {
      final userProfile = UserProfile.fromJson(jsonDecode(response.body));
      return userProfile;
    } else {
      throw ApiException('Failed to get user profile: ${response.statusCode}', response.statusCode);
    }
  }

  Future<({String accessToken, String refreshToken})> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return (
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
    } else {
      final body = jsonDecode(response.body);
      throw ApiException(body['message'] ?? 'Failed to refresh token', response.statusCode);
    }
  } 

}  