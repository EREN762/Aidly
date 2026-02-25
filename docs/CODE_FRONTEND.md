# Aidly — Explication du code front-end (lib/)

Ce document explique le code front-end de maniere detaillee,
avec des extraits courts et des explications simples.


## 1) Demarrage de l app

**Fichier**: `lib/main.dart`
- Initialise Firebase.
- Injecte les providers (Auth, Service, Theme, ServiceExtras).
- Lance `App`.

Extrait cle:
```
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ServiceProvider()),
    ChangeNotifierProvider(create: (_) => ServiceExtrasProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ],
  child: const App(),
)
```
**Pourquoi**: les ecrans peuvent lire l etat sans reconstruire toute l app.

## 2) App et Themes

**Fichier**: `lib/app.dart`
- Defini le theme clair et sombre.
- Choisit `AuthWrapper` comme page de depart.
- Utilise `AppRoutes.routes` pour la navigation.

Extrait cle:
```
MaterialApp(
  theme: AppTheme.buildTheme(),
  darkTheme: AppTheme.buildDarkTheme(),
  themeMode: themeProvider.mode,
  home: const AuthWrapper(),
  routes: AppRoutes.routes,
)
```
**Pourquoi**: le ThemeMode change tout le style sans rechargement brutal.

## 3) Navigation principale

**Fichier**: `lib/views/main_shell.dart`
- Contient la BottomNavigationBar.
- Utilise `IndexedStack` pour garder l etat des onglets.

Extrait cle:
```
IndexedStack(
  index: _currentIndex,
  children: _pages,
)
```
**Pourquoi**: pas de reset de scroll quand on change d onglet.

## 4) Login / Register

**Fichiers**: `lib/views/login_screen.dart`, `lib/views/register_screen.dart`
- Formulaire + validation.
- Appels a `AuthController`.
- Navigation vers `/home` si succes.

Extrait cle:
```
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final controller = AuthController(authProvider);
await controller.login(email, password);
Navigator.pushReplacementNamed(context, AppRoutes.home);
```
**Pourquoi**: separer l UI (views) et la logique (controller/provider).

## 5) Accueil (Home)

**Fichier**: `lib/views/home_screen.dart`
- Barre de recherche.
- Carrousel avec images assets.
- Filtres rapides (Bricolage, Jardinage, Cours).
- Grille de services (StreamBuilder).

Extrait cle:
```
StreamBuilder<List<ServiceModel>>(
  stream: _serviceController.getServices(),
  builder: ...
)
```
**Pourquoi**: les services se mettent a jour en temps reel.

Le filtrage se fait en local:
```
final matchesQuery = lowered.isEmpty || title.contains(lowered);
final matchesCategory = _selectedCategory == null || service.category == _selectedCategory;
return matchesQuery && matchesCategory;
```

## 6) Ajout de service

**Fichier**: `lib/views/add_service_screen.dart`
- Formulaire par etapes (Stepper).
- Upload d image via `ServiceProvider`.
- Email prestataire obligatoire.

Extrait cle:
```
final service = ServiceModel(
  id: _serviceId,
  title: _titleController.text.trim(),
  category: _categoryController.text.trim(),
  ...
);
await provider.createService(service);
```
**Pourquoi**: `ServiceModel` doit etre complet pour les autres pages.

Email prestataire stocke localement:
```
extrasProvider.setProviderEmail(
  serviceId: _serviceId,
  email: _providerEmailController.text.trim(),
);
```

## 7) Detail service + Souscription

**Fichier**: `lib/views/service_detail_screen.dart`
- Affiche image, infos, note.
- Bouton "Souscrire" + loading state.
- Bouton "Ouvrir le chat".

Extrait cle:
```
await SubscribeApi().subscribe(
  serviceId: widget.service.id,
  providerEmail: providerEmail,
  clientId: clientId,
);
```
**Pourquoi**: l appel est prepare pour un backend externe, sans email local.

## 8) Chat

**Fichier**: `lib/views/chat_screen.dart`
- Provider local `ChatProvider`.
- Chargement messages via API.
- Envoi message + scroll vers le bas.

Extrait cle:
```
ChangeNotifierProvider(
  create: (_) => ChatProvider(ChatApi())..loadMessages(widget.serviceId),
  child: ...
)
```
**Pourquoi**: l ecran reste fluide et ne recharge pas toute l app.

Scroll automatique:
```
_scrollController.animateTo(
  _scrollController.position.maxScrollExtent,
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeOut,
);
```

## 9) Providers et APIs

**Providers**
- `AuthProvider`: memorise si l utilisateur est connecte.
- `ServiceProvider`: CRUD services + upload image.
- `ServiceExtrasProvider`: stocke l email prestataire (front only).
- `ThemeProvider`: switch clair/sombre.

**APIs**
- `ApiConfig`: baseUrl configurable.
- `SubscribeApi`: POST `/api/subscribe`.
- `ChatApi`: GET `/api/chat/{serviceId}` + POST `/api/chat/send`.

## 10) Modeles et widgets

**Modeles**
- `ServiceModel`: structure d un service.
- `ChatMessage`: structure d un message.

**Widgets reutilisables**
- `CustomButton`, `InputField`, `ServiceCard`, `ShimmerBox`.
- Utilises pour garder un style uniforme.

