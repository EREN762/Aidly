import 'dart:io';

import 'package:flutter/material.dart';

import '../controllers/service_controller.dart';
import '../models/service_model.dart';

/// Pont entre UI et Backend (Firestore + Storage).
/// Expose les fonctions Firestore et stockage pour les écrans (views/).
class ServiceProvider extends ChangeNotifier {
  final ServiceController _controller = ServiceController();

  Stream<List<ServiceModel>> getServices() {
    return _controller.getServices();
  }

  Stream<List<ServiceModel>> getServicesByUser(String userId) {
    return _controller.getServicesByUser(userId);
  }

  Future<void> createService(ServiceModel service) async {
    await _controller.createService(service);
    notifyListeners();
  }

  Future<void> updateService(ServiceModel service) async {
    await _controller.updateService(service);
    notifyListeners();
  }

  Future<void> deleteService(String id) async {
    await _controller.deleteService(id);
    notifyListeners();
  }

  Future<void> updateRating(String serviceId, double newRating) async {
    await _controller.updateRating(serviceId, newRating);
    notifyListeners();
  }

  Future<String> uploadServiceImage({
    required File file,
    required String serviceId,
  }) {
    return _controller.uploadServiceImage(file: file, serviceId: serviceId);
  }

  Future<String> uploadProfileImage({
    required File file,
    required String userId,
  }) {
    return _controller.uploadProfileImage(file: file, userId: userId);
  }

  Future<void> deleteServiceImage(String serviceId) {
    return _controller.deleteServiceImage(serviceId);
  }
}
