import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'routes/app_routes.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PROVIDI — Tu t’occupes de ce fichier : MaterialApp, AuthWrapper, routes.
// YAN — Le thème (theme:) est de ton ressort (UI/UX) ; Providi ne le modifie pas.
// ═══════════════════════════════════════════════════════════════════════════

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Aidly',
        // YAN — C’est toi qui codes le thème (UI/UX) : couleurs, fontFamily, etc.
        theme: ThemeData(
          primaryColor: const Color(0xFF5669FF),
          scaffoldBackgroundColor: const Color(0xFFF7FAFC),
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF5669FF),
            primary: const Color(0xFF5669FF),
          ),
        ),
        home: const AuthWrapper(),
        routes: AppRoutes.routes,
      ),
    );
  }
}


/// Redirige vers Login si pas connecté, sinon affiche l'écran d'accueil (Home).
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoggedIn) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}
