import 'package:url_launcher/url_launcher.dart';

class EmailHelper {
  /// Construit et génère l'objet et le corps du mail pour contacter le prestataire
  static Map<String, String> buildServiceInquiryEmail({
    required String serviceName,
    String? servicePrice,
    String? serviceCategory,
    String? clientName,
  }) {
    // Objet du mail
    final subject = 'Demande d\'information - Service: $serviceName';

    // Constructeur du corps du mail - utiliser les données seulement si présentes
    final bodyParts = <String>[];

    bodyParts.add('Bonjour,');
    bodyParts.add('');
    bodyParts.add('Je suis intéressé(e) par votre service « $serviceName ».');
    bodyParts.add('');

    // Ajouter les détails du service s'ils sont disponibles
    if (serviceCategory != null && serviceCategory.isNotEmpty) {
      bodyParts.add('Catégorie : $serviceCategory');
    }
    if (servicePrice != null && servicePrice.isNotEmpty) {
      bodyParts.add('Tarif : $servicePrice');
    }

    if (serviceCategory != null || servicePrice != null) {
      bodyParts.add('');
    }

    bodyParts.add('Pourriez-vous me fournir plus d\'informations à ce sujet ?');
    bodyParts.add('');

    if (clientName != null && clientName.isNotEmpty) {
      bodyParts.add('Cordialement,');
      bodyParts.add(clientName);
    } else {
      bodyParts.add('Cordialement.');
    }

    final body = bodyParts.join('\n');

    return {'subject': subject, 'body': body};
  }

  /// Lance l'application mail avec les paramètres spécifiés
  static Future<bool> sendServiceInquiry({
    required String providerEmail,
    required String serviceName,
    String? servicePrice,
    String? serviceCategory,
    String? clientName,
  }) async {
    try {
      // Construire le mail
      final emailData = buildServiceInquiryEmail(
        serviceName: serviceName,
        servicePrice: servicePrice,
        serviceCategory: serviceCategory,
        clientName: clientName,
      );

      // Construire l'URL mailto
      final mailtoLink = Uri(
        scheme: 'mailto',
        path: providerEmail,
        queryParameters: {
          'subject': emailData['subject'],
          'body': emailData['body'],
        },
      );

      // Lancer l'URL
      return await launchUrl(mailtoLink);
    } catch (e) {
      print('Erreur lors de l\'ouverture du mail: $e');
      return false;
    }
  }
}
