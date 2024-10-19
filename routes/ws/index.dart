import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:uuid/uuid.dart';

import 'package:paipfood_back/src/services/ws/ws_teste_service.dart'; // Biblioteca para gerar IDs únicos

final wsTest = WsTesteService();

Future<Response> onRequest(RequestContext context) async {
  return wsTest.onRequest(context, onEvent: (event) {
    print('batatinha: $event');
  });
}
