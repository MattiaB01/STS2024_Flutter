import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sts/proprietario.dart';
import 'package:sts/sts_db.dart';

final cf = TextEditingController();
final pw = TextEditingController();
final pc = TextEditingController();
final pi = TextEditingController();

final sql = SQLite();

class ProprietarioRoute extends StatelessWidget {
  const ProprietarioRoute({super.key});
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    cf.dispose();
    pw.dispose();
    pc.dispose();
    pi.dispose();
  }

  @override
  Widget build(BuildContext context) {
    carica();
    return Scaffold(
      appBar: AppBar(
        title: const Text('I tuoi dati'),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const ListTile(
              leading: Icon(Icons.abc),
              title: Text('Compila con tutti i tuoi dati'),
              subtitle: Text("Questo permetterà di inviare le fatture al sts "),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: cf,
                decoration: const InputDecoration(
                  labelText: 'codice fiscale',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pw,
                decoration: const InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pc,
                decoration: const InputDecoration(
                  labelText: 'pincode',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: pi,
                decoration: const InputDecoration(
                  labelText: 'p.iva',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _salva(context);
                      },
                      child: const Text('Salva')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: carica,
                    child: Text('Carica'),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: cancella,
                      child: Text('Cancella')),
                ],
              ),
            )
          ])),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: deleteDb,
        child: Icon(Icons.delete),
      ),
    );
  }
}

void deleteDb() {
  sql.deleteDatabase();
  SQLite();
}

void salva() {
  print('asdf');
}

Future<void> _salva(BuildContext context) async {
  Proprietario prop = Proprietario(
      id: 1,
      username: cf.text,
      password: pw.text,
      pincode: pc.text,
      piva: pi.text);

  await sql.insertProp(prop);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Esito'),
        content: Text('Dati salvati correttamente'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void cancella() {
  cf.clear();
  pw.clear();
  pi.clear();
  pc.clear();
}

Future<void> carica() async {
  var prop = await sql.getProprietario();

  try {
    if (prop.isNotEmpty) {
      cf.text = prop[0].username;
      pw.text = prop[0].password;
      pc.text = prop[0].pincode;
      pi.text = prop[0].piva;
    }
  } on Exception {
    cf.text = "";
    pw.text = "";
    pc.text = "";
    pi.text = "";
  }
}
