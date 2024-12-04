import 'package:flutter/foundation.dart' show immutable;
import 'package:sts/views/screens/auth/login.dart';

@immutable
class Utente {
  final String user;
  final String nome;
  final String cognome;
  final String cf;
  final String indirizzo;
  final String cap;
  final String citta;
  final String pv;
  final String tel;
  final String email;

  const Utente({
    required this.user,
    required this.indirizzo,
    required this.cap,
    required this.citta,
    required this.pv,
    required this.tel,
    required this.email,
    required this.nome,
    required this.cognome,
    required this.cf,
  });

  Map<String, dynamic> toMap() {
    return {
      "user": user,
      "nome": nome,
      "cognome": cognome,
      "cf": cf,
      "indirizzo": indirizzo,
      "cap": cap,
      "città": citta,
      "pv": pv,
      "tel": tel,
      "email": email,
    };
  }

  @override
  String toString() {
    return 'Utente{nome: $nome, cognome: $cognome, cf: $cf}';
  }
}
