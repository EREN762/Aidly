class ApiConfig {
  static String baseUrl = 'https://example.com';

  static Uri resolve(String path) {
    return Uri.parse('$baseUrl$path');
  }
}
