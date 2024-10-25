import 'package:flutter/foundation.dart' show immutable;

@immutable
class Proprietario {
  final int id;
  final String username;
  final String password;
  final String pincode;
  final String piva;

  const Proprietario({
    required this.id,
    required this.username,
    required this.password,
    required this.pincode,
    required this.piva,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "password": password,
      "pincode": pincode,
      "piva": piva,
    };
  }
}
