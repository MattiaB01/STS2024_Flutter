import 'dart:math';
import 'package:sts/models/fattura.dart';

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
    await db.execute(""" CREATE TABLE IF NOT EXISTS users(
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            password INTEGER,
            phoneNumber INTEGER
          )
 """);

    await db.execute(""" CREATE TABLE IF NOT EXISTS proprietario(
            id INTEGER PRIMARY KEY,
            username TEXT,
            password TEXT,
            pincode TEXT,
            piva TEXT
          )
 """);
    await db.execute(""" CREATE TABLE IF NOT EXISTS utente(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cf TEXT UNIQUE,
            nome TEXT,
            cognome TEXT,
            indirizzo TEXT,
            cap TEXT,
            città TEXT,
            pv TEXT,
            tel TEXT,
            email TEXT
          )
 """);

    await db.execute(""" CREATE TABLE IF NOT EXISTS fatture(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            proprietario TEXT,
            cf TEXT,
            nome TEXT, 
            cognome TEXT,
            importo1 REAL,
            dataFat TEXT,
            dataPag TEXT,
            aggiungi TEXT,
            importo2 REAL,
            protocollo INTEGER,
            opposizione TEXT,
            anticipato TEXT,
            tracciato TEXT,
            nDisp TEXT,
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
    final db = await database;

    final List<Map<String, Object?>> utentiMaps = await db.query('utente');

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
        Utente(
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

  Future<List<String>> utentiMenu() async {
    try {
      final db = await database;

      final List<Map<String, Object?>> utentiMaps = await db.query('utente');

      return await [
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
    } on Exception {
      throw Exception('error fetching data');
    }
  }

  Future<Utente?> getUtenteByCf(String cf) async {
    final db = await database;
    if (cf != null) {
      final List<Map<String, dynamic>> utenti = await db.query(
        'utente',
        where: 'cf = ?',
        whereArgs: [cf],
      );
      if (utenti.isNotEmpty) {
        return Utente(
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

  Future<List<User>> batchInsert() async {
    final db = await database;
    final batch = db.batch();
    final Random random = Random();
    final List<User> userList = List.generate(
      1000,
      (index) => User(
        id: index + 1,
        name: 'User $index',
        email: 'user$index@example.com',
        password: random.nextInt(9999),
        phoneNumber: random.nextInt(10000),
      ),
    );
    for (final User user in userList) {
      batch.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
    return userList;
  }

  Future<List<Proprietario>> getProprietario() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('proprietario');

    return List.generate(maps.length, (index) {
      return Proprietario(
        id: maps[index]['id'],
        username: maps[index]['username'],
        password: maps[index]['password'],
        pincode: maps[index]['pincode'],
        piva: maps[index]['piva'],
      );
    });
  }

  Future<List<User>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (index) {
      return User(
        id: maps[index]['id'],
        name: maps[index]['name'],
        email: maps[index]['email'],
        password: maps[index]['password'],
        phoneNumber: maps[index]['phoneNumber'],
      );
    });
  }

  Future<User?> getUserById(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        name: maps[0]['name'],
        email: maps[0]['email'],
        password: maps[0]['password'],
        phoneNumber: maps[0]['phoneNumber'],
      );
    }

    return null;
  }

  Future<void> deleteAllUsers() async {
    final db = await database;
    final Batch batch = db.batch();

    batch.delete('users');

    await batch.commit();
  }
}
