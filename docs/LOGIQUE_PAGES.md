# Aidly — Logique des pages (non technique)

Ce document explique, avec des mots simples, le role de chaque page,
ce qu on y fait, et ce qu elle contient.

## Login (Connexion)
**Utilite**
- Permettre a l utilisateur de se connecter a son compte.

**Ce qu on y trouve**
- Un titre de bienvenue.
- Un champ email et un champ mot de passe.
- Un bouton "Se connecter".
- Un bouton "Continuer avec Google".
- Un lien pour aller vers l inscription.

**Comportement attendu**
- Si l utilisateur se connecte, il arrive sur l accueil.
- Si l email ou le mot de passe est incorrect, un message apparait.

## Register (Inscription)
**Utilite**
- Creer un compte en quelques secondes.

**Ce qu on y trouve**
- Un champ email.
- Un champ mot de passe.
- Un champ confirmation du mot de passe.
- Un bouton pour creer le compte.
- Un bouton Google.
- Un lien vers la page de connexion.

**Comportement attendu**
- Si les champs sont valides, l utilisateur est connecte et arrive sur l accueil.

## MainShell (Navigation principale)
**Utilite**
- Regrouper les 3 pages principales avec une barre de navigation en bas.

**Ce qu on y trouve**
- Trois onglets : Accueil, Ajouter, Profil.
- Chaque onglet garde sa position (pas de retour en haut non voulu).

## Home (Accueil / Decouverte)
**Utilite**
- Decouvrir les services disponibles.

**Ce qu on y trouve**
- Un message de bienvenue.
- Une barre de recherche.
- Un carrousel de visuels inspirants.
- Des filtres rapides (Bricolage, Jardinage, Cours).
- Une grille de cartes services.

**Comportement attendu**
- Les filtres limitent la liste.
- Si aucun service n est charge, des services de demo s affichent.

## Service Detail (Detail service)
**Utilite**
- Montrer toutes les infos du service.
- Donner envie de souscrire.

**Ce qu on y trouve**
- Une grande image du service.
- Le titre, la categorie, le prix, la description.
- Une zone pour noter.
- Un bouton "Souscrire".
- Un bouton "Ouvrir le chat".

**Comportement attendu**
- Souscrire envoie une demande au serveur.
- Le chat ouvre une discussion avec le prestataire.

## Add Service (Creer un service)
**Utilite**
- Permettre a un utilisateur de publier une offre.

**Ce qu on y trouve**
- Un formulaire par etapes.
- Titre, categorie, sous categorie, localisation, prix.
- Email du prestataire (obligatoire).
- Description.
- Upload image (ou URL).

**Comportement attendu**
- Le service est cree si tous les champs sont valides.
- L image peut etre envoyee au stockage.

## Profile (Profil)
**Utilite**
- Espace personnel.

**Ce qu on y trouve**
- Une carte profil.
- Le bouton de deconnexion.
- La liste des services publies par l utilisateur.

**Comportement attendu**
- L utilisateur peut se deconnecter.
- Il retrouve ses services.

## Chat (Discussion)
**Utilite**
- Discuter entre client et prestataire.

**Ce qu on y trouve**
- Une liste de messages.
- Un champ de saisie.
- Un bouton envoyer.

**Comportement attendu**
- Les messages s affichent du plus ancien au plus recent.
- L ecran descend automatiquement vers le dernier message.

