import 'package:uuid/uuid.dart';

class HeatmapPoint {
  final String id;
  final double latitude;
  final double longitude;
  final int passengerCount;
  final String locationName;
  final DateTime lastUpdated;

  HeatmapPoint({
    String? id,
    required this.latitude,
    required this.longitude,
    required this.passengerCount,
    required this.locationName,
    DateTime? lastUpdated,
  })  : id = id ?? const Uuid().v4(),
        lastUpdated = lastUpdated ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'passengerCount': passengerCount,
      'locationName': locationName,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Create from JSON
  factory HeatmapPoint.fromJson(Map<String, dynamic> json) {
    return HeatmapPoint(
      id: json['id'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      passengerCount: json['passengerCount'],
      locationName: json['locationName'],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  // Get intensity (0.0 to 1.0) based on passenger count
  double getIntensity(int maxPassengers) {
    return (passengerCount / maxPassengers).clamp(0.0, 1.0);
  }
}
