import 'dart:math';
import '../models/trip_model.dart';
import '../models/user_model.dart';
import '../models/seat_request_model.dart';
import '../models/heatmap_point_model.dart';
import 'auth_service.dart';

class TripService {
  static final List<Trip> _mockTrips = [];
  static final Random _random = Random();

  // Initialize mock trips
  static void initializeMockTrips() {
    if (_mockTrips.isNotEmpty) return;

    final driver1 = User(
      id: 'driver1',
      name: 'John Doe',
      email: 'driver@test.com',
      phone: '+250788123456',
      userType: 'driver',
      rating: 4.8,
      reviewCount: 125,
      isVerified: true,
      latitude: -1.9483,
      longitude: 30.0619,
      vehicleType: 'Toyota Corolla',
      licensePlate: 'RAK123A',
      totalTrips: 250,
    );

    final driver2 = User(
      id: 'driver2',
      name: 'Mike Johnson',
      email: 'driver2@test.com',
      phone: '+250788234567',
      userType: 'driver',
      rating: 4.6,
      reviewCount: 98,
      isVerified: true,
      latitude: -1.9465,
      longitude: 30.0645,
      vehicleType: 'Nissan Note',
      licensePlate: 'RAK456B',
      totalTrips: 180,
    );

    // Create sample trips
    _mockTrips.addAll([
      Trip(
        driver: driver1,
        startLocation: 'Kigali City Center',
        endLocation: 'Kigali International Airport',
        startLatitude: -1.9483,
        startLongitude: 30.0619,
        endLatitude: -1.9731,
        endLongitude: 30.1416,
        departureTime: DateTime.now().add(const Duration(hours: 2)),
        pricePerSeat: 2500,
        totalSeats: 4,
        availableSeats: 2,
        passengers: [],
        status: 'upcoming',
        estimatedDuration: 25,
      ),
      Trip(
        driver: driver2,
        startLocation: 'Nyamirambo Market',
        endLocation: 'Kigali International Airport',
        startLatitude: -1.9465,
        startLongitude: 30.0645,
        endLatitude: -1.9731,
        endLongitude: 30.1416,
        departureTime: DateTime.now().add(const Duration(hours: 1, minutes: 30)),
        pricePerSeat: 2700,
        totalSeats: 5,
        availableSeats: 3,
        passengers: [],
        status: 'upcoming',
        estimatedDuration: 30,
      ),
      Trip(
        driver: driver1,
        startLocation: 'Huye Town',
        endLocation: 'Kigali City Center',
        startLatitude: -2.6049,
        startLongitude: 29.7412,
        endLatitude: -1.9483,
        endLongitude: 30.0619,
        departureTime: DateTime.now().add(const Duration(days: 1)),
        pricePerSeat: 5000,
        totalSeats: 3,
        availableSeats: 1,
        passengers: [],
        status: 'upcoming',
        estimatedDuration: 120,
      ),
    ]);
  }

  // Get all trips
  Future<Result<List<Trip>>> getAllTrips() async {
    try {
      initializeMockTrips();
      await Future.delayed(const Duration(milliseconds: 500));
      return Result.success(_mockTrips);
    } catch (e) {
      return Result.error('Failed to fetch trips: $e');
    }
  }

  // Search trips by location
  Future<Result<List<Trip>>> searchTrips({
    required String startLocation,
    required String endLocation,
    DateTime? departureDate,
  }) async {
    try {
      initializeMockTrips();
      await Future.delayed(const Duration(milliseconds: 800));

      var results = _mockTrips.where((trip) {
        final startMatch =
            trip.startLocation.toLowerCase().contains(startLocation.toLowerCase());
        final endMatch =
            trip.endLocation.toLowerCase().contains(endLocation.toLowerCase());

        if (!startMatch || !endMatch) return false;

        if (departureDate != null) {
          final tripDate = DateTime(trip.departureTime.year,
              trip.departureTime.month, trip.departureTime.day);
          final searchDate = DateTime(departureDate.year, departureDate.month,
              departureDate.day);
          return tripDate == searchDate;
        }

        return true;
      }).toList();

      return Result.success(results);
    } catch (e) {
      return Result.error('Search failed: $e');
    }
  }

  // Get trips by driver
  Future<Result<List<Trip>>> getDriverTrips(String driverId) async {
    try {
      initializeMockTrips();
      await Future.delayed(const Duration(milliseconds: 500));

      final driverTrips =
          _mockTrips.where((trip) => trip.driver.id == driverId).toList();
      return Result.success(driverTrips);
    } catch (e) {
      return Result.error('Failed to fetch driver trips: $e');
    }
  }

  // Create a new trip
  Future<Result<Trip>> createTrip({
    required String startLocation,
    required String endLocation,
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
    required DateTime departureTime,
    required double pricePerSeat,
    required int totalSeats,
    required double estimatedDuration,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      final authService = AuthService();
      final currentUser = authService.getCurrentUser();

      if (currentUser == null || currentUser.userType != 'driver') {
        return Result.error('Only drivers can create trips');
      }

      final newTrip = Trip(
        driver: currentUser,
        startLocation: startLocation,
        endLocation: endLocation,
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
        departureTime: departureTime,
        pricePerSeat: pricePerSeat,
        totalSeats: totalSeats,
        availableSeats: totalSeats,
        estimatedDuration: estimatedDuration,
      );

      initializeMockTrips();
      _mockTrips.add(newTrip);

      return Result.success(newTrip);
    } catch (e) {
      return Result.error('Failed to create trip: $e');
    }
  }

  // Join a trip as passenger (create seat request)
  Future<Result<SeatRequest>> requestSeat(String tripId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final authService = AuthService();
      final currentUser = authService.getCurrentUser();

      if (currentUser == null) {
        return Result.error('User not logged in');
      }

      final tripIndex =
          _mockTrips.indexWhere((trip) => trip.id == tripId);

      if (tripIndex == -1) {
        return Result.error('Trip not found');
      }

      final trip = _mockTrips[tripIndex];

      // Check if already requested
      if (trip.seatRequests.any((r) =>
          r.passenger.id == currentUser.id &&
          r.status == 'pending')) {
        return Result.error('Already requested a seat for this trip');
      }

      // Check if already approved
      if (trip.passengers.any((p) => p.id == currentUser.id)) {
        return Result.error('Already joined this trip');
      }

      final seatRequest = SeatRequest(
        tripId: tripId,
        passenger: currentUser,
        status: 'pending',
      );

      final updatedTrip = trip.copyWith(
        seatRequests: [...trip.seatRequests, seatRequest],
      );

      _mockTrips[tripIndex] = updatedTrip;

      return Result.success(seatRequest);
    } catch (e) {
      return Result.error('Failed to request seat: $e');
    }
  }

  // Approve a seat request
  Future<Result<Trip>> approveSeatRequest(
      String tripId, String seatRequestId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final tripIndex =
          _mockTrips.indexWhere((trip) => trip.id == tripId);

      if (tripIndex == -1) {
        return Result.error('Trip not found');
      }

      final trip = _mockTrips[tripIndex];

      // Find the request
      final requestIndex = trip.seatRequests
          .indexWhere((r) => r.id == seatRequestId);

      if (requestIndex == -1) {
        return Result.error('Seat request not found');
      }

      if (trip.availableSeats <= 0) {
        return Result.error('No available seats');
      }

      final request = trip.seatRequests[requestIndex];

      // Update request status
      final updatedRequest = request.copyWith(
        status: 'approved',
        reviewedAt: DateTime.now(),
      );

      final updatedRequests = [...trip.seatRequests];
      updatedRequests[requestIndex] = updatedRequest;

      // Add to approved passengers
      final updatedTrip = trip.copyWith(
        seatRequests: updatedRequests,
        passengers: [...trip.passengers, request.passenger],
        availableSeats: trip.availableSeats - 1,
      );

      _mockTrips[tripIndex] = updatedTrip;

      return Result.success(updatedTrip);
    } catch (e) {
      return Result.error('Failed to approve seat request: $e');
    }
  }

  // Reject a seat request
  Future<Result<Trip>> rejectSeatRequest(
      String tripId, String seatRequestId, String? reason) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final tripIndex =
          _mockTrips.indexWhere((trip) => trip.id == tripId);

      if (tripIndex == -1) {
        return Result.error('Trip not found');
      }

      final trip = _mockTrips[tripIndex];

      // Find the request
      final requestIndex = trip.seatRequests
          .indexWhere((r) => r.id == seatRequestId);

      if (requestIndex == -1) {
        return Result.error('Seat request not found');
      }

      final request = trip.seatRequests[requestIndex];

      // Update request status
      final updatedRequest = request.copyWith(
        status: 'rejected',
        reviewedAt: DateTime.now(),
        rejectionReason: reason ?? 'Rejected by driver',
      );

      final updatedRequests = [...trip.seatRequests];
      updatedRequests[requestIndex] = updatedRequest;

      final updatedTrip = trip.copyWith(
        seatRequests: updatedRequests,
      );

      _mockTrips[tripIndex] = updatedTrip;

      return Result.success(updatedTrip);
    } catch (e) {
      return Result.error('Failed to reject seat request: $e');
    }
  }

  // Get pending seat requests for a trip
  Future<Result<List<SeatRequest>>> getPendingRequests(String tripId) async {
    try {
      initializeMockTrips();
      await Future.delayed(const Duration(milliseconds: 300));

      final trip = _mockTrips.firstWhere(
        (t) => t.id == tripId,
        orElse: () => throw Exception('Trip not found'),
      );

      final pending = trip.seatRequests
          .where((r) => r.status == 'pending')
          .toList();

      return Result.success(pending);
    } catch (e) {
      return Result.error('Failed to get pending requests: $e');
    }
  }

  // Get seat request status for passenger
  Future<Result<SeatRequest?>> getSeatRequestStatus(
      String tripId, String passengerId) async {
    try {
      initializeMockTrips();
      await Future.delayed(const Duration(milliseconds: 300));

      final trip = _mockTrips.firstWhere(
        (t) => t.id == tripId,
        orElse: () => throw Exception('Trip not found'),
      );

      final request = trip.seatRequests.firstWhere(
        (r) => r.passenger.id == passengerId,
        orElse: () => throw Exception('No request found'),
      );

      return Result.success(request);
    } catch (e) {
      return Result.success(null);
    }
  }

  // Reset trip (change route while maintaining bookings)
  Future<Result<Trip>> resetTrip({
    required String tripId,
    required String newStartLocation,
    required String newEndLocation,
    required double newStartLat,
    required double newStartLon,
    required double newEndLat,
    required double newEndLon,
    required DateTime newDepartureTime,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final tripIndex =
          _mockTrips.indexWhere((trip) => trip.id == tripId);

      if (tripIndex == -1) {
        return Result.error('Trip not found');
      }

      final trip = _mockTrips[tripIndex];

      // Reset all pending requests to pending status
      final resetRequests = trip.seatRequests.map((r) {
        if (r.status == 'pending') {
          return r;
        } else {
          // Re-enable approved requests for re-approval
          return r.copyWith(
            status: 'pending',
            reviewedAt: null,
            rejectionReason: null,
          );
        }
      }).toList();

      final updatedTrip = trip.copyWith(
        startLocation: newStartLocation,
        endLocation: newEndLocation,
        startLatitude: newStartLat,
        startLongitude: newStartLon,
        endLatitude: newEndLat,
        endLongitude: newEndLon,
        departureTime: newDepartureTime,
        availableSeats: trip.totalSeats,
        passengers: [],
        seatRequests: resetRequests,
      );

      _mockTrips[tripIndex] = updatedTrip;

      return Result.success(updatedTrip);
    } catch (e) {
      return Result.error('Failed to reset trip: $e');
    }
  }

  // Cancel trip
  Future<Result<Trip>> cancelTrip(String tripId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final tripIndex =
          _mockTrips.indexWhere((trip) => trip.id == tripId);

      if (tripIndex == -1) {
        return Result.error('Trip not found');
      }

      final trip = _mockTrips[tripIndex];
      final updatedTrip = trip.copyWith(status: 'cancelled');
      _mockTrips[tripIndex] = updatedTrip;

      return Result.success(updatedTrip);
    } catch (e) {
      return Result.error('Failed to cancel trip: $e');
    }
  }

  // Get passenger heatmap data
  Future<Result<List<HeatmapPoint>>> getPassengerHeatmap() async {
    try {
      initializeMockTrips();
      await Future.delayed(const Duration(milliseconds: 800));

      // Generate mock heatmap data based on trip locations
      final Map<String, HeatmapPoint> heatmapMap = {};

      for (var trip in _mockTrips) {
        // Add start location heat
        final startKey =
            '${trip.startLatitude.toStringAsFixed(2)}_${trip.startLongitude.toStringAsFixed(2)}';

        if (heatmapMap.containsKey(startKey)) {
          final existing = heatmapMap[startKey]!;
          heatmapMap[startKey] = HeatmapPoint(
            id: existing.id,
            latitude: existing.latitude,
            longitude: existing.longitude,
            passengerCount: existing.passengerCount + 2 + _random.nextInt(5),
            locationName: trip.startLocation,
          );
        } else {
          heatmapMap[startKey] = HeatmapPoint(
            latitude: trip.startLatitude,
            longitude: trip.startLongitude,
            passengerCount: 5 + _random.nextInt(15),
            locationName: trip.startLocation,
          );
        }
      }

      return Result.success(heatmapMap.values.toList());
    } catch (e) {
      return Result.error('Failed to fetch heatmap: $e');
    }
  }
}

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
