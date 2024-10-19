import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:paipfood_back/process_env.dart';
import 'package:paipfood_back/src/models/user_model.dart';

class Authenticator {
  static Map<String, UserModel> _users = {
    'dudu': UserModel(
      id: 'dudu',
      password: '123',
    ),
    'jack': UserModel(
      id: '2',
      password: '321',
    ),
  };

  static const _passwords = {
    // ⚠️ Never store user's password in plain text, these values are in plain text
    // just for the sake of the tutorial.
    'dudu': '123',
    'jack': '321',
  };

  UserModel? findByIdAndPassword({required String id, required String password}) {
    return _users[id];
  }

  static String buildToken({required String id, required String password}) {
    final jwt = JWT({'id': id, 'password': password});
    return jwt.sign(SecretKey(ProcessEnv.secrectKey), expiresIn: Duration(seconds: ProcessEnv.tokenExpiration));
  }

  static String buildRefreshToken({required String id, required String password}) {
    final jwt = JWT({'id': id, 'password': password});
    return jwt.sign(SecretKey(ProcessEnv.secrectKey), expiresIn: Duration(seconds: ProcessEnv.refreshTokenExpiration));
  }

  static String? refreshToken(String refreshToken) {
    final jwt = JWT.verify(refreshToken, SecretKey(ProcessEnv.secrectKey));
    final id = jwt.payload['id'];
    final password = jwt.payload['password'];
    if ((id == null || password == null) && (_validateJwtPayload(jwt.payload) == false)) return null;
    return buildRefreshToken(id: id, password: password);
  }

  static String tokenParse(String token) => token.substring(7).trim();

  static bool _validateJwtPayload(Map payload) {
    final user = UserModel.fromMap(payload);
    return _users[user.id] != null;
  }

  static bool validateToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(ProcessEnv.secrectKey));
      if (_validateJwtPayload(jwt.payload)) return true;
      return false;
    } catch (_) {
      return false;
    }
  }
}
