import 'package:dart_frog/dart_frog.dart';
import 'package:paipfood_back/src/services/authenticator.dart';

Response onRequest(RequestContext context) {
  final requet = context.request;
  if (requet.method != HttpMethod.post) return Response(statusCode: 400, body: 'Invalid method');
  final authorization = requet.headers['Authorization']!;
  final token = Authenticator.refreshToken(Authenticator.tokenParse(authorization));

  return Response.json(body: {
    'refresh_token': token,
  });
}
