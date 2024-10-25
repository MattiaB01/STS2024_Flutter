import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'utente.dart';
import 'sts_db.dart';

SQLite sql = SQLite();

class ElencoUtenti2 extends StatefulWidget {
  @override
  State createState() => _ElencoUtenti();
}

class _ElencoUtenti extends State<ElencoUtenti2> {
  Future<List<Utente>> lista = sql.utenti();

  void _aggiornaLista() {
    setState(() {
      lista = sql.utenti();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Stateful Widget'),
        ),
        body: FutureBuilder<List<Utente>>(
            future: sql.utenti(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // until data is fetched, show loader
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                // once data is fetched, display it on screen (call buildPosts())
                final utenti = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: utenti.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (ctx, i) => Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text((i + 1).toString()),
                    ),
                    Expanded(child: Text(utenti[i].cf)),
                    Expanded(child: Text(utenti[i].nome)),
                    Expanded(child: Text(utenti[i].cognome)),
                    Expanded(child: SizedBox()), // per tenere icona alla fine
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.update),
                    ),
                    IconButton(
                        onPressed: () => elimina(utenti[i].cf),
                        icon: Icon(Icons.delete)),
                  ]),
                );
              } else {
                // if no data, show simple Text
                return const Text("No data available");
              }
            }));
  }
}

Future<void> elimina(String cf) async {
  await sql.deleteUtente(cf);
  print(cf);
}
