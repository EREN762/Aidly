import "dart:io";
import "package:firebase_storage/firebase_storage.dart";

class StorageService {
  // Singleton instance de FirebaseStorage pour la gestion du stockage des fichiers
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Méthode pour uploader un fichier(image, video, etc.)
  Future<String> uploadFile({required File file, required String serviceId}) async {
    try {
      final ref = _storage.ref().child("services_images")
      .child('$serviceId.jpg');
      await ref.putFile(file);
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  // Méthode pour uploader une image de profil
  Future<String> uploadProfileImage({required File file, required String userId}) async {
    try {
      final ref = _storage.ref().child("profile_images")
      .child('$userId.jpg');
      await ref.putFile(file);
      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception(e.toString());
    }
  } 
  
  // Méthode pour supprimer un fichier
  Future<void> deleteFile({required String serviceId}) async {
    try {
      final ref = _storage.ref().child("services_images")
      .child('$serviceId.jpg');
      await ref.delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}