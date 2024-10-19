import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:paipfood_back/src/services/authenticator.dart';

Middleware validateJwt() {
  return (handler) {
    return (context) async {
      final authorizationHeader = context.request.headers['Authorization'];

      if (authorizationHeader == null || !authorizationHeader.startsWith('Bearer ')) {
        return Response(statusCode: HttpStatus.unauthorized, body: 'Missing or malformed token');
      }

      final token = Authenticator.tokenParse(authorizationHeader);

      if (!Authenticator.validateToken(token)) {
        return Response(statusCode: HttpStatus.unauthorized, body: 'Unauthorized');
      }

      return handler(context);
    };
  };
}
