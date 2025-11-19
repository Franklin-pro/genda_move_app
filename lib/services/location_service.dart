import 'package:geolocator/geolocator.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();

  // Request location permissions
  Future<bool> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return false;
      } else if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }

  // Get current position
  Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await requestLocationPermission();

      if (!hasPermission) {
        return null;
      }

      final isServiceEnabled = await isLocationServiceEnabled();

      if (!isServiceEnabled) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      return null;
    }
  }

  // Stream position updates
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream();
  }

  // Calculate distance between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Calculate bearing between two coordinates
  double calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.bearingBetween(lat1, lon1, lat2, lon2);
  }
}
