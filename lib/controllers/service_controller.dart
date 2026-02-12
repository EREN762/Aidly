import 'dart:io';

import '../models/service_model.dart';
import '../services/service_firestrore.dart';
import '../services/storage_service.dart';

// Ne pas modifier (utilisé par ServiceProvider et par les écrans dans views/).

class ServiceController {
  final ServiceFirestoreService _serviceFirestore = ServiceFirestoreService();
  final StorageService _storageService = StorageService();

  /// Créer un service
  Future<void> createService(ServiceModel service) async {
    await _serviceFirestore.createService(service);
  }

  /// Stream de tous les services (tri par date de création, plus récent en premier)
  Stream<List<ServiceModel>> getServices() {
    return _serviceFirestore.getServices();
  }

  /// Stream des services créés par un utilisateur
  Stream<List<ServiceModel>> getServicesByUser(String userId) {
    return _serviceFirestore.getServicesByUser(userId);
  }

  /// Mettre à jour un service
  Future<void> updateService(ServiceModel service) async {
    await _serviceFirestore.updateService(service);
  }

  /// Supprimer un service
  Future<void> deleteService(String id) async {
    await _serviceFirestore.deleteService(id);
  }

  /// Mettre à jour la note d'un service (moyenne des avis)
  Future<void> updateRating(String serviceId, double newRating) async {
    await _serviceFirestore.updateRating(serviceId, newRating);
  }

  /// Uploader une image de service (retourne l’URL de téléchargement)
  Future<String> uploadServiceImage({required File file, required String serviceId}) async {
    return _storageService.uploadFile(file: file, serviceId: serviceId);
  }

  /// Uploader une image de profil (retourne l’URL de téléchargement)
  Future<String> uploadProfileImage({required File file, required String userId}) async {
    return _storageService.uploadProfileImage(file: file, userId: userId);
  }

  /// Supprimer l’image d’un service du stockage
  Future<void> deleteServiceImage(String serviceId) async {
    await _storageService.deleteFile(serviceId: serviceId);
  }
}
