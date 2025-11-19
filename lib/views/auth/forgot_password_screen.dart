import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/auth_view_model.dart';
import '../../common/app_theme.dart';
import '../../common/utils.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 48,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Reset Password',
                    style: AppTheme.headingMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your email address and we\'ll send you a link to reset your password.',
                    style: AppTheme.bodyMedium
                        .copyWith(color: AppTheme.textSecondaryColor),
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  Text(
                    'Email Address',
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
                        borderRadius: BorderRadius.circular(8),
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
                  const SizedBox(height: 32),

                  // Send button
                  Consumer<AuthViewModel>(
                    builder: (context, authVM, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: authVM.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _resetPassword(context, authVM);
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
                              : const Text('Send Reset Link'),
                        ),
                      );
                    },
                  ),

                  // Error/Success message
                  Consumer<AuthViewModel>(
                    builder: (context, authVM, _) {
                      if (authVM.errorMessage != null) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: authVM.errorMessage!.contains('sent')
                                  ? AppTheme.successColor.withOpacity(0.1)
                                  : AppTheme.errorColor.withOpacity(0.1),
                              border: Border.all(
                                color: authVM.errorMessage!.contains('sent')
                                    ? AppTheme.successColor
                                    : AppTheme.errorColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  authVM.errorMessage!.contains('sent')
                                      ? Icons.check_circle_outline
                                      : Icons.error_outline,
                                  color: authVM.errorMessage!.contains('sent')
                                      ? AppTheme.successColor
                                      : AppTheme.errorColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    authVM.errorMessage!,
                                    style: AppTheme.bodySmall.copyWith(
                                      color: authVM.errorMessage!.contains('sent')
                                          ? AppTheme.successColor
                                          : AppTheme.errorColor,
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

                  const SizedBox(height: 32),

                  // Back to login
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Back to Login',
                        style: AppTheme.labelLarge
                            .copyWith(color: AppTheme.primaryColor),
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

  Future<void> _resetPassword(BuildContext context, AuthViewModel authVM) async {
    await authVM.resetPassword(_emailController.text.trim());
  }
}
