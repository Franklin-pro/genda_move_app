import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../../common/constants.dart';
import '../trips/trips_list_screen.dart';
import '../heatmap/passenger_heatmap_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TripsListScreen(),
    const PassengerHeatmapScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          // Redirect to login if not authenticated
          if (!authVM.isLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (route) => false);
            });
            return const SizedBox.shrink();
          }

          return _screens[_selectedIndex];
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: AppText.trips,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.location_on),
            label: AppText.heatmap,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: AppText.profile,
          ),
        ],
      ),
    );
  }
}
