import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://dummyjson.com/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }


    Future<User> getCurrentUser(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://dummyjson.com/auth/me'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
     if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      return user;
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}