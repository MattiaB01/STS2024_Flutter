import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sts/dettaglio_fattura.dart';
import 'package:sts/models/fattura.dart';
import 'package:sts/proprietario.dart';

import 'sts_db.dart';

import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:sts/controllers/proxy.dart';

TextEditingController dallaData = TextEditingController();
TextEditingController allaData = TextEditingController();

SQLite sql = SQLite();
late String id;

class ElencoFatture extends StatefulWidget {
  @override
  State createState() => _ElencoUtenti();
}

class _ElencoUtenti extends State<ElencoFatture> {
  // var response = fetchFatture();

  var response = listaFattureDb();

  @override
  void initState() {
    dallaData.clear();
    allaData.clear();
    _setLun();
  }

/*
  Future<List<Utente>> lista = sql.utenti();

  Future<int> lun = sql.utenti().then((value) {
    return value.length;
  });*/
  void _setLun() {
    setState(() {
      //lista = sql.utenti();
      response = listaFattureDb();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Elenco fatture inviate'),
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          backgroundColor: Colors.blueAccent.withOpacity(0.9),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 140,
          /*child: Center(
              child: Text(
                  "Seleziona una fattura per vedere i dettagli o modificare")),*/
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        controller: dallaData,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(
                              fontSize: 10,
                            ),
                            labelText: "dalla data",
                            floatingLabelStyle: TextStyle(
                              fontSize: 14,
                            )),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2040),
                          );

                          if (pickedDate != null) {
                            print(pickedDate);
                            String formatDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            print(formatDate);

                            setState(() {
                              dallaData.text = formatDate;
                            });
                          }
                        }),
                  )),
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        controller: allaData,
                        decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            labelStyle: TextStyle(
                              fontSize: 10,
                            ),
                            labelText: "alla data",
                            floatingLabelStyle: TextStyle(
                              fontSize: 14,
                            )),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2040),
                          );

                          if (pickedDate != null) {
                            print(pickedDate);
                            String formatDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);
                            print(formatDate);

                            setState(() {
                              allaData.text = formatDate;
                            });
                          }
                        }),
                  )),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(5),
                      backgroundColor: Colors.blueAccent.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),

                        //borderRadius: BorderRadius.zero, //Rectangular border
                      ),
                    ),
                    child: const Text("Applica filtro"),
                    onPressed: () => {
                      setState(() {
                        response = sql.listaFattureUserFiltro(
                            dallaData.text, allaData.text);
                      }),
                    },
                  ),
                ],
              ),
              const Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Text(
                    "Seleziona una fattura per vedere i dettagli o modificare"),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Scrollbar(
            child: Column(
              children: [
                const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Card(
                    shape: RoundedRectangleBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: Text('N.')),
                        Expanded(flex: 6, child: Text('Data')),
                        Expanded(flex: 5, child: Text('Nome')),
                        Expanded(flex: 12, child: Text('Cognome')),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Fattura>>(
                      future: response,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // until data is fetched, show loader
                          return const SizedBox(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } //else if (!snapshot.data!.isEmpty) {
                        else if (snapshot.hasData) {
                          // once data is fetched, display it on screen (call buildPosts())
                          print("dati:   $snapshot.data!.isEmpty.toString()");
                          final fattura = snapshot.data!;

                          if (fattura.isNotEmpty) {
                            return ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: fattura.length,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (ctx, i) => GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DettaglioFattura(
                                                      nProtocollo: fattura[i]
                                                          .protocollo)),
                                        ).then((_) => _setLun());
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(),
                                        child: Row(children: [
                                          Expanded(
                                              flex: 4,
                                              child: Text(fattura[i].nFat)),
                                          Expanded(
                                              flex: 12,
                                              child:
                                                  (fattura[i].dataFat != null)
                                                      ? Text(fattura[i].dataFat)
                                                      : Text('vuoto')),
                                          Expanded(
                                              flex: 10,
                                              child: Text(fattura[i].nome)),

                                          Expanded(
                                            flex: 15,
                                            child: Text(
                                                fattura[i].cognome ?? 'vuoto'),
                                          ),

                                          // Expanded(child: Text(utenti[i].cf)),
                                          const Expanded(
                                              child:
                                                  SizedBox()), // per tenere icona alla fine
                                          /* IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.update),
                                        ),*/
                                          IconButton(
                                              onPressed: () {
                                                showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                          title:
                                                              Text("Elimina"),
                                                          content: const Text(
                                                              "Confermi l'eliminazione?\nLa fattura verrà eliminata anche dal Sistema tessera sanitaria."),
                                                          actions: <Widget>[
                                                            TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context,
                                                                        'Cancel'),
                                                                child: const Text(
                                                                    "Annulla")),
                                                            TextButton(
                                                              onPressed: () => {
                                                                print(fattura[i]
                                                                    .protocollo),
                                                                id = fattura[i]
                                                                    .protocollo,
                                                                deleteFattura(),
                                                                Navigator.pop(
                                                                    context,
                                                                    'Ok'),
                                                              },
                                                              child: const Text(
                                                                  "Conferma"),
                                                            )
                                                          ],
                                                        ));
                                              }, // => elimina(utenti[i].cf),
                                              icon: Icon(Icons.delete)),
                                        ]),
                                      ),
                                    ));
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: (Text("Nessuna fattura trovata")),
                            );
                          }
                        } else {
                          // if no data, show simple Text
                          print("vuoto");
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: (Text("Nessuna fattura trovata")),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> deleteFattura() async {
    print("delete");

    //per cancellare dal server
    var proxy = Proxy().getProxy();
    try {
      var result = await http.post(Uri.parse(
          //"http://10.0.2.2:8080/elenco"))
          "http://$proxy/delete?protocollo=$id")).timeout(Duration(seconds: 5));
      print("try...");
      _setLun();
    } catch (e) {
      print(e.toString());
    }

    //per cancellare dal sts
    try {
      Fattura fattura = await sql.getFatturaByProtocollo(id);
      List<Proprietario> proprietario = await sql.getProprietario();

      late final imp2;
      late final naturaBollo;
      if (aggiungi) {
        //aggiunta = "SI";
        imp2 = importo2.text;
        naturaBollo = natIva2;
      } else {
        //aggiunta = "";
        imp2 = "";
        naturaBollo = "";
      }

      final body = jsonEncode({
        "proprietario": {
          /*
      "username": ",
      "password": "Salve123",
      "pincode": "3167676525",
      "piva": "65432109876",*/

          "username": proprietario[0].username,
          "password": proprietario[0].password,
          "pincode": proprietario[0].pincode,
          "piva": proprietario[0].piva,
        },
        "fattura": {
          "username": fattura.username,
          "proprietario": fattura.proprietario,
          "utente": fattura.cf,
          "dataFat": dataFat.text,
          "dataPag": dataPag.text,
          "numFat": nFat.text,
          "impTot1": importo1.text,
          "natIva1": natIva1,
          "tipoSpesa": tipoSpesa,
          "aggiungi": aggiungi,
          "bollo": imp2,
          "natIva2": naturaBollo,
          "numDisp": nDisp.text,
          "tracciato": tracciato ? "SI" : "NO",
          "opposizione": opposiz ? "SI" : "NO",
          "anticipato": anticip ? "SI" : "NO",
        }
      });
      final url =
          //Uri.parse('http://10.0.2.2:8080/invio'); //Repclace Your Endpoint
          Uri.parse('http://$proxy/eliminaInvio'); //Repclace Your Endpoint
      final headers = {'Content-Type': 'application/json'};

      final response = await http.post(url, headers: headers, body: body);
      //per cancellare db locale
      try {
        log("invio protocollo $id");
        sql.deleteFattura(id);
        _setLun();
      } catch (e) {
        log(e.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

Future<List<Fattura>> listaFattureDb() async {
  SharedPreferences shared = await SharedPreferences.getInstance();
  String? user = shared.getString('username');

  //var listaFatture = await sql.listaFatture();  //tutte le fatture senza filtro username
  List<Fattura> listaFatture = [];
  try {
    listaFatture = await sql.listaFattureUser(user);
    for (Fattura f in listaFatture) {
      log("nomi trovati");
      print(f.nome);
    }
    ;
  } catch (e) {}
  return listaFatture;
}

Future<List<dynamic>> fetchFatture() async {
  var proxy = Proxy().getProxy();
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  var result = await http
      .get(Uri.parse(
          //"http://10.0.2.2:8080/elenco"))
          "http://$proxy/elenco?username=$username"))
      .timeout(Duration(seconds: 10));
  return jsonDecode(result.body)['fatture'];
}
