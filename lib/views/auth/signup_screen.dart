import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/utils.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedUserType = AppConstants.userTypePassenger;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _vehicleTypeController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Type Selection
                  Text(
                    'I am a',
                    style: AppTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedUserType = AppConstants.userTypePassenger;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedUserType == AppConstants.userTypePassenger
                                    ? AppTheme.primaryColor
                                    : AppTheme.dividerColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: _selectedUserType == AppConstants.userTypePassenger
                                  ? AppTheme.primaryColor.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: AppTheme.primaryColor,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Passenger',
                                  style: AppTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedUserType = AppConstants.userTypeDriver;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedUserType == AppConstants.userTypeDriver
                                    ? AppTheme.primaryColor
                                    : AppTheme.dividerColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: _selectedUserType == AppConstants.userTypeDriver
                                  ? AppTheme.primaryColor.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.local_taxi,
                                  color: AppTheme.primaryColor,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Driver',
                                  style: AppTheme.labelMedium,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Name field
                  Text(
                    AppText.name,
                    style: AppTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  Text(
                    AppText.email,
                    style: AppTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Email is required';
                      }
                      if (!AppUtils.isValidEmail(value!)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone field
                  Text(
                    AppText.phone,
                    style: AppTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Phone is required';
                      }
                      if (!AppUtils.isValidPhone(value!)) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Driver-specific fields
                  if (_selectedUserType == AppConstants.userTypeDriver) ...[
                    Text(
                      'Vehicle Type',
                      style: AppTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _vehicleTypeController,
                      decoration: InputDecoration(
                        hintText: 'e.g., Toyota Corolla',
                        prefixIcon: const Icon(Icons.directions_car_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vehicle type is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'License Plate',
                      style: AppTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _licensePlateController,
                      decoration: InputDecoration(
                        hintText: 'e.g., RAK123A',
                        prefixIcon: const Icon(Icons.confirmation_number_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'License plate is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Password field
                  Text(
                    AppText.password,
                    style: AppTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Password is required';
                      }
                      if (!AppUtils.isValidPassword(value!)) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password field
                  Text(
                    AppText.confirmPassword,
                    style: AppTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                      ),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Sign up button
                  Consumer<AuthViewModel>(
                    builder: (context, authVM, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authVM.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _signup(context, authVM);
                                  }
                                },
                          child: authVM.isLoading
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
                              : const Text('Create Account'),
                        ),
                      );
                    },
                  ),

                  // Error message
                  Consumer<AuthViewModel>(
                    builder: (context, authVM, _) {
                      if (authVM.errorMessage != null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.errorColor.withOpacity(0.1),
                              border: Border.all(color: AppTheme.errorColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppTheme.errorColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    authVM.errorMessage!,
                                    style: AppTheme.bodySmall
                                        .copyWith(color: AppTheme.errorColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 24),

                  // Login link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: AppTheme.bodyMedium,
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                AppText.login,
                                style: AppTheme.labelLarge
                                    .copyWith(color: AppTheme.primaryColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signup(BuildContext context, AuthViewModel authVM) async {
    final success = await authVM.signup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
      userType: _selectedUserType,
      vehicleType: _vehicleTypeController.text.trim(),
      licensePlate: _licensePlateController.text.trim(),
    );

    if (success) {
      AppUtils.showSuccessSnackbar(context, 'Account created successfully!');
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }
}
