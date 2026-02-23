import 'dart:io';

import 'package:flutter/material.dart';

import '../models/service_model.dart';
import '../services/service_firestrore.dart';
import '../services/storage_service.dart';

/// Pont entre UI et Backend (Firestore + Storage).
/// Expose les fonctions Firestore et stockage pour les écrans (views/).
class ServiceProvider extends ChangeNotifier {
  final ServiceFirestoreService _firestoreService = ServiceFirestoreService();
  final StorageService _storageService = StorageService();

  /// Stream de tous les services (pour liste sur la home, etc.)
  Stream<List<ServiceModel>> getServices() {
    return _firestoreService.getServices();
  }

  /// Stream des services d'un utilisateur (pour "mes services", profil, etc.)
  Stream<List<ServiceModel>> getServicesByUser(String userId) {
    return _firestoreService.getServicesByUser(userId);
  }

  /// Créer un service (écran add_service)
  Future<void> createService(ServiceModel service) async {
    await _firestoreService.createService(service);
    notifyListeners();
  }

  /// Mettre à jour un service (écran service_detail ou formulaire d'édition)
  Future<void> updateService(ServiceModel service) async {
    await _firestoreService.updateService(service);
    notifyListeners();
  }

  /// Supprimer un service
  Future<void> deleteService(String id) async {
    await _firestoreService.deleteService(id);
    notifyListeners();
  }

  /// Mettre à jour la note d'un service (après un avis)
  Future<void> updateRating(String serviceId, double newRating) async {
    await _firestoreService.updateRating(serviceId, newRating);
    notifyListeners();
  }

  /// Uploader une image de service (retourne l'URL de téléchargement)
  Future<String> uploadServiceImage({
    required File file,
    required String serviceId,
  }) async {
    return _storageService.uploadFile(file: file, serviceId: serviceId);
  }

  /// Uploader une image de profil (retourne l'URL de téléchargement)
  Future<String> uploadProfileImage({
    required File file,
    required String userId,
  }) async {
    return _storageService.uploadProfileImage(file: file, userId: userId);
  }

  /// Supprimer l'image d'un service du stockage
  Future<void> deleteServiceImage(String serviceId) async {
    await _storageService.deleteFile(serviceId: serviceId);
    notifyListeners();
  }
}
