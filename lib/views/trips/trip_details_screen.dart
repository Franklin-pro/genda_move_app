import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/trip_model.dart';
import '../../view_models/trip_view_model.dart';
import '../../view_models/auth_view_model.dart';
import '../../common/app_theme.dart';
import '../../common/utils.dart';

class TripDetailsScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailsScreen({
    required this.trip,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route Card
            Container(
              color: AppTheme.primaryColor,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // From location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From',
                              style: AppTheme.bodySmall
                                  .copyWith(color: Colors.white70),
                            ),
                            Text(
                              trip.startLocation,
                              style: AppTheme.labelLarge
                                  .copyWith(color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.white30,
                  ),

                  const SizedBox(height: 20),

                  // To location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'To',
                              style: AppTheme.bodySmall
                                  .copyWith(color: Colors.white70),
                            ),
                            Text(
                              trip.endLocation,
                              style: AppTheme.labelLarge
                                  .copyWith(color: Colors.white),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Trip info row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppUtils.formatTime(trip.departureTime),
                            style: AppTheme.labelMedium
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            AppUtils.formatDate(trip.departureTime),
                            style:
                                AppTheme.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Icon(
                            Icons.straighten,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${trip.getDistanceInKm().toStringAsFixed(1)} km',
                            style: AppTheme.labelMedium
                                .copyWith(color: Colors.white),
                          ),
                          Text(
                            '${trip.estimatedDuration.toStringAsFixed(0)} min',
                            style:
                                AppTheme.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Driver info
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver',
                    style: AppTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        trip.driver.name,
                        style: AppTheme.labelLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            trip.driver.vehicleType,
                            style: AppTheme.bodySmall,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${trip.driver.rating} (${trip.driver.reviewCount} reviews)',
                                style: AppTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () {
                          AppUtils.showSnackbar(
                            context,
                            'Call feature coming soon',
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pricing and availability
                  Text(
                    'Price & Availability',
                    style: AppTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price per Seat',
                            style: AppTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppUtils.formatCurrency(trip.pricePerSeat),
                            style: AppTheme.headingSmall
                                .copyWith(color: AppTheme.primaryColor),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Available Seats',
                            style: AppTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${trip.availableSeats} of ${trip.totalSeats}',
                            style: AppTheme.headingSmall
                                .copyWith(color: AppTheme.primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Passengers
                  if (trip.passengers.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Passengers (${trip.passengers.length})',
                          style: AppTheme.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: trip.passengers.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppTheme.primaryColor,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Expanded(
                                  child: Text(
                                    trip.passengers[index].name,
                                    style: AppTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),

                  // Trip status
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(trip.status).withOpacity(0.1),
                      border: Border.all(
                        color: _getStatusColor(trip.status),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getStatusIcon(trip.status),
                          color: _getStatusColor(trip.status),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Status: ${trip.status.toUpperCase()}',
                          style: AppTheme.labelMedium.copyWith(
                            color: _getStatusColor(trip.status),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24),
        child: Consumer2<TripViewModel, AuthViewModel>(
          builder: (context, tripVM, authVM, _) {
            final isDriver = authVM.currentUser?.userType == 'driver';
            final isJoined =
                trip.passengers.any((p) => p.id == authVM.currentUser?.id);
            final isTripFull = trip.availableSeats <= 0;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: tripVM.isLoading || isTripFull && !isJoined
                    ? null
                    : () {
                        if (isJoined) {
                          AppUtils.showSnackbar(
                            context,
                            'You have already joined this trip',
                          );
                        } else if (isDriver) {
                          AppUtils.showSnackbar(
                            context,
                            'Drivers cannot join trips',
                          );
                        } else {
                          _joinTrip(context, tripVM);
                        }
                      },
                child: tripVM.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        isJoined
                            ? 'Already Joined'
                            : isTripFull
                                ? 'No Seats Available'
                                : 'Join Trip',
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return Colors.blue;
      case 'ongoing':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'upcoming':
        return Icons.schedule;
      case 'ongoing':
        return Icons.directions_run;
      case 'completed':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Future<void> _joinTrip(BuildContext context, TripViewModel tripVM) async {
    final success = await tripVM.joinTrip(trip.id);

    if (success) {
      AppUtils.showSuccessSnackbar(context, 'Successfully joined the trip!');
    } else {
      AppUtils.showErrorSnackbar(
        context,
        tripVM.errorMessage ?? 'Failed to join trip',
      );
    }
  }
}
