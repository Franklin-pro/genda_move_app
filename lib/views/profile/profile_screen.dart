import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../../common/app_theme.dart';
import '../../common/utils.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          final user = authVM.currentUser;

          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 64,
                    color: AppTheme.textSecondaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No user logged in',
                    style: AppTheme.headingSmall,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Container(
                  color: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: AppTheme.headingMedium
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          user.userType.toUpperCase(),
                          style: AppTheme.bodySmall
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${user.rating}',
                            style: AppTheme.labelLarge
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${user.reviewCount} reviews)',
                            style: AppTheme.bodySmall
                                .copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Contact information
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Information',
                        style: AppTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      _ProfileInfoTile(
                        icon: Icons.email,
                        label: 'Email',
                        value: user.email,
                      ),
                      _ProfileInfoTile(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: user.phone,
                      ),
                      const SizedBox(height: 24),

                      // Driver-specific info
                      if (user.userType == 'driver') ...[
                        Text(
                          'Vehicle Information',
                          style: AppTheme.labelLarge,
                        ),
                        const SizedBox(height: 16),
                        _ProfileInfoTile(
                          icon: Icons.directions_car,
                          label: 'Vehicle Type',
                          value: user.vehicleType,
                        ),
                        _ProfileInfoTile(
                          icon: Icons.confirmation_number,
                          label: 'License Plate',
                          value: user.licensePlate,
                        ),
                        const SizedBox(height: 24),

                        // Statistics
                        Text(
                          'Statistics',
                          style: AppTheme.labelLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: 'Total Trips',
                                value: user.totalTrips.toString(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Verified',
                                value: user.isVerified ? 'Yes' : 'No',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ] else ...[
                        // Passenger statistics
                        Text(
                          'Statistics',
                          style: AppTheme.labelLarge,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                label: 'Trips Taken',
                                value: user.totalTrips.toString(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                label: 'Verified',
                                value: user.isVerified ? 'Yes' : 'No',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Settings section
                      Text(
                        'Settings',
                        style: AppTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      _SettingsTile(
                        icon: Icons.notifications,
                        title: 'Notifications',
                        onTap: () {
                          AppUtils.showSnackbar(
                            context,
                            'Notification settings coming soon',
                          );
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.privacy_tip,
                        title: 'Privacy & Security',
                        onTap: () {
                          AppUtils.showSnackbar(
                            context,
                            'Privacy settings coming soon',
                          );
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.help,
                        title: 'Help & Support',
                        onTap: () {
                          AppUtils.showSnackbar(
                            context,
                            'Help & Support coming soon',
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.logout),
                          label: const Text('Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.errorColor,
                          ),
                          onPressed: () {
                            _showLogoutConfirmation(context, authVM);
                          },
                        ),
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

  void _showLogoutConfirmation(
      BuildContext context, AuthViewModel authVM) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              authVM.logout().then((_) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              });
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTheme.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.headingSmall.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title, style: AppTheme.labelMedium),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
