import 'package:dummyjson_shop/models/userProfile.dart';
import 'package:dummyjson_shop/services/api_exception.dart';
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
  String? _refreshToken;
  UserProfile? _profile;

  // 3. getter for the state
  bool get isLoggedIn => _accessToken != null;
  bool get isLoading => _isLoading; 
  String? get errorMessage => _errorMessage;
  UserProfile? get profile => _profile;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  // 4. method signatures for login, logout, tryAutoLogin (empty bodies for now)
  AuthProvider(this._authService, this._tokenStorage);
  
  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(username, password);
      final profile = await _authService.getCurrentUser(user.accessToken);
      await _tokenStorage.saveTokens(user.accessToken, user.refreshToken);
      _accessToken = user.accessToken;
      _refreshToken = user.refreshToken;
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
    _refreshToken = null;
    _profile = null;
    await _tokenStorage.deleteTokens();
    notifyListeners();
  }
  
  Future<void> tryAutoLogin() async {
    _isLoading = true;
    notifyListeners();

    try {
      final accesstoken = await _tokenStorage.readAccessToken();
      final savedRefresh = await _tokenStorage.readRefreshToken();
      if (accesstoken != null) {
        try {
          if (isTokenExpired(accesstoken)) {
            if (savedRefresh != null && !isTokenExpired(savedRefresh)) {
              final user = await _authService.refreshToken(savedRefresh);
              await _tokenStorage.saveTokens(user.accessToken, user.refreshToken);
              final profile = await _authService.getCurrentUser(user.accessToken);
              _accessToken = user.accessToken;
              _refreshToken = user.refreshToken;
              _profile = profile;
            } else {
                await _tokenStorage.deleteTokens();
              }
          } else {
            final profile = await _authService.getCurrentUser(accesstoken);
            _accessToken = accesstoken;
            _refreshToken = savedRefresh;
            _profile = profile;
          }
        } catch (e) {
          await _tokenStorage.deleteTokens();
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

    Future<String?> refreshSession() async {
      if (_refreshToken == null) return null;

      try {
        final tokens = await _authService.refreshToken(_refreshToken!);
        await _tokenStorage.saveTokens(tokens.accessToken, tokens.refreshToken);
        _accessToken = tokens.accessToken;
        _refreshToken = tokens.refreshToken;
        return _accessToken;
      } on ApiException catch (e) {
        if (e.statusCode == 401) {
          await logout();
        }
        return null;
      } catch (e) {
        return null;
      }
    }
}