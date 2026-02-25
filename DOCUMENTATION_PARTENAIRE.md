# Documentation partenaire — Aidly

Ce document explique comment utiliser l’authentification, la **persistance** et comment **compléter `app.dart`** et les écrans (login, register, home, mot de passe oublié).

---

## 1. `main.dart` — Un seul Provider (mono)

L’app utilise **un seul Provider** : `AuthProvider`, qui gère l’état “connecté / déconnecté” et la **persistance** (SharedPreferences).

```dart
runApp(
  ChangeNotifierProvider(
    create: (_) => AuthProvider(),
    child: const App(),
  ),
);
```

- Ne pas remplacer par `MultiProvider` sauf si tu ajoutes d’autres providers (ex. services, thème).
- `AuthProvider` est créé dans `lib/services/local_storage_service.dart`.

---

## 2. Persistance (connexion restante après fermeture de l’app)

La persistance repose sur :

- **SharedPreferences** (clé `isLoggedIn`) pour savoir si l’utilisateur est “connecté”.
- **AuthProvider**, qui lit cette clé au démarrage et expose `isLoggedIn`.

Règle importante : à chaque **connexion réussie** (email, Google, etc.), il faut **à la fois** :

1. Faire l’auth Firebase (via `AuthService`).
2. Marquer la session comme persistante avec **`AuthProvider.loginSuccess()`**.

À chaque **déconnexion** :

1. Déconnecter Firebase avec **`AuthService.signOut()`**.
2. Effacer la persistance avec **`AuthProvider.logout()`**.

Sinon, au prochain lancement, l’app pourrait afficher la home alors que Firebase n’a plus de session (ou l’inverse).

---

## 3. Comment utiliser l’auth dans tes méthodes (connexion / déconnexion)

### Services à importer

- `AuthService` : `lib/services/auth_service.dart`  
  → `signIn`, `signUp`, `signInWithGoogle`, `signOut`, `resetPassword`
- `AuthProvider` : `lib/services/local_storage_service.dart`  
  → `loginSuccess()`, `logout()`

Exemple d’import dans un écran :

```dart
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/local_storage_service.dart';
```

---

### Connexion par **email / mot de passe**

1. Appeler `AuthService.signIn(email: ..., password: ...)`.
2. Si succès (pas d’exception), appeler **`AuthProvider.loginSuccess()`** pour persister.

Exemple dans ton écran de login :

```dart
final authService = AuthService();
final authProvider = Provider.of<AuthProvider>(context, listen: false);

try {
  await authService.signIn(email: emailController.text, password: passwordController.text);
  await authProvider.loginSuccess();  // Persistance : l’utilisateur restera “connecté”
  if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
} catch (e) {
  // Afficher erreur (SnackBar, overlay, etc.)
}
```

---

### Connexion avec **Google**

1. Appeler `AuthService.signInWithGoogle()`.
2. Si succès, appeler **`AuthProvider.loginSuccess()`** pour persister.

Exemple :

```dart
final authService = AuthService();
final authProvider = Provider.of<AuthProvider>(context, listen: false);

try {
  await authService.signInWithGoogle();
  await authProvider.loginSuccess();  // Persistance
  if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
} catch (e) {
  // Afficher erreur
}
```

---

### Inscription (création de compte)

1. Appeler `AuthService.signUp(email: ..., password: ...)`.
2. Si succès, appeler **`AuthProvider.loginSuccess()`** pour que l’utilisateur soit considéré connecté et que la persistance soit activée.

Exemple :

```dart
try {
  await authService.signUp(email: email, password: password);
  await authProvider.loginSuccess();
  if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
} catch (e) {
  // Afficher erreur
}
```

---

### Déconnexion

Toujours faire les deux :

1. **`AuthService.signOut()`** (Firebase + Google si utilisé).
2. **`AuthProvider.logout()`** (supprime `isLoggedIn` en local).

Exemple (bouton déconnexion sur la home) :

```dart
final authService = AuthService();
final authProvider = Provider.of<AuthProvider>(context, listen: false);

await authService.signOut();
await authProvider.logout();
if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
```

---

### Mot de passe oublié

Utiliser uniquement **`AuthService.resetPassword(email: email)`**. Pas besoin de `loginSuccess` ici (on n’a pas connecté l’utilisateur).

---

## 4. Compléter `app.dart`

- **Ne pas modifier la classe `AuthWrapper`** : elle décide si l’utilisateur voit la home ou le login selon `AuthProvider.isLoggedIn`.
- Tu peux modifier :
  - Le **thème** : couleurs, `fontFamily`, `colorScheme`, etc.
  - Les **routes** : ajouter de nouvelles routes si tu crées d’autres écrans (ex. profil, détail service).
- Les routes déjà déclarées :
  - `"/login"` → `LoginScreen`
  - `"/register"` → `RegisterScreen`
  - `"/home"` → `HomeScreen`
  - `"/forgot-password"` → `ForgotPasswordScreen`

Pour ajouter une route :

```dart
routes: {
  "/login": (context) => const LoginScreen(),
  "/register": (context) => const RegisterScreen(),
  "/home": (context) => const HomeScreen(),
  "/forgot-password": (context) => const ForgotPasswordScreen(),
  "/ma-nouvelle-page": (context) => const MaNouvellePage(),
},
```

Pense à importer le fichier qui contient `MaNouvellePage`.

---

## 5. Écrans à créer / compléter

Des **placeholders** existent déjà ici :

- `lib/screens/login_screen.dart` → `LoginScreen`
- `lib/screens/register_screen.dart` → `RegisterScreen`
- `lib/screens/home_screen.dart` → `HomeScreen`
- `lib/screens/forgot_password_screen.dart` → `ForgotPasswordScreen`

Ils sont déjà importés dans `app.dart`. Tu peux :

- Soit **remplacer le contenu** de ces fichiers par tes vrais écrans en gardant le même nom de classe.
- Soit **créer de nouveaux fichiers** (ex. `login_page.dart`) et mettre à jour les imports et les routes dans `app.dart` pour utiliser tes classes.

Récap à retenir dans tes écrans :

| Action           | AuthService                    | AuthProvider     |
|-----------------|---------------------------------|------------------|
| Login (email)    | `signIn(...)`                   | `loginSuccess()` |
| Login (Google)   | `signInWithGoogle()`            | `loginSuccess()` |
| Inscription     | `signUp(...)`                   | `loginSuccess()` |
| Déconnexion     | `signOut()`                     | `logout()`       |
| Mot de passe oublié | `resetPassword(...)`         | —                |

---

## 6. Résumé

- **main.dart** : un seul `ChangeNotifierProvider` avec `AuthProvider`.
- **Persistance** : à chaque connexion réussie → `AuthProvider.loginSuccess()` ; à chaque déconnexion → `AuthService.signOut()` + `AuthProvider.logout()`.
- **app.dart** : tu peux modifier le thème et les routes ; ne pas toucher à `AuthWrapper`.
- Les écrans dans `lib/screens/` sont des squelettes à compléter en suivant les exemples ci-dessus pour appeler `AuthService` et `AuthProvider`.

Si tu veux, on peut ajouter une section “Exemples de champs de formulaire” ou “Gestion d’erreurs Firebase” dans ce doc.
