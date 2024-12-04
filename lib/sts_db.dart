import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sts/models/fattura.dart';
import 'package:sts/nuova_fattura.dart';

import 'user.dart';

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import "proprietario.dart";
import "utente.dart";

//versione per android
class SQLite {
  Database? _database;

  String nome_db = 'sts.db';

  Future<void> deleteDatabase() async {
    await databaseFactory.deleteDatabase(nome_db);
  }

  Future<void> deleteDatabase2(String path) =>
      databaseFactory.deleteDatabase(path);

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initWinDB();
    return _database!;
  }

  Future<Database> initWinDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), nome_db),
      onCreate: _onCreate,
      version: 1,
    );
    return database;
  }

  Future<void> _onCreate(Database database, int version) async {
    final db = database;
    /* await db.execute(""" CREATE TABLE IF NOT EXISTS users(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            password INTEGER,
            phoneNumber INTEGER
          )
 """);*/

    await db.execute(""" CREATE TABLE IF NOT EXISTS proprietario(
            id INTEGER,
            user TEXT UNIQUE PRIMARY KEY,
            username TEXT,
            password TEXT,
            pincode TEXT,
            piva TEXT
          )
 """);
    await db.execute(""" CREATE TABLE IF NOT EXISTS utente(
            
            user TEXT,
            cf TEXT ,
            nome TEXT,
            cognome TEXT,
            indirizzo TEXT,
            cap TEXT,
            città TEXT,
            pv TEXT,
            tel TEXT,
            email TEXT,
             PRIMARY KEY (user,cf)
          )
 """);

    await db.execute(""" CREATE TABLE IF NOT EXISTS fatture(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            proprietario TEXT,
            cf TEXT,
            nome TEXT, 
            cognome TEXT,
            importo1 REAL,
            dataFat TEXT,
            dataPag TEXT,
            aggiungi TEXT,
            importo2 REAL,
            protocollo TEXT,
            opposizione TEXT,
            anticipato TEXT,
            tracciato TEXT,
            nDisp INTEGER,
            tipoSpesa TEXT,
            natIva1 TEXT,
            natIva2 TEXT,
            nFat TEXT
          )
 """);
  }

  //QUIQQU98A01H501H
  //Salve123
  //3167676525
  //65432109876

  Future<Fattura?> insertFattura(Fattura fattura) async {
    final db = await database;
    try {
      db.insert(
        "fatture",
        fattura.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return fattura;
    } on DatabaseException catch (e) {
      return null;
    }
    return null;
  }

  Future<List<Utente>> utenti() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? user = shared.getString('username');

    final db = await database;

    final List<Map<String, Object?>> utentiMaps =
        await db.query('utente', where: 'user=?', whereArgs: [user]);

    return [
      for (final {
            'user': user as String,
            'cf': cf as String,
            'nome': nome as String,
            'cognome': cognome as String,
            'indirizzo': indirizzo as String,
            'cap': cap as String,
            'città': citta as String,
            'pv': pv as String,
            'tel': tel as String,
            'email': email as String,
          } in utentiMaps)
        Utente(
          user: user,
          cf: cf,
          nome: nome,
          cognome: cognome,
          indirizzo: indirizzo,
          cap: cap,
          citta: citta,
          pv: pv,
          tel: tel,
          email: email,
        ),
    ];
  }

  Future<List<Fattura>> listaFatture() async {
    final db = await database;

    final List<Map<String, Object?>> fattureMaps = await db.query('fatture');

    return [
      for (final {
            'cf': cf as String,
            'username': username as String,
            'nome': nome as String,
            'cognome': cognome as String,
            'proprietario': proprietario as String,
            'importo1': importo1 as double,
            'importo2': importo2 as double,
            'dataFat': dataFat as String,
            'dataPag': dataPag as String,
            'aggiungi': aggiungi as String,
            'protocollo': protocollo as String,
            'opposizione': opposizione as String,
            'anticipato': anticipato as String,
            'tracciato': tracciato as String,
            'nDisp': nDisp as int,
            'tipoSpesa': tipoSpesa as String,
            'natIva1': natIva1 as String,
            'natIva2': natIva2 as String,
            'nFat': nFat as String
          } in fattureMaps)
        Fattura(
          username: username,
          aggiungi: aggiungi,
          cf: cf,
          nome: nome,
          cognome: cognome,
          proprietario: proprietario,
          natIva1: natIva1,
          natIva2: natIva2,
          dataFat: dataFat,
          dataPag: dataPag,
          importo1: importo1,
          importo2: importo2,
          protocollo: protocollo,
          opposizione: opposizione,
          anticipato: anticipato,
          tracciato: tracciato,
          tipoSpesa: tipoSpesa,
          nDisp: nDisp,
          nFat: nFat,
        ),
    ];
  }

  Future<List<Fattura>> listaFattureUser(String? user) async {
    final db = await database;

    final List<Map<String, Object?>> fattureMaps =
        await db.query('fatture', where: 'username=?', whereArgs: [user]);

    return [
      for (final {
            'cf': cf as String,
            'username': username as String,
            'nome': nome as String,
            'cognome': cognome as String,
            'proprietario': proprietario as String,
            'importo1': importo1 as double,
            'importo2': importo2 as double,
            'dataFat': dataFat as String,
            'dataPag': dataPag as String,
            'aggiungi': aggiungi as String,
            'protocollo': protocollo as String,
            'opposizione': opposizione as String,
            'anticipato': anticipato as String,
            'tracciato': tracciato as String,
            'nDisp': nDisp as int,
            'tipoSpesa': tipoSpesa as String,
            'natIva1': natIva1 as String,
            'natIva2': natIva2 as String,
            'nFat': nFat as String
          } in fattureMaps)
        Fattura(
          username: username,
          aggiungi: aggiungi,
          cf: cf,
          nome: nome,
          cognome: cognome,
          proprietario: proprietario,
          natIva1: natIva1,
          natIva2: natIva2,
          dataFat: dataFat,
          dataPag: dataPag,
          importo1: importo1,
          importo2: importo2,
          protocollo: protocollo,
          opposizione: opposizione,
          anticipato: anticipato,
          tracciato: tracciato,
          tipoSpesa: tipoSpesa,
          nDisp: nDisp,
          nFat: nFat,
        ),
    ];
  }

  Future<List<String>> utentiMenu() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? user = shared.getString('username');

    //try {
    final db = await database;

    final List<Map<String, Object?>> utentiMaps =
        await db.query('utente', where: 'user=? ', whereArgs: [user]);

    return [
      for (final {
            'cf': cf as String,
            'nome': nome as String,
            'cognome': cognome as String,
            'indirizzo': indirizzo as String,
            'cap': cap as String,
            'città': citta as String,
            'pv': pv as String,
            'tel': tel as String,
            'email': email as String,
          } in utentiMaps)
        "$cf  $nome $cognome",
    ];
    /*}  on Exception {
      //throw Exception('error fetching data');
      List<String> a = [];
      return a;
    }*/
  }

  Future<Utente?> getUtenteByCf(String cf, String user) async {
    final db = await database;
    if (cf != null) {
      final List<Map<String, dynamic>> utenti = await db.query(
        'utente',
        where: 'cf = ?',
        whereArgs: [cf],
      );
      if (utenti.isNotEmpty) {
        return Utente(
          user: utenti[0]['user'],
          cf: utenti[0]['cf'],
          nome: utenti[0]['nome'],
          email: utenti[0]['email'],
          cognome: utenti[0]['cognome'],
          indirizzo: utenti[0]['indirizzo'],
          cap: utenti[0]['cap'],
          pv: utenti[0]['pv'],
          tel: utenti[0]['tel'],
          citta: utenti[0]['città'],
        );
      }
    }
  }

  Future<void> deleteUtente(String cf) async {
    final db = await database;
    //int i = await db.rawDelete('DELETE FROM utente WHERE id = ?', ['1']);

    //print(await db.query('utente', where: 'id=?', whereArgs: [id]));
    //  await db.rawDelete('delete from utente where id=0');
    //print(id);
    try {
      await db.delete(
        'utente',
        where: 'cf = ?',
        whereArgs: [cf],
      );
      print('cancellato');
    } catch (e) {
      print(e);
    }
    //print("i " + i.toString());
  }

  Future<Utente?> insertUtente(Utente utente) async {
    final db = await database;
    try {
      db.insert(
        "utente",
        utente.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return utente;
    } on DatabaseException catch (e) {
      return null;
    }
    return null;
  }

  Future<Proprietario> insertProp(Proprietario prop) async {
    final db = await database;
    db.insert(
      "proprietario",
      prop.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return prop;
  }

  Future<User> insertUSer(User user) async {
    final db = await database;
    db.insert(
      "users",
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return user;
  }

  Future<List<Proprietario>> getProprietario() async {
    final db = await database;
    SharedPreferences shared = await SharedPreferences.getInstance();
    String? user = await shared.getString('username');

    print("proprietario $user");
    final List<Map<String, dynamic>> maps =
        await db.query('proprietario', where: 'user=?', whereArgs: [user]);

    return List.generate(maps.length, (index) {
      return Proprietario(
        //id: maps[index]['id'],
        username: maps[index]['username'],
        password: maps[index]['password'],
        pincode: maps[index]['pincode'],
        piva: maps[index]['piva'],
        user: maps[index]['user'],
      );
    });
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    final Batch batch = db.batch();

    batch.delete('users');

    await batch.commit();
  }
}
