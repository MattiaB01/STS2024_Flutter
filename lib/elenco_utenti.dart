import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:sqflite/sqflite.dart';
import 'package:sts/dettaglio_utente.dart';
import 'package:sts/sts_db.dart';

import 'utente.dart';

String? user = "";

SQLite sql = SQLite();

Future<String> getUser() async {
  SharedPreferences shared = await SharedPreferences.getInstance();
  String user1 = shared.getString('username')!;

  user = user1;
  return user1;
}

class ElencoUtenti2 extends StatefulWidget {
  @override
  State createState() => _ElencoUtenti();
}

class _ElencoUtenti extends State<ElencoUtenti2> {
  Future<String> a = getUser();

  late Future<List<Utente>> lista;

  @override
  // ignore: must_call_super
  void initState() {
    // ignore: avoid_print
    print("initState Called");

    _setLun();
  }

/*
  Future<int> lun = sql.utenti().then((value) {
    return value.length;
  });
*/

  void _setLun() {
    setState(() {
      try {
        lista = sql.utenti();
      } catch (e) {}
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Elenco utenti'),
          // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          backgroundColor: Colors.blueAccent.withOpacity(0.9),
        ),
        bottomNavigationBar: const BottomAppBar(
          child: Center(
              child: Text(
                  "Seleziona un utente per vedere i dettagli o modificare")),
        ),
        body: SafeArea(
          child: Scrollbar(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text('Pos.'),
                        ),
                        Text('Nome'),
                        Padding(
                          padding: EdgeInsets.only(left: 35),
                          child: Text('Cognome'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text('Cod.Fisc.'),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Utente>>(
                      future: lista,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // until data is fetched, show loader
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData) {
                          //else if (snapshot.hasData) {
                          // once data is fetched, display it on screen (call buildPosts())
                          print("dati: " + snapshot.data!.isEmpty.toString());
                          final utenti = snapshot.data!;

                          if (utenti.isNotEmpty) {
                            return ListView.builder(
                                padding: const EdgeInsets.all(10.0),
                                itemCount: utenti.length,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (ctx, i) => GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DettaglioUtente(
                                                      codfisc: utenti[i].cf)),
                                        );
                                        setState(() {
                                          lista = sql.utenti();
                                        });
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(),
                                        child: Row(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text((i + 1).toString()),
                                          ),

                                          Expanded(child: Text(utenti[i].nome)),
                                          Expanded(
                                              child: Text(utenti[i].cognome)),
                                          Expanded(
                                              flex: 2,
                                              child: Text(utenti[i].cf)),
                                          /*  Expanded(
                                            child:
                                                SizedBox()),*/ // per tenere icona alla fine

                                          IconButton(
                                              onPressed: () => {
                                                    showDialog<String>(
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                                  title: Text(
                                                                      "Elimina"),
                                                                  content: Text(
                                                                      "Confermi l'eliminazione?"),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                        onPressed: () => Navigator.pop(
                                                                            context,
                                                                            'Cancel'),
                                                                        child: Text(
                                                                            "Annulla")),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              {
                                                                        elimina(
                                                                            utenti[i].cf),
                                                                        Navigator.pop(
                                                                            context,
                                                                            'Ok'),
                                                                      },
                                                                      child: Text(
                                                                          "Conferma"),
                                                                    )
                                                                  ],
                                                                ))
                                                  },
                                              icon: Icon(Icons.delete)),
                                        ]),
                                      ),
                                    ));
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: (Text("Nessun utente archiviato")),
                            );
                          }
                        } else {
                          // if no data, show simple Text
                          print("vuoto");
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: (Text("Nessun utente archiviato")),
                          );
                        }
                      }),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> elimina(String cf) async {
    await sql.deleteUtente(cf);
    _setLun();
    print(cf);
  }
}
