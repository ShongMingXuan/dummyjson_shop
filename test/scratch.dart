  import 'dart:convert';
  import 'package:dummyjson_shop/services/auth_service.dart';

  Future<void> main() async {
    try {
    final user = await AuthService().login('emilys', 'emilyspass');
    print(user.firstName);
    
    final currentUser = await AuthService().getCurrentUser(user.accessToken);
    print(currentUser.firstName);
    print(currentUser.username);
  } catch (e) {
    print('Error: $e');
  }
  }