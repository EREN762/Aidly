import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aidly/models/service_model.dart';

class ServiceFirestoreService {
  // Singleton instance de FirebaseFirestore pour la persistence des données
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Collection name pour les services
  late final CollectionReference _servicesCollection = _firestore.collection('services');

  // Méthode pour créer un service
  Future<void> createService(ServiceModel service) async{
    await _servicesCollection.doc(service.id).set(service.toMap());
}
  // Méthode pour récupérer tous les services
  Stream<List<ServiceModel>> getServices(){
    return _servicesCollection.orderBy('createAt', descending : true)
    .snapshots()
    .map((snapshot) {
      return snapshot.docs.map((doc){
        return ServiceModel.fromMap(doc.data() as Map<String, dynamic>,doc.id);
      }).toList();
    });
    }

  // Méthode pour récupérer le service d'un utilisateur 
  Stream<List<ServiceModel>> getServicesByUser(String userId){
    return _servicesCollection.where('createdBy', isEqualTo: userId)
    .snapshots()
    .map((snapshot) {
      return snapshot.docs.map((doc){
        return ServiceModel.fromMap(doc.data() as Map<String, dynamic>,doc.id);
      }).toList();
    });
  }

  // Méthode pour mettre à jour un service
  Future<void> updateService(ServiceModel service) async{
    await _servicesCollection.doc(service.id).update(service.toMap());
  }

  // Méthode pour supprimer un service
  Future<void> deleteService(String id) async {
    await _servicesCollection.doc(id).delete();
  }

  // Mettre a jour les etoiles et le nombre de reviews(avec la moyenne des notes) 
  Future<void> updateRating(String serviceId, double newRating) async {
    final doc = await _servicesCollection.doc(serviceId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;

      final double currentRating = (data["rating"] ?? 0).toDouble();
      int reviewCount = data["reviewsCount"] ?? 0;

      final double totalRating = currentRating * reviewCount;
      reviewCount++;

      final double newAverage = (totalRating + newRating) / reviewCount;

      await _servicesCollection.doc(serviceId).update({
        "rating": newAverage,
        "reviewsCount": reviewCount,
      });
    }
  }
}
