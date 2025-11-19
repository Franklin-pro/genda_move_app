import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../../common/app_theme.dart';
import '../../common/constants.dart';
import '../../common/utils.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // App logo and title
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.local_taxi,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text('Lift App', style: AppTheme.headingLarge),
                        const SizedBox(height: 8),
                        Text('Your ride, your way', style: AppTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email field
                  Text(AppText.email, style: AppTheme.labelLarge),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
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

                  // Password field
                  Text(AppText.password, style: AppTheme.labelLarge),
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
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
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
                  const SizedBox(height: 8),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        AppText.forgotPassword,
                        style: AppTheme.labelLarge.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login button
                  Consumer<AuthViewModel>(
                    builder: (context, authVM, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authVM.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _login(context, authVM);
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
                              : Text(AppText.login),
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
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppTheme.errorColor,
                                    ),
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

                  // Demo credentials
                  Center(
                    child: Column(
                      children: [
                        Text('Demo Credentials', style: AppTheme.labelLarge),
                        const SizedBox(height: 8),
                        Text(
                          'Driver: ${AppConstants.demoDriverEmail}',
                          style: AppTheme.bodySmall,
                        ),
                        Text(
                          'Passenger: ${AppConstants.demoPassengerEmail}',
                          style: AppTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Password: ${AppConstants.demoDriverPassword}',
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sign up link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppTheme.bodyMedium,
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                AppText.signup,
                                style: AppTheme.labelLarge.copyWith(
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context, AuthViewModel authVM) async {
    final success = await authVM.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success) {
      AppUtils.showSuccessSnackbar(context, 'Login successful!');
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    }
  }
}
