import 'dart:io';

class EnvService {
  static final Map<String, String> _envVars = {};

  static Future<void> loadEnvFile(String path) async {
    final file = File(path);

    if (!await file.exists()) {
      throw Exception('.env file not found at path: $path');
    }

    final lines = await file.readAsLines();

    for (var line in lines) {
      if (line.isEmpty || line.startsWith('#')) continue;

      final parts = line.split('=');
      if (parts.length != 2) continue;

      final key = parts[0].trim();
      final value = parts[1].trim();
      _envVars[key] = value;
    }
  }

  // Método estático para carregar uma string
  static String? loadString(String key) {
    return _envVars[key];
  }

  static bool? loadBool(String key) {
    final value = _envVars[key];
    if (value == null) return null;

    return value.toLowerCase() == 'true';
  }

  static num? loadNum(String key) {
    final value = _envVars[key];
    if (value == null) return null;

    return num.tryParse(value);
  }
}
