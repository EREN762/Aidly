import 'package:flutter/material.dart';

import '../screens/forgot_password_screen.dart';
import '../views/add_service_screen.dart';
import '../views/home_screen.dart';
import '../views/login_screen.dart';
import '../views/profile_screen.dart';
import '../views/register_screen.dart';
import '../views/service_detail_screen.dart';

/// Définition des routes de l'app. Les écrans principaux sont dans lib/views/ (Yan).
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String forgotPassword = '/forgot-password';
  static const String serviceDetail = '/service-detail';
  static const String addService = '/add-service';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        home: (context) => const HomeScreen(),
        forgotPassword: (context) => const ForgotPasswordScreen(),
        serviceDetail: (context) => const ServiceDetailScreen(),
        addService: (context) => const AddServiceScreen(),
        profile: (context) => const ProfileScreen(),
      };
}
