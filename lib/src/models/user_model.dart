import 'dart:convert';

class UserModel {
  final String id;
  final String password;
  UserModel({
    this.id = '',
    this.password = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  factory UserModel.fromMap(Map map) {
    return UserModel(
      id: map['id'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
