import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/trip_view_model.dart';
import '../../common/app_theme.dart';

class PassengerHeatmapScreen extends StatefulWidget {
  const PassengerHeatmapScreen({Key? key}) : super(key: key);

  @override
  State<PassengerHeatmapScreen> createState() => _PassengerHeatmapScreenState();
}

class _PassengerHeatmapScreenState extends State<PassengerHeatmapScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripViewModel>().loadHeatmapData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Heatmap'),
      ),
      body: Consumer<TripViewModel>(
        builder: (context, tripVM, _) {
          if (tripVM.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (tripVM.heatmapData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No heatmap data available',
                    style: AppTheme.headingSmall,
                  ),
                ],
              ),
            );
          }

          // Get max passenger count for scaling
          final maxPassengers = tripVM.heatmapData
              .fold<int>(0, (max, point) => point.passengerCount > max ? point.passengerCount : max);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Info banner
                Container(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Red = High demand, Blue = Low demand',
                          style: AppTheme.bodySmall
                              .copyWith(color: AppTheme.primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),

                // Heatmap visualization
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Passenger Density by Location',
                        style: AppTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                        itemCount: tripVM.heatmapData.length,
                        itemBuilder: (context, index) {
                          final point = tripVM.heatmapData[index];
                          final intensity = point.getIntensity(maxPassengers);

                          return HeatmapTile(
                            point: point,
                            intensity: intensity,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Legend
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Intensity Scale',
                        style: AppTheme.labelLarge,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.dividerColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _IntensityLegend(
                              color: AppTheme.heatmapWarm,
                              label: 'Very High (${maxPassengers}+)',
                              intensity: 1.0,
                            ),
                            _IntensityLegend(
                              color: AppTheme.heatmapMid,
                              label: 'High (${(maxPassengers * 0.75).toStringAsFixed(0)}+)',
                              intensity: 0.75,
                            ),
                            _IntensityLegend(
                              color: Color.lerp(
                                AppTheme.heatmapMid,
                                AppTheme.heatmapCold,
                                0.5,
                              )!,
                              label: 'Medium (${(maxPassengers * 0.5).toStringAsFixed(0)}+)',
                              intensity: 0.5,
                            ),
                            _IntensityLegend(
                              color: AppTheme.heatmapCold,
                              label: 'Low',
                              intensity: 0.25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Detailed list
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detailed Data',
                        style: AppTheme.labelLarge,
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tripVM.heatmapData.length,
                        itemBuilder: (context, index) {
                          final point = tripVM.heatmapData[index];
                          final intensity = point.getIntensity(maxPassengers);

                          return Card(
                            child: ListTile(
                              leading: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _getIntensityColor(intensity),
                                ),
                              ),
                              title: Text(
                                point.locationName,
                                style: AppTheme.labelMedium,
                              ),
                              subtitle: Text(
                                '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
                                style: AppTheme.bodySmall,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${point.passengerCount}',
                                    style: AppTheme.labelMedium
                                        .copyWith(color: AppTheme.primaryColor),
                                  ),
                                  Text(
                                    'passengers',
                                    style: AppTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getIntensityColor(double intensity) {
    if (intensity >= 0.75) {
      return AppTheme.heatmapWarm;
    } else if (intensity >= 0.5) {
      return AppTheme.heatmapMid;
    } else if (intensity >= 0.25) {
      return Color.lerp(AppTheme.heatmapMid, AppTheme.heatmapCold, 0.5)!;
    } else {
      return AppTheme.heatmapCold;
    }
  }
}

class HeatmapTile extends StatelessWidget {
  final dynamic point;
  final double intensity;

  const HeatmapTile({
    required this.point,
    required this.intensity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getIntensityColor(intensity);

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.6),
            ),
            child: Center(
              child: Text(
                point.passengerCount.toString(),
                style: AppTheme.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              point.locationName,
              style: AppTheme.bodySmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getIntensityColor(double intensity) {
    if (intensity >= 0.75) {
      return AppTheme.heatmapWarm;
    } else if (intensity >= 0.5) {
      return AppTheme.heatmapMid;
    } else if (intensity >= 0.25) {
      return Color.lerp(AppTheme.heatmapMid, AppTheme.heatmapCold, 0.5)!;
    } else {
      return AppTheme.heatmapCold;
    }
  }
}

class _IntensityLegend extends StatelessWidget {
  final Color color;
  final String label;
  final double intensity;

  const _IntensityLegend({
    required this.color,
    required this.label,
    required this.intensity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.7),
              border: Border.all(color: color),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
