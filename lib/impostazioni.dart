import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sts/proprietario.dart';
import 'sts_db.dart';

class Impostazioni extends StatelessWidget {
  const Impostazioni({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impostazioni'),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
      ),
      body: const impostazioni(),
    );
  }
}

class impostazioni extends StatefulWidget {
  const impostazioni({super.key});

  @override
  State<impostazioni> createState() => _impostazioni();
}

class _impostazioni extends State<impostazioni> {
  bool? delete = false;
  bool? demo = false;

  SQLite sql = SQLite();

  @override
  Widget build(BuildContext context) {
    //ottieniLista();
    //print('lista: $_lista');
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(2)),
          margin: EdgeInsets.all(20),
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2))),
            onPressed: () {
              _dialogBuilder(context);
            },
            child: const Center(
              child: Text('Conferma'),
            ),
          ),
        ),
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
        body: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(50)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.black),
                      child: CheckboxListTile(
                          activeColor: Colors.blueAccent.withOpacity(0.9),
                          title: const Text(
                              "Elimina database con tutti i suoi dati"),
                          value: delete,
                          onChanged: (bool? value) => setState(() {
                                delete = value!;
                              })),
                    ),
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.black),
                      child: CheckboxListTile(
                          activeColor: Colors.blueAccent.withOpacity(0.9),
                          title: const Text(
                              "Carica dati proprietario per uso dimostrativo"),
                          value: demo,
                          onChanged: (bool? value) => setState(() {
                                demo = value!;
                              })),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sei sicuro?'),
          content: const Text(
            'Verranno applicate tutte le modifiche selezionate. ',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Continua'),
              onPressed: () {
                if (demo!) {
                  proprietarioDemo();
                }

                if (delete!) {
                  sql.deleteDatabase();
                  SQLite();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> proprietarioDemo() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? user = await shared.getString('username');
    log("$user");
    Proprietario prop = Proprietario(
        user: user!,
        username: "QUIQQU98A01H501H",
        password: "Salve123",
        pincode: "3167676525",
        piva: "65432109876");

    await sql.insertProp(prop);
  }
}
