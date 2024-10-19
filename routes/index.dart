import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final requet = context.request;

  final method = requet.method;
  if (method != HttpMethod.post) {
    return Response(statusCode: 400, body: 'É post seu otario');
  }

  // TODO: implement route handler
  return Response(body: 'This is a new route post!');
}
