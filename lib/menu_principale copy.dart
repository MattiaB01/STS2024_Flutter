import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite/sqflite.dart';
import 'proprietario_routes.dart';
import 'sts_db.dart';
import 'utente_routes.dart';
//import 'elenco_utenti_routes.dart';
import 'elenco_utenti.dart';
//import 'package:local_auth/local_auth.dart';
//import 'dart:io' show Platform;
import 'auth.dart';
import 'nuova_fattura.dart';
import 'elenco_fatture.dart';
import 'views/screens/auth/login.dart';

/*void main() async {
  SQLite sql = SQLite();
  //runApp(const MyApp());
  runApp(Login());
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SQLite sql = SQLite();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Sistema tessera sanitaria'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.psychology,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title, style: TextStyle(fontSize: 18)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Column(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProprietarioRoute()),
                    );
                  },
                  child: Text('I tuoi dati')),
            )),
            FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UtentiRoute()),
                  );
                },
                child: Text('Nuovo utente')),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: FilledButton(
                  onPressed: () async {
                    bool a = await Auth.auth();
                    bool test = true; //sostiture test nell'if
                    if (test) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ElencoUtenti2()),
                      );
                    }
                  },
                  child: Text('Elenco utenti')),
            ),
            FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NuovaFattura()),
                  );
                },
                child: Text('Nuova fattura')),
            FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ElencoFatture()),
                  );
                },
                child: Text('Elenco fatture')),
          ],
        ),
      ]),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
