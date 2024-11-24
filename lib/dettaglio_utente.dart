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

class DettaglioUtente extends StatelessWidget {
  const DettaglioUtente({super.key, required this.codfisc});
  final String codfisc;

  @override
  Widget build(BuildContext context) {
    Future<void> carica() async {
      SQLite();
      Utente? utente = await sql.getUtenteByCf(codfisc);

      try {
        if (utente != null) {
          cf.text = utente.cf;
          nome.text = utente.nome;
          cognome.text = utente.cognome;
          indirizzo.text = utente.indirizzo;
          cap.text = utente.cap;
          citta.text = utente.citta;
          pv.text = utente.pv;
          tel.text = utente.tel;
          email.text = utente.email;
        }
      } on Exception {}
    }

    carica();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli utente'),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Compila con i dati utente'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: nome,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'nome',
                        ),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: cognome,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'cognome',
                        ),
                      ),
                    )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        enabled: false,
                        controller: cf,
                        maxLength: 16,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'codice fiscale',
                        ),
                      ),
                    )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: indirizzo,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'indirizzo',
                        ),
                      ),
                    )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: cap,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'cap',
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: citta,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'città',
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 70,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: pv,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'pv',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: tel,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'tel',
                        ),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        controller: email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'email',
                        ),
                      ),
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          onPressed: _cancella,
                          child: Text('Cancella')),
                      //ElevatedButton(onPressed: lista, child: Text('lista'))
                    ],
                  ),
                ),
                /*
                FutureBuilder<List<Utente>>(
                  future: sql.utenti(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // until data is fetched, show loader
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      // once data is fetched, display it on screen (call buildPosts())
                      final utenti = snapshot.data!;
                      return buildUtenti(utenti);
                    } else {
                      // if no data, show simple Text
                      return const Text("No data available");
                    }
                  },
                ),*/
              ],
            )),
          ),
        ),
      ),
    );
  }
}

void salva() {
  print('asdf');
}

Future<void> _salva(BuildContext context) async {
  //Utente? u = await sql.getUtenteByCf(cf.text);
//print("utente" + u.toString());

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
  //if (u?.cf == null && cf.text != "") {
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
              //Navigator.of(context).pop();
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
} /*else {
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
}*/

void _cancella() {
  nome.clear();
  cognome.clear();
  indirizzo.clear();
  cap.clear();
  citta.clear();
  pv.clear();
  tel.clear();
  email.clear();
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
            Expanded(flex: 3, child: Text(post.toString())),
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
