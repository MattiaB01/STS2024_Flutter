import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sts/proprietario.dart';
import 'sts_db.dart';

import 'package:restart_app/restart_app.dart';

import 'package:path_provider/path_provider.dart';

import 'package:file_picker/file_picker.dart';

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
  bool? backup = false;
  bool? importaDb = false;

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
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.black),
                      child: CheckboxListTile(
                          activeColor: Colors.blueAccent.withOpacity(0.9),
                          title: const Text("Esegui backup database"),
                          value: backup,
                          onChanged: (bool? value) => setState(() {
                                backup = value!;
                              })),
                    ),
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.black),
                      child: CheckboxListTile(
                          activeColor: Colors.blueAccent.withOpacity(0.9),
                          title: const Text(
                              "Importa backup database, l'app verrà riavviata"),
                          value: importaDb,
                          onChanged: (bool? value) => setState(() {
                                importaDb = value!;
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
                  //SQLite();
                }

                if (backup!) {
                  eseguiBackup();
                }
                if (importaDb!) {
                  importaBackup();
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> importaBackup() async {
/*    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }*/

    sql.closeDb();
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    File dest = File('${appDocDirectory.path}/Backup_sts.db');

    (await dest.exists()) ? print("esiste") : print("non trovato");

    if (await dest.exists()) {
      final dbFolder = await getDatabasesPath();
      File source1 = File('$dbFolder/sts.db');
      dest.copy("$dbFolder/sts.db");
    }

    Restart.restartApp();
  }

  Future<void> eseguiBackup() async {
    // var dir = await getApplicationDocumentsDirectory();
    final dbFolder = await getDatabasesPath();
    File source1 = File('$dbFolder/sts.db');

    bool a = await source1.exists();

    (a) ? print("esiste") : print("non esiste");

    print(source1.toString());
    //Directory copyTo = Directory("storage/emulated/0/Sqlite Backup");
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    try {
      source1.copy('${appDocDirectory.path}/Backup_sts.db');
    } catch (e) {
      log(e.toString());
    }

    final Email email = Email(
      body: 'Backup database STS',
      subject: 'Backup database STS',
      recipients: [''],
      //cc: ['cc@example.com'],
      //bcc: ['bcc@example.com'],
      attachmentPaths: ['${appDocDirectory.path}/Backup_sts.db'],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);

    /*   if ((await copyTo.exists())) {
                  // print("Path exist");
                  var status = await Permission.storage.status;
                 widget if (!status.isGranted) {
                    await Permission.storage.request();
                  }
                } else {
                  print("not exist");
                  if (await Permission.storage.request().isGranted) {
                    // Either the permission was already granted before or the user just granted it.
                    await copyTo.create();
                  } else {
                    print('Please give permission');
                  }*/
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
