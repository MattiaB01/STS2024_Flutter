import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'utente.dart';
import 'sts_db.dart';

import 'package:http/http.dart' as http;
import 'package:sts/controllers/proxy.dart';

SQLite sql = SQLite();
late String id;

class DettagliFatture extends StatefulWidget {
  @override
  State createState() => _ElencoUtenti();
}

class _ElencoUtenti extends State<DettagliFatture> {
/*
  Future<List<Utente>> lista = sql.utenti();

  Future<int> lun = sql.utenti().then((value) {
    return value.length;
  });*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Dettaglio fattura'),
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          backgroundColor: Colors.blueAccent.withOpacity(0.9),
        ),
        body: const Column(
          children: [
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Card(
                shape: RoundedRectangleBorder(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [],
                ),
              ),
            ),
          ],
        ));
  }
}
