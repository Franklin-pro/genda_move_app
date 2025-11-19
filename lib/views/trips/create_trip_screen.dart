import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/trip_view_model.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/utils.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({Key? key}) : super(key: key);

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _priceController = TextEditingController();
  final _seatsController = TextEditingController(text: '4');
  final _durationController = TextEditingController(text: '30');

  DateTime _departureDateTime = DateTime.now().add(const Duration(hours: 1));

  // Mock coordinates for demo
  double _startLat = -1.9483;
  double _startLon = 30.0619;
  double _endLat = -1.9465;
  double _endLon = 30.0645;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _priceController.dispose();
    _seatsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Trip'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // From location
                Text(
                  'Departure Location',
                  style: AppTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fromController,
                  decoration: InputDecoration(
                    hintText: 'Enter starting point',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Departure location is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // In real app, use geocoding to get coordinates
                  },
                ),
                const SizedBox(height: 16),

                // To location
                Text(
                  'Destination',
                  style: AppTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _toController,
                  decoration: InputDecoration(
                    hintText: 'Enter destination',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Destination is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // In real app, use geocoding to get coordinates
                  },
                ),
                const SizedBox(height: 16),

                // Departure date and time
                Text(
                  'Departure Date & Time',
                  style: AppTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.dividerColor),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  ),
                  child: ListTile(
                    onTap: () => _selectDateTime(context),
                    leading: const Icon(Icons.date_range),
                    title: Text(
                      AppUtils.formatDateTime(_departureDateTime),
                      style: AppTheme.bodyMedium,
                    ),
                    trailing: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                const SizedBox(height: 16),

                // Price per seat
                Text(
                  'Price per Seat (RWF)',
                  style: AppTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'e.g., 2500',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Price is required';
                    }
                    if (double.tryParse(value!) == null) {
                      return 'Enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Total seats
                Text(
                  'Total Seats',
                  style: AppTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _seatsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '4',
                    prefixIcon: const Icon(Icons.people),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Total seats is required';
                    }
                    if (int.tryParse(value!) == null || int.parse(value) < 1) {
                      return 'Enter a valid number of seats';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Estimated duration
                Text(
                  'Estimated Duration (minutes)',
                  style: AppTheme.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '30',
                    prefixIcon: const Icon(Icons.timer),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Duration is required';
                    }
                    if (double.tryParse(value!) == null) {
                      return 'Enter a valid duration';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Trip summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trip Summary',
                          style: AppTheme.labelLarge,
                        ),
                        const SizedBox(height: 12),
                        _SummaryRow(
                          label: 'From:',
                          value: _fromController.text.isEmpty
                              ? 'Not selected'
                              : _fromController.text,
                        ),
                        _SummaryRow(
                          label: 'To:',
                          value: _toController.text.isEmpty
                              ? 'Not selected'
                              : _toController.text,
                        ),
                        _SummaryRow(
                          label: 'Departure:',
                          value: AppUtils.formatDateTime(_departureDateTime),
                        ),
                        _SummaryRow(
                          label: 'Price/Seat:',
                          value: _priceController.text.isEmpty
                              ? 'Not set'
                              : AppUtils.formatCurrency(
                                  double.parse(_priceController.text)),
                        ),
                        _SummaryRow(
                          label: 'Total Seats:',
                          value: _seatsController.text,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Create button
                Consumer<TripViewModel>(
                  builder: (context, tripVM, _) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: tripVM.isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _createTrip(context, tripVM);
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
                            : const Text('Create Trip'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _departureDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      if (!mounted) return;
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_departureDateTime),
      );

      if (selectedTime != null) {
        setState(() {
          _departureDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _createTrip(BuildContext context, TripViewModel tripVM) async {
    final success = await tripVM.createTrip(
      startLocation: _fromController.text.trim(),
      endLocation: _toController.text.trim(),
      startLatitude: _startLat,
      startLongitude: _startLon,
      endLatitude: _endLat,
      endLongitude: _endLon,
      departureTime: _departureDateTime,
      pricePerSeat: double.parse(_priceController.text),
      totalSeats: int.parse(_seatsController.text),
      estimatedDuration: double.parse(_durationController.text),
    );

    if (success) {
      AppUtils.showSuccessSnackbar(context, 'Trip created successfully!');
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      AppUtils.showErrorSnackbar(
          context, tripVM.errorMessage ?? 'Failed to create trip');
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTheme.bodySmall),
          Text(
            value,
            style: AppTheme.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
