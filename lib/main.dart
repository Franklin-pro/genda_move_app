import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/app_theme.dart';
import 'common/constants.dart';
import 'services/local_storage_service.dart';
import 'view_models/auth_view_model.dart';
import 'view_models/trip_view_model.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/signup_screen.dart';
import 'views/auth/forgot_password_screen.dart';
import 'views/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage
  final localStorageService = LocalStorageService();
  await localStorageService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => TripViewModel()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const RootPage(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/forgot_password': (context) => const ForgotPasswordScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        if (authVM.isLoggedIn) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
