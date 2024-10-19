import 'package:dart_frog/dart_frog.dart';

import 'i_ws_service.dart';

class WsTesteService extends IWsService {
  @override
  Future<Response> onRequest(RequestContext context, {Function(Map<String, dynamic> event)? onEvent}) {
    return super.onRequest(context, onEvent: onEvent);
  }
}
