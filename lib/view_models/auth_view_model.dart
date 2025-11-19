import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final LocalStorageService _localStorageService = LocalStorageService();

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  // Constructor
  AuthViewModel() {
    _checkLoginStatus();
  }

  // Check if user is already logged in
  void _checkLoginStatus() {
    _currentUser = _authService.getCurrentUser();
    _isLoggedIn = _currentUser != null;
    notifyListeners();
  }

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(email, password);

      if (result.isSuccess) {
        _currentUser = result.data;
        _isLoggedIn = true;

        // Save to local storage
        await _localStorageService.saveUser(_currentUser!);
        await _localStorageService.saveAuthToken('mock_token_${email}_${DateTime.now().millisecondsSinceEpoch}');

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Sign up
  Future<bool> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String userType,
    String? vehicleType,
    String? licensePlate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.signup(
        name: name,
        email: email,
        password: password,
        phone: phone,
        userType: userType,
        vehicleType: vehicleType,
        licensePlate: licensePlate,
      );

      if (result.isSuccess) {
        _currentUser = result.data;
        _isLoggedIn = true;

        // Save to local storage
        await _localStorageService.saveUser(_currentUser!);
        await _localStorageService.saveAuthToken('mock_token_${email}_${DateTime.now().millisecondsSinceEpoch}');

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Signup failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.logout();
      await _localStorageService.clearAll();

      _currentUser = null;
      _isLoggedIn = false;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Logout failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.resetPassword(email);

      if (result.isSuccess) {
        _errorMessage = 'Password reset link sent to your email';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Password reset failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update profile
  Future<bool> updateProfile(User updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.updateProfile(updatedUser);

      if (result.isSuccess) {
        _currentUser = result.data;
        await _localStorageService.saveUser(_currentUser!);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Profile update failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
