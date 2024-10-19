import 'package:dart_frog/dart_frog.dart';
import 'package:paipfood_back/src/services/authenticator.dart';

Authenticator? _authenticator;
Middleware authenticatorProvider() => provider((context) => _authenticator ??= Authenticator());
