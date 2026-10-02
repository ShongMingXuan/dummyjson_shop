import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/userProfile.dart';

class AuthService {
  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
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
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}