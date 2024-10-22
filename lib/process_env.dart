// ignore_for_file: unused_element

import 'dart:io';

class ProcessEnv {
  ProcessEnv._();

  static int get port => _loadInt('PORT');
  static String get secrectKey => _loadString('SECRETE_KEY');
  static int get tokenExpiration => _loadInt('TOKEN_EXPIRATION');
  static int get refreshTokenExpiration => _loadInt('REFRESH_TOKEN_EXPIRATION');
  static String get stripePublishableKey => _loadString('STRIPE_PUBLISHABLE_KEY');
  static String get stripeScreKey => _loadString('STRIPE_SCRET_KEY');

  static int _loadInt(String key) {
    return int.parse(Platform.environment[key].toString());
  }

  static String _loadString(String key) {
    return Platform.environment[key].toString();
  }

  static bool _loadBool(String key) {
    return _loadString(key).toLowerCase() == 'true';
  }
}
