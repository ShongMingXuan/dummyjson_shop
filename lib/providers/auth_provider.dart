import 'package:dummyjson_shop/models/userProfile.dart';
import 'package:dummyjson_shop/services/auth_service.dart';
import 'package:dummyjson_shop/services/token_storage.dart';
import 'package:dummyjson_shop/utils/jwt_utils.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  // 1. the services it uses
  final AuthService _authService;
  final TokenStorage _tokenStorage;

  // 2. the state: isLoading, errorMessage
  bool _isLoading = false;
  String? _errorMessage;
  String? _accessToken;
  UserProfile? _profile;

  // 3. getter for the state
  bool get isLoggedIn => _accessToken != null;
  bool get isLoading => _isLoading; 
  String? get errorMessage => _errorMessage;
  UserProfile? get profile => _profile;
  String? get accessToken => _accessToken;


  // 4. method signatures for login, logout, tryAutoLogin (empty bodies for now)
  AuthProvider(this._authService, this._tokenStorage);
  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(username, password);
      final profile = await _authService.getCurrentUser(user.accessToken);
      await _tokenStorage.saveToken(user.accessToken);
      _accessToken = user.accessToken;
      _profile = profile;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> logout() async {
    _accessToken = null;
    _profile = null;
    await _tokenStorage.deleteToken();
    notifyListeners();
  }
  
  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _tokenStorage.readToken();
      if (token != null) {
        try {
          if (isTokenExpired(token)) {
            await _tokenStorage.deleteToken();
          } else {
            final profile = await _authService.getCurrentUser(token);
            _accessToken = token;
            _profile = profile;
          }
        } catch (e) {
          await _tokenStorage.deleteToken();
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}