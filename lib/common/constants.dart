class AppConstants {
  // App name
  static const String appName = 'Lifuti';

  // API Base URL (mock)
  static const String apiBaseUrl = 'https://api.lifuti.com/v1';

  // User types
  static const String userTypeDriver = 'driver';
  static const String userTypePassenger = 'passenger';

  // Trip statuses
  static const String tripStatusUpcoming = 'upcoming';
  static const String tripStatusOngoing = 'ongoing';
  static const String tripStatusCompleted = 'completed';
  static const String tripStatusCancelled = 'cancelled';

  // Location precision
  static const double defaultLatitude = -1.9483;
  static const double defaultLongitude = 30.0619;

  // Kigali Rwanda bounds
  static const double kigaliMinLat = -2.0;
  static const double kigaliMaxLat = -1.9;
  static const double kigaliMinLon = 29.9;
  static const double kigaliMaxLon = 30.2;

  // Default values
  static const int defaultPageSize = 20;
  static const int defaultTimeoutSeconds = 30;

  // Demo credentials
  static const String demoDriverEmail = 'driver@test.com';
  static const String demoDriverPassword = 'password';
  static const String demoPassengerEmail = 'passenger@test.com';
  static const String demoPassengerPassword = 'password';
}

class AppText {
  // Navigation
  static const String appName = 'Lifuti';
  static const String home = 'Home';
  static const String trips = 'Trips';
  static const String heatmap = 'Heatmap';
  static const String profile = 'Profile';

  // Auth screens
  static const String login = 'Login';
  static const String signup = 'Sign Up';
  static const String forgotPassword = 'Forgot Password';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String name = 'Name';
  static const String phone = 'Phone';
  static const String loginAsDriver = 'Login as Driver';
  static const String loginAsPassenger = 'Login as Passenger';

  // Trip related
  static const String from = 'From';
  static const String to = 'To';
  static const String departureTime = 'Departure Time';
  static const String pricePerSeat = 'Price per Seat';
  static const String totalSeats = 'Total Seats';
  static const String availableSeats = 'Available Seats';
  static const String driver = 'Driver';
  static const String createTrip = 'Create Trip';
  static const String joinTrip = 'Join Trip';
  static const String cancelTrip = 'Cancel Trip';
  static const String searchTrips = 'Search Trips';

  // Common
  static const String loading = 'Loading...';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String noData = 'No data available';
  static const String logout = 'Logout';
  static const String settings = 'Settings';
  static const String about = 'About';
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 16.0;

  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
}
