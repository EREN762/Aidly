import 'package:flutter/material.dart';

import '../models/service_model.dart';
import '../views/forgot_password_screen.dart';
import '../views/add_service_screen.dart';
import '../views/login_screen.dart';
import '../views/main_shell.dart';
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
        home: (context) => const MainShell(),
        forgotPassword: (context) => const ForgotPasswordScreen(),
        serviceDetail: (context) {
          final service = ModalRoute.of(context)?.settings.arguments as ServiceModel?;
          if (service != null) return ServiceDetailScreen(service: service);
          return const Scaffold(
            body: Center(child: Text('Service requis')),
          );
        },
        addService: (context) => const AddServiceScreen(),
        profile: (context) => const ProfileScreen(),
      };
}
