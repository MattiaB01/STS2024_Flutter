import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sts/dettagli_fatture.dart';
import 'package:sts/models/fattura.dart';
import 'utente.dart';
import 'sts_db.dart';

import 'package:http/http.dart' as http;
import 'package:sts/controllers/proxy.dart';

SQLite sql = SQLite();
late String id;

class ElencoFatture extends StatefulWidget {
  @override
  State createState() => _ElencoUtenti();
}

class _ElencoUtenti extends State<ElencoFatture> {
  var response = fetchFatture();

/*
  Future<List<Utente>> lista = sql.utenti();

  Future<int> lun = sql.utenti().then((value) {
    return value.length;
  });*/

  void _setLun() {
    setState(() {
      //lista = sql.utenti();
      response = fetchFatture();
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
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('N.'),
                        ),
                        Expanded(flex: 6, child: Text('Cod.Fisc.')),
                        Expanded(flex: 12, child: Text('Data')),
                        Expanded(flex: 14, child: Text('Protocollo')),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                      future: response,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // until data is fetched, show loader
                          return const SizedBox(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (!snapshot.data!.isEmpty) {
                          // once data is fetched, display it on screen (call buildPosts())
                          print("dati: " + snapshot.data!.isEmpty.toString());
                          final fattura = snapshot.data!;

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
                                                DettagliFatture()),
                                      );
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(),
                                      child: Row(children: [
                                        Expanded(
                                            flex: 6,
                                            child: Text(fattura[i]['nFat'])),
                                        Expanded(
                                            flex: 16,
                                            child: (fattura[i]['cf'] != null)
                                                ? Text(fattura[i]['cf'])
                                                : Text('vuoto')),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(fattura[i]['dataFat']),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(fattura[i]
                                                  ['protocollo'] ??
                                              'vuoto'),
                                        ),

                                        // Expanded(child: Text(utenti[i].cf)),
                                        Expanded(
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
                                                        title: Text("Elimina"),
                                                        content: Text(
                                                            "Confermi l'eliminazione?"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      'Cancel'),
                                                              child: Text(
                                                                  "Annulla")),
                                                          TextButton(
                                                            onPressed: () => {
                                                              print(fattura[i][
                                                                  'protocollo']),
                                                              id = fattura[i][
                                                                  'protocollo'],
                                                              deleteFattura(),
                                                              Navigator.pop(
                                                                  context,
                                                                  'Ok'),
                                                            },
                                                            child: Text(
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
                          // if no data, show simple Text
                          print("vuoto");
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: (const Text("Nessuna fattura trovata")),
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
  }
}

/*
Future <List<dynamic> feychFattureDb() async {

      
}*/

Future<List<dynamic>> fetchFatture() async {
  var proxy = Proxy().getProxy();
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username');
  var result = await http.get(Uri.parse(
      //"http://10.0.2.2:8080/elenco"))
      "http://$proxy/elenco?username=$username")).timeout(Duration(seconds: 5));
  return jsonDecode(result.body)['fatture'];
}
