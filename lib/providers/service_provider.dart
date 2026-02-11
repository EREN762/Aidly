import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════
// PROVIDI — Tu t’occupes de ce fichier. Il doit appeler ServiceFirestore
// (ou ServiceController). Expose getServices, getServicesByUser, createService,
// updateService, deleteService, updateRating pour les écrans (views/), uploadServiceImage, uploadProfileImage, deleteServiceImage.
// ═══════════════════════════════════════════════════════════════════════════

class ServiceProvider extends ChangeNotifier {


  /// Stream de tous les services (pour liste sur la home, etc.)


  /// Stream des services d’un utilisateur (pour “mes services”, profil, etc.)


  /// Créer un service (écran add_service)


  /// Mettre à jour un service (écran service_detail ou formulaire d’édition)


  /// Supprimer un service


  /// Mettre à jour la note d’un service (après un avis)



  /// Uploader une image de service (retourne l’URL de téléchargement)
  


  /// Uploader une image de profil (retourne l’URL de téléchargement)
   


  /// Supprimer l’image d’un service du stockage
 
}
