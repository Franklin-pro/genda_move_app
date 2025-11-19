import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String userType; // 'driver' or 'passenger'
  final double rating;
  final int reviewCount;
  final bool isVerified;
  final double latitude;
  final double longitude;
  final String vehicleType; // For drivers
  final String licensePlate; // For drivers
  final int totalTrips;

  User({
    String? id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage = '',
    required this.userType,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVerified = false,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.vehicleType = '',
    this.licensePlate = '',
    this.totalTrips = 0,
  }) : id = id ?? const Uuid().v4();

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'userType': userType,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVerified': isVerified,
      'latitude': latitude,
      'longitude': longitude,
      'vehicleType': vehicleType,
      'licensePlate': licensePlate,
      'totalTrips': totalTrips,
    };
  }

  // Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'] ?? '',
      userType: json['userType'],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      vehicleType: json['vehicleType'] ?? '',
      licensePlate: json['licensePlate'] ?? '',
      totalTrips: json['totalTrips'] ?? 0,
    );
  }

  // Create a copy of User with updated fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? userType,
    double? rating,
    int? reviewCount,
    bool? isVerified,
    double? latitude,
    double? longitude,
    String? vehicleType,
    String? licensePlate,
    int? totalTrips,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      userType: userType ?? this.userType,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isVerified: isVerified ?? this.isVerified,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      vehicleType: vehicleType ?? this.vehicleType,
      licensePlate: licensePlate ?? this.licensePlate,
      totalTrips: totalTrips ?? this.totalTrips,
    );
  }
}
