// routes/sign_in.dart
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:paipfood_back/src/services/authenticator.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(
        Response(statusCode: HttpStatus.methodNotAllowed),
      ),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final body = await context.request.json() as Map<String, dynamic>;
  final id = body['id'] as String?;
  final password = body['password'] as String?;

  if (id == null || password == null) {
    return Response(statusCode: HttpStatus.badRequest);
  }

  final authenticator = context.read<Authenticator>();

  final user = authenticator.findByIdAndPassword(
    id: id,
    password: password,
  );

  if (user == null) return Response(statusCode: HttpStatus.badRequest, body: 'User not found');

  if (user.password != password) return Response(statusCode: HttpStatus.badRequest, body: 'Password incorrect');
  final Map response = user.toMap()
    ..addAll({
      'token': Authenticator.buildToken(id: id, password: password),
      'refresh_token': Authenticator.buildRefreshToken(id: id, password: password)
    });

  return Response.json(body: response);
}
