import 'package:uuid/uuid.dart';
import 'dart:math';
import 'user_model.dart';
import 'seat_request_model.dart';

class Trip {
  final String id;
  final User driver;
  final String startLocation;
  final String endLocation;
  final double startLatitude;
  final double startLongitude;
  final double endLatitude;
  final double endLongitude;
  final DateTime departureTime;
  final DateTime? arrivalTime;
  final double pricePerSeat;
  final int totalSeats;
  final int availableSeats;
  final List<User> passengers;
  final List<SeatRequest> seatRequests;
  final String status; // 'upcoming', 'ongoing', 'completed', 'cancelled'
  final String? routePolyline; // For displaying route on map
  final DateTime createdAt;
  final double estimatedDuration; // In minutes

  Trip({
    String? id,
    required this.driver,
    required this.startLocation,
    required this.endLocation,
    required this.startLatitude,
    required this.startLongitude,
    required this.endLatitude,
    required this.endLongitude,
    required this.departureTime,
    this.arrivalTime,
    required this.pricePerSeat,
    required this.totalSeats,
    required this.availableSeats,
    this.passengers = const [],
    this.seatRequests = const [],
    this.status = 'upcoming',
    this.routePolyline,
    DateTime? createdAt,
    this.estimatedDuration = 30.0,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // Calculate distance (simplified)
  double getDistanceInKm() {
    // Simplified calculation - in real app, use proper distance formula
    const double latChange = 111; // 1 degree latitude = ~111 km
    final double lat = (endLatitude - startLatitude).abs() * latChange;
    final double lon = (endLongitude - startLongitude).abs() * latChange;
    return sqrt(lat * lat + lon * lon);
  }

  // Convert Trip to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver': driver.toJson(),
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startLatitude': startLatitude,
      'startLongitude': startLongitude,
      'endLatitude': endLatitude,
      'endLongitude': endLongitude,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime?.toIso8601String(),
      'pricePerSeat': pricePerSeat,
      'totalSeats': totalSeats,
      'availableSeats': availableSeats,
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'seatRequests': seatRequests.map((r) => r.toJson()).toList(),
      'status': status,
      'routePolyline': routePolyline,
      'createdAt': createdAt.toIso8601String(),
      'estimatedDuration': estimatedDuration,
    };
  }

  // Create Trip from JSON
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      driver: User.fromJson(json['driver']),
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      startLatitude: (json['startLatitude'] as num).toDouble(),
      startLongitude: (json['startLongitude'] as num).toDouble(),
      endLatitude: (json['endLatitude'] as num).toDouble(),
      endLongitude: (json['endLongitude'] as num).toDouble(),
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.parse(json['arrivalTime'])
          : null,
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
      totalSeats: json['totalSeats'],
      availableSeats: json['availableSeats'],
      passengers: (json['passengers'] as List?)
              ?.map((p) => User.fromJson(p))
              .toList() ??
          [],
      seatRequests: (json['seatRequests'] as List?)
              ?.map((r) => SeatRequest.fromJson(r))
              .toList() ??
          [],
      status: json['status'] ?? 'upcoming',
      routePolyline: json['routePolyline'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      estimatedDuration: (json['estimatedDuration'] as num?)?.toDouble() ?? 30.0,
    );
  }

  // Copy with method
  Trip copyWith({
    String? id,
    User? driver,
    String? startLocation,
    String? endLocation,
    double? startLatitude,
    double? startLongitude,
    double? endLatitude,
    double? endLongitude,
    DateTime? departureTime,
    DateTime? arrivalTime,
    double? pricePerSeat,
    int? totalSeats,
    int? availableSeats,
    List<User>? passengers,
    List<SeatRequest>? seatRequests,
    String? status,
    String? routePolyline,
    DateTime? createdAt,
    double? estimatedDuration,
  }) {
    return Trip(
      id: id ?? this.id,
      driver: driver ?? this.driver,
      startLocation: startLocation ?? this.startLocation,
      endLocation: endLocation ?? this.endLocation,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      endLatitude: endLatitude ?? this.endLatitude,
      endLongitude: endLongitude ?? this.endLongitude,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      pricePerSeat: pricePerSeat ?? this.pricePerSeat,
      totalSeats: totalSeats ?? this.totalSeats,
      availableSeats: availableSeats ?? this.availableSeats,
      passengers: passengers ?? this.passengers,
      seatRequests: seatRequests ?? this.seatRequests,
      status: status ?? this.status,
      routePolyline: routePolyline ?? this.routePolyline,
      createdAt: createdAt ?? this.createdAt,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    );
  }
}
