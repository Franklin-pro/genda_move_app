import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../models/seat_request_model.dart';
import '../models/heatmap_point_model.dart';
import '../services/trip_service.dart';
import '../services/local_storage_service.dart';

class TripViewModel extends ChangeNotifier {
  final TripService _tripService = TripService();
  final LocalStorageService _localStorageService = LocalStorageService();

  List<Trip> _allTrips = [];
  List<Trip> _searchResults = [];
  Trip? _selectedTrip;
  List<Trip> _userTrips = [];
  List<HeatmapPoint> _heatmapData = [];
  List<SeatRequest> _pendingRequests = [];
  SeatRequest? _userRequestStatus;

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Trip> get allTrips => _allTrips;
  List<Trip> get searchResults => _searchResults;
  Trip? get selectedTrip => _selectedTrip;
  List<Trip> get userTrips => _userTrips;
  List<HeatmapPoint> get heatmapData => _heatmapData;
  List<SeatRequest> get pendingRequests => _pendingRequests;
  SeatRequest? get userRequestStatus => _userRequestStatus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Constructor
  TripViewModel() {
    loadAllTrips();
  }

  // Load all trips
  Future<void> loadAllTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _tripService.getAllTrips();

      if (result.isSuccess) {
        _allTrips = result.data ?? [];
        _searchResults = _allTrips;
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load trips: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search trips
  Future<void> searchTrips({
    required String startLocation,
    required String endLocation,
    DateTime? departureDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Save search to local storage
      await _localStorageService.addRecentSearch('$startLocation -> $endLocation');

      final result = await _tripService.searchTrips(
        startLocation: startLocation,
        endLocation: endLocation,
        departureDate: departureDate,
      );

      if (result.isSuccess) {
        _searchResults = result.data ?? [];
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Search failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get driver trips
  Future<void> loadUserTrips(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _tripService.getDriverTrips(userId);

      if (result.isSuccess) {
        _userTrips = result.data ?? [];
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load user trips: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create trip
  Future<bool> createTrip({
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _tripService.createTrip(
        startLocation: startLocation,
        endLocation: endLocation,
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
        departureTime: departureTime,
        pricePerSeat: pricePerSeat,
        totalSeats: totalSeats,
        estimatedDuration: estimatedDuration,
      );

      if (result.isSuccess) {
        _allTrips.add(result.data!);
        _searchResults = _allTrips;
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
      _errorMessage = 'Failed to create trip: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Join trip (wrapper for requestSeat for backward compatibility)
  Future<bool> joinTrip(String tripId) async {
    return requestSeat(tripId);
  }

  // Cancel trip
  Future<bool> cancelTrip(String tripId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _tripService.cancelTrip(tripId);

      if (result.isSuccess) {
        final index = _allTrips.indexWhere((t) => t.id == tripId);
        if (index != -1) {
          _allTrips[index] = result.data!;
          _searchResults = _allTrips;
        }

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
      _errorMessage = 'Failed to cancel trip: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Select trip for details
  void selectTrip(Trip trip) {
    _selectedTrip = trip;
    notifyListeners();
  }

  // Load heatmap data
  Future<void> loadHeatmapData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _tripService.getPassengerHeatmap();

      if (result.isSuccess) {
        _heatmapData = result.data ?? [];
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load heatmap: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get recent searches
  List<String> getRecentSearches() {
    return _localStorageService.getRecentSearches();
  }

  // Request a seat on a trip
  Future<bool> requestSeat(String tripId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _tripService.requestSeat(tripId);

      if (result.isSuccess) {
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
      _errorMessage = 'Failed to request seat: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get pending seat requests for a trip (driver view)
  Future<void> loadPendingRequests(String tripId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _tripService.getPendingRequests(tripId);

      if (result.isSuccess) {
        _pendingRequests = result.data ?? [];
        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to load pending requests: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Approve a seat request
  Future<bool> approveSeatRequest(String tripId, String seatRequestId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _tripService.approveSeatRequest(tripId, seatRequestId);

      if (result.isSuccess) {
        // Update the trip in the list
        final index = _allTrips.indexWhere((t) => t.id == tripId);
        if (index != -1) {
          _allTrips[index] = result.data!;
        }

        // Reload pending requests
        await loadPendingRequests(tripId);

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
      _errorMessage = 'Failed to approve request: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reject a seat request
  Future<bool> rejectSeatRequest(
      String tripId, String seatRequestId, String? reason) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result =
          await _tripService.rejectSeatRequest(tripId, seatRequestId, reason);

      if (result.isSuccess) {
        // Update the trip in the list
        final index = _allTrips.indexWhere((t) => t.id == tripId);
        if (index != -1) {
          _allTrips[index] = result.data!;
        }

        // Reload pending requests
        await loadPendingRequests(tripId);

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
      _errorMessage = 'Failed to reject request: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get passenger's request status for a trip
  Future<void> checkRequestStatus(String tripId, String passengerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result =
          await _tripService.getSeatRequestStatus(tripId, passengerId);

      if (result.isSuccess) {
        _userRequestStatus = result.data;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset a trip with new route
  Future<bool> resetTrip({
    required String tripId,
    required String newStartLocation,
    required String newEndLocation,
    required double newStartLat,
    required double newStartLon,
    required double newEndLat,
    required double newEndLon,
    required DateTime newDepartureTime,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _tripService.resetTrip(
        tripId: tripId,
        newStartLocation: newStartLocation,
        newEndLocation: newEndLocation,
        newStartLat: newStartLat,
        newStartLon: newStartLon,
        newEndLat: newEndLat,
        newEndLon: newEndLon,
        newDepartureTime: newDepartureTime,
      );

      if (result.isSuccess) {
        // Update the trip in the list
        final index = _allTrips.indexWhere((t) => t.id == tripId);
        if (index != -1) {
          _allTrips[index] = result.data!;
        }

        _selectedTrip = result.data;
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
      _errorMessage = 'Failed to reset trip: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
