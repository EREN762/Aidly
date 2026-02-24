import 'package:flutter/material.dart';

class ServiceExtrasProvider extends ChangeNotifier {
  final Map<String, String> _providerEmailsByServiceId = {};

  void setProviderEmail({
    required String serviceId,
    required String email,
  }) {
    _providerEmailsByServiceId[serviceId] = email;
    notifyListeners();
  }

  String? getProviderEmail(String serviceId) {
    return _providerEmailsByServiceId[serviceId];
  }
}
