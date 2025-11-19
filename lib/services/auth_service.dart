import '../models/user_model.dart';

class AuthService {
  // Mock user database
  static final Map<String, User> _mockUsers = {
    'driver@test.com': User(
      id: 'driver1',
      name: 'John Doe',
      email: 'driver@test.com',
      phone: '+250788123456',
      userType: 'driver',
      profileImage: '',
      rating: 4.8,
      reviewCount: 125,
      isVerified: true,
      latitude: -1.9483,
      longitude: 30.0619,
      vehicleType: 'Toyota Corolla',
      licensePlate: 'RAK123A',
      totalTrips: 250,
    ),
    'passenger@test.com': User(
      id: 'passenger1',
      name: 'Jane Smith',
      email: 'passenger@test.com',
      phone: '+250788654321',
      userType: 'passenger',
      profileImage: '',
      rating: 4.9,
      reviewCount: 45,
      isVerified: true,
      latitude: -1.9465,
      longitude: 30.0645,
      totalTrips: 125,
    ),
  };

  static User? _currentUser;

  // Login
  Future<Result<User>> login(String email, String password) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (!email.contains('@')) {
        return Result.error('Invalid email format');
      }

      if (password.length < 6) {
        return Result.error('Password must be at least 6 characters');
      }

      // Check if user exists in mock database
      if (_mockUsers.containsKey(email)) {
        _currentUser = _mockUsers[email]!;
        return Result.success(_currentUser!);
      }

      return Result.error('User not found. Use driver@test.com or passenger@test.com');
    } catch (e) {
      return Result.error('Login failed: $e');
    }
  }

  // Register/Sign up
  Future<Result<User>> signup({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String userType,
    String? vehicleType,
    String? licensePlate,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (!email.contains('@')) {
        return Result.error('Invalid email format');
      }

      if (password.length < 6) {
        return Result.error('Password must be at least 6 characters');
      }

      if (name.isEmpty) {
        return Result.error('Name cannot be empty');
      }

      // Check if user already exists
      if (_mockUsers.containsKey(email)) {
        return Result.error('User already registered with this email');
      }

      // Create new user
      final newUser = User(
        name: name,
        email: email,
        phone: phone,
        userType: userType,
        vehicleType: vehicleType ?? '',
        licensePlate: licensePlate ?? '',
      );

      // Add to mock database
      _mockUsers[email] = newUser;
      _currentUser = newUser;

      return Result.success(newUser);
    } catch (e) {
      return Result.error('Signup failed: $e');
    }
  }

  // Logout
  Future<Result<void>> logout() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _currentUser = null;
      return Result.success(null);
    } catch (e) {
      return Result.error('Logout failed: $e');
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _currentUser;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _currentUser != null;
  }

  // Reset password
  Future<Result<void>> resetPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!_mockUsers.containsKey(email)) {
        return Result.error('User not found');
      }

      // In real app, send reset email
      return Result.success(null);
    } catch (e) {
      return Result.error('Password reset failed: $e');
    }
  }

  // Update user profile
  Future<Result<User>> updateProfile(User updatedUser) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (_currentUser == null) {
        return Result.error('No user logged in');
      }

      _currentUser = updatedUser;
      _mockUsers[updatedUser.email] = updatedUser;

      return Result.success(updatedUser);
    } catch (e) {
      return Result.error('Profile update failed: $e');
    }
  }
}

// Generic Result class for API responses
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result._({required this.data, required this.error, required this.isSuccess});

  factory Result.success(T data) {
    return Result._(data: data, error: null, isSuccess: true);
  }

  factory Result.error(String errorMessage) {
    return Result._(data: null, error: errorMessage, isSuccess: false);
  }
}
