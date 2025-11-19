import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userKey = 'current_user';
  static const String _authTokenKey = 'auth_token';
  static const String _userTypeKey = 'user_type';
  static const String _recentSearchesKey = 'recent_searches';

  late SharedPreferences _prefs;

  static final LocalStorageService _instance =
      LocalStorageService._internal();

  factory LocalStorageService() {
    return _instance;
  }

  LocalStorageService._internal();

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save user
  Future<bool> saveUser(User user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      return await _prefs.setString(_userKey, userJson);
    } catch (e) {
      return false;
    }
  }

  // Get saved user
  User? getUser() {
    try {
      final userJson = _prefs.getString(_userKey);

      if (userJson == null) {
        return null;
      }

      final Map<String, dynamic> userMap = jsonDecode(userJson);
      return User.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  // Save auth token
  Future<bool> saveAuthToken(String token) async {
    try {
      return await _prefs.setString(_authTokenKey, token);
    } catch (e) {
      return false;
    }
  }

  // Get auth token
  String? getAuthToken() {
    try {
      return _prefs.getString(_authTokenKey);
    } catch (e) {
      return null;
    }
  }

  // Save user type
  Future<bool> saveUserType(String userType) async {
    try {
      return await _prefs.setString(_userTypeKey, userType);
    } catch (e) {
      return false;
    }
  }

  // Get user type
  String? getUserType() {
    try {
      return _prefs.getString(_userTypeKey);
    } catch (e) {
      return null;
    }
  }

  // Save recent search
  Future<bool> addRecentSearch(String query) async {
    try {
      final recent = _prefs.getStringList(_recentSearchesKey) ?? [];

      // Remove if already exists
      recent.remove(query);

      // Add to front
      recent.insert(0, query);

      // Keep only last 10 searches
      if (recent.length > 10) {
        recent.removeRange(10, recent.length);
      }

      return await _prefs.setStringList(_recentSearchesKey, recent);
    } catch (e) {
      return false;
    }
  }

  // Get recent searches
  List<String> getRecentSearches() {
    try {
      return _prefs.getStringList(_recentSearchesKey) ?? [];
    } catch (e) {
      return [];
    }
  }

  // Clear recent searches
  Future<bool> clearRecentSearches() async {
    try {
      return await _prefs.remove(_recentSearchesKey);
    } catch (e) {
      return false;
    }
  }

  // Clear all data (logout)
  Future<bool> clearAll() async {
    try {
      await _prefs.remove(_userKey);
      await _prefs.remove(_authTokenKey);
      await _prefs.remove(_userTypeKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Check if user is saved
  bool hasUser() {
    return _prefs.containsKey(_userKey);
  }
}
