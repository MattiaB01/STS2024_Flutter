import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sts/sts_db.dart';
import 'utente.dart';

final cf = TextEditingController();
final nome = TextEditingController();
final cognome = TextEditingController();
final indirizzo = TextEditingController();
final cap = TextEditingController();
final citta = TextEditingController();
final pv = TextEditingController();
final tel = TextEditingController();
final email = TextEditingController();

final sql = SQLite();

class ElencoUtenti extends StatelessWidget {
  const ElencoUtenti({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dati utente'),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
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
        },
      ),
    );
  }
}

void salva() {
  print('asdf');
}

Future<void> _salva(BuildContext context) async {
  Utente? u = await sql.getUtenteByCf(cf.text);
  print("utente" + u.toString());

  Utente utente = Utente(
      cf: cf.text,
      cognome: cognome.text,
      nome: nome.text,
      indirizzo: indirizzo.text,
      cap: cap.text,
      citta: citta.text,
      pv: pv.text,
      tel: tel.text,
      email: email.text);
  if (u?.cf == null && cf.text != "") {
    try {
      await sql.insertUtente(utente);
    } on DatabaseException catch (e) {
      print('errore!');
      print(e);
    }
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
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Errore'),
          content: Text('Cf già esistente o campo cf vuoto'),
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
}

void _cancella() {
  cf.clear();
  nome.clear();
  cognome.clear();
  indirizzo.clear();
  cap.clear();
  citta.clear();
  pv.clear();
  tel.clear();
  email.clear();
}

Future<void> carica() async {
  var prop = await sql.getProprietario();

  try {
    if (prop.isNotEmpty) {
      cf.text = prop[0].username;
    }
  } on Exception catch (e) {
    cf.text = "";
  }
}

String _validate() {
  if (cf.value.text.isEmpty) {
    return 'non può essere vuoto';
  }
  return '';
}

// function to display fetched data on screen
Widget buildUtenti(List<Utente> utenti) {
  // ListView Builder to show data in a list
  return ListView.builder(
    itemCount: utenti.length,
    itemBuilder: (context, index) {
      final post = utenti[index];
      return Container(
        color: Colors.grey.shade300,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        height: 100,
        width: double.maxFinite,
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(flex: 3, child: Text(post.toString()!)),
          ],
        ),
      );
    },
  );
}

Future<void> lista() async {
  List<Utente> utenti = await sql.utenti();
  Utente utente;
  int lun = utenti.length;
  print('lunghezza lista $lun');
  for (utente in utenti) {
    print(utente.toString());
  }
}

Future<void> elimina(String cf) async {
  await sql.deleteUtente(cf);
  print(cf);
}
