import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class SubscribeApi {
  Future<void> subscribe({
    required String serviceId,
    required String providerEmail,
    required String clientId,
  }) async {
    final response = await http.post(
      ApiConfig.resolve('/api/subscribe'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'serviceId': serviceId,
        'providerEmail': providerEmail,
        'clientId': clientId,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Erreur souscription (${response.statusCode})');
    }
  }
}
