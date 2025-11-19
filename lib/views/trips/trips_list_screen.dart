import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/trip_view_model.dart';
import '../../view_models/auth_view_model.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/utils.dart';
import 'create_trip_screen.dart';
import 'trip_details_screen.dart';

class TripsListScreen extends StatefulWidget {
  const TripsListScreen({Key? key}) : super(key: key);

  @override
  State<TripsListScreen> createState() => _TripsListScreenState();
}

class _TripsListScreenState extends State<TripsListScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripViewModel>().loadAllTrips();
    });
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Trips'),
      ),
      body: Column(
        children: [
          // Search section
          Container(
            color: AppTheme.primaryColor,
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              children: [
                // From field
                TextField(
                  controller: _fromController,
                  decoration: InputDecoration(
                    hintText: 'From',
                    prefixIcon: const Icon(Icons.location_on),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // To field
                TextField(
                  controller: _toController,
                  decoration: InputDecoration(
                    hintText: 'To',
                    prefixIcon: const Icon(Icons.location_on),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Search button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.search),
                    label: const Text('Search Trips'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryDark,
                    ),
                    onPressed: () {
                      _searchTrips();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Trips list
          Expanded(
            child: Consumer<TripViewModel>(
              builder: (context, tripVM, _) {
                if (tripVM.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (tripVM.searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.textSecondaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No trips available',
                          style: AppTheme.headingSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search',
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                  itemCount: tripVM.searchResults.length,
                  itemBuilder: (context, index) {
                    final trip = tripVM.searchResults[index];
                    return TripCard(
                      trip: trip,
                      onTap: () {
                        tripVM.selectTrip(trip);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TripDetailsScreen(trip: trip),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          if (authVM.currentUser?.userType == AppConstants.userTypeDriver) {
            return FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text('Create Trip'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateTripScreen(),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _searchTrips() {
    context.read<TripViewModel>().searchTrips(
          startLocation: _fromController.text,
          endLocation: _toController.text,
        );
  }
}

class TripCard extends StatelessWidget {
  final trip;
  final VoidCallback onTap;

  const TripCard({
    required this.trip,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          child: Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trip.startLocation,
              style: AppTheme.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Icon(
              Icons.arrow_downward,
              size: 16,
              color: AppTheme.textSecondaryColor,
            ),
            Text(
              trip.endLocation,
              style: AppTheme.labelLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Driver: ${trip.driver.name}',
              style: AppTheme.bodySmall,
            ),
            Text(
              '${trip.availableSeats} seats available',
              style: AppTheme.bodySmall,
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              AppUtils.formatCurrency(trip.pricePerSeat),
              style: AppTheme.labelLarge
                  .copyWith(color: AppTheme.primaryColor),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  size: 16,
                  color: Colors.orange,
                ),
                const SizedBox(width: 4),
                Text(
                  '${trip.driver.rating}',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
