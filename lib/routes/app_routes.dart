import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PROVIDI — Tu t’occupes de ce fichier. Les écrans sont dans lib/views/ (par Yan).
// 1. Importe les écrans depuis views/ (LoginScreen, HomeScreen, etc.)
// 2. Remplis la Map routes ci‑dessous
// 3. Dans app.dart utilise routes: AppRoutes.routes
// ═══════════════════════════════════════════════════════════════════════════

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String forgotPassword = '/forgot-password';
  static const String serviceDetail = '/service-detail';
  static const String addService = '/add-service';
  static const String profile = '/profile';

  /// PROVIDI — Définis ici la Map des routes.
  /// Exemple une fois tes écrans créés dans views/ :
  ///   static Map<String, WidgetBuilder> get routes => {
  ///     login: (context) => const LoginScreen(),
  ///     register: (context) => const RegisterScreen(),
  ///     home: (context) => const HomeScreen(),
  ///     forgotPassword: (context) => const ForgotPasswordScreen(),
  ///     serviceDetail: (context) => const ServiceDetailScreen(),
  ///     addService: (context) => const AddServiceScreen(),
  ///     profile: (context) => const ProfileScreen(),
  ///   };
  /// PROVIDI — Ajoute ici toutes les routes vers les écrans (lib/views/).
  static Map<String, WidgetBuilder> get routes => {
        // Exemple après création des écrans dans views/ :
        // login: (context) => const LoginScreen(),
        // register: (context) => const RegisterScreen(),
        // home: (context) => const HomeScreen(),
        // forgotPassword: (context) => const ForgotPasswordScreen(),
        // serviceDetail: (context) => const ServiceDetailScreen(),
        // addService: (context) => const AddServiceScreen(),
        // profile: (context) => const ProfileScreen(),
      };
}
