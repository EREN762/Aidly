import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
// PROVIDI — Après avoir les écrans dans views/ (créés par Yan) et app_routes.dart,
// remplace les imports des screens par : import 'routes/app_routes.dart';
// et utilise routes: AppRoutes.routes dans MaterialApp.
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/forgot_password_screen.dart';

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
        // PROVIDI — Après avoir créé lib/routes/app_routes.dart et tes écrans
        // dans lib/views/, remplace ce bloc routes: par :
        //   routes: AppRoutes.routes,
        // et ajoute les routes pour service_detail, add_service, profile, etc.
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
        },
      ),
    );
  }
}


//PROVIDI — Implémente cett fonctionnalité : si auth.isLoggedIn → HomeScreen, sinon → LoginScreen.
class AuthWrapper extends StatelessWidget {

}
