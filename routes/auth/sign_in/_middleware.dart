import 'package:dart_frog/dart_frog.dart';
import 'package:paipfood_back/src/providers/_providers.dart';

Handler middleware(Handler handler) {
  return handler.use(authenticatorProvider());
}
