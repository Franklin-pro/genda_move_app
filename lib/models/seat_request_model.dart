import 'package:uuid/uuid.dart';
import 'user_model.dart';

class SeatRequest {
  final String id;
  final String tripId;
  final User passenger;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime requestedAt;
  final DateTime? reviewedAt;
  final String? rejectionReason;

  SeatRequest({
    String? id,
    required this.tripId,
    required this.passenger,
    this.status = 'pending',
    DateTime? requestedAt,
    this.reviewedAt,
    this.rejectionReason,
  })  : id = id ?? const Uuid().v4(),
        requestedAt = requestedAt ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'passenger': passenger.toJson(),
      'status': status,
      'requestedAt': requestedAt.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'rejectionReason': rejectionReason,
    };
  }

  // Create from JSON
  factory SeatRequest.fromJson(Map<String, dynamic> json) {
    return SeatRequest(
      id: json['id'],
      tripId: json['tripId'],
      passenger: User.fromJson(json['passenger']),
      status: json['status'] ?? 'pending',
      requestedAt: json['requestedAt'] != null
          ? DateTime.parse(json['requestedAt'])
          : DateTime.now(),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'])
          : null,
      rejectionReason: json['rejectionReason'],
    );
  }

  // Copy with
  SeatRequest copyWith({
    String? id,
    String? tripId,
    User? passenger,
    String? status,
    DateTime? requestedAt,
    DateTime? reviewedAt,
    String? rejectionReason,
  }) {
    return SeatRequest(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      passenger: passenger ?? this.passenger,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
