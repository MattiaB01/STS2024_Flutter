import 'package:flutter/foundation.dart' show immutable;

@immutable
class Fattura {
  final String proprietario;
  final String nome;
  final String cognome;
  final String cf;
  final String natIva1;
  final String natIva2;
  final String dataPag;
  final String dataFat;
  final bool aggiungi;
  final double importo1;
  final double importo2;
  final int protocollo;
  final String opposizione;
  final String anticipato;
  final String tracciato;
  final String tipoSpesa;
  final String nDisp;
  final String nFat;

  const Fattura(
      {required this.aggiungi,
      required this.proprietario,
      required this.nome,
      required this.cognome,
      required this.cf,
      required this.natIva1,
      required this.natIva2,
      required this.dataFat,
      required this.dataPag,
      required this.importo1,
      required this.importo2,
      required this.protocollo,
      required this.opposizione,
      required this.anticipato,
      required this.tracciato,
      required this.tipoSpesa,
      required this.nDisp,
      required this.nFat});

  Map<String, dynamic> toMap() {
    return {
      "nome": nome,
      "cognome": cognome,
      "cf": cf,
      "proprietario": proprietario,
      "aggiungi": aggiungi,
      "natIva1": natIva1,
      "natIva2": natIva2,
      "dataFat": dataFat,
      "dataPag": dataPag,
      "importo1": importo1,
      "importo2": importo2,
      "protocollo": protocollo,
      "opposizione": opposizione,
      "anticipato": anticipato,
      "tracciato": tracciato,
      "tipoSpesa": tipoSpesa,
      "nDisp": nDisp,
      "nFat": nFat
    };
  }

  @override
  String toString() {
    return 'Fattura {N: $nFat, cf: $cf, Data: $dataFat, Protocollo: $protocollo}';
  }
}
