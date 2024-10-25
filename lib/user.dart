import 'package:flutter/foundation.dart' show immutable;

@immutable
class User {
  final int id;
  final String name;
  final String email;
  final int password;
  final int phoneNumber;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
    };
  }
}
