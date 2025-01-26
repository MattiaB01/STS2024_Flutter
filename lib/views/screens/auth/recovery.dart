import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sts/main.dart';
import 'package:sts/menu_principale.dart';
import 'package:sts/models/user.dart';
import 'package:sts/views/screens/auth/login.dart';
import 'package:sts/views/screens/auth/signup.dart';
import 'package:sts/views/screens/main/mainScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:sts/controllers/proxy.dart';

final username = TextEditingController();
final codice = TextEditingController();
final password = TextEditingController();

bool isLoading = false;
bool isLoading2 = false;
bool visibile = true;

class Recovery extends StatefulWidget {
  const Recovery({super.key});

  @override
  State<Recovery> createState() => _RecoveryState();
}

class _RecoveryState extends State<Recovery> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future<String> pathDb() async {
    String path = await getDatabasesPath();
    print(path);
    final file = File("${path}/sts.db");
    final Directory directory = Directory(path);
    final List<FileSystemEntity> files = directory.listSync();

    for (final FileSystemEntity file in files) {
      final FileStat fileStat = await file.stat();
      print('Path: ${file.path}');
      print('Type: ${fileStat.type}');
      print('Changed: ${fileStat.changed}');
      print('Modified: ${fileStat.modified}');
      print('Accessed: ${fileStat.accessed}');
      print('Mode: ${fileStat.mode}');
      print('Size: ${fileStat.size}');
    }
    /*
    final file3 = File("${path}/sts_copia.db");

    try {
      var file2 = File(path);
      file2.copy(file3.toString());
      return path;
    } catch (e) {
      log(e.toString());
    }*/
    return path;
  }

  @override
  initState() {
    super.initState();
    print("initState Called");
    username.clear();
    codice.clear();
    password.clear();
    pathDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 68, 138, 255).withOpacity(0.9),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Center(
            //per centrare orrizontalmente
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  //allinamento centrale verticale
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),

                              spreadRadius: 15,
                              blurRadius: 30,
                              offset: const Offset(
                                  0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(150),
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(150),
                            child: Image.asset(
                              'assets/images/STS_Logo.PNG',

                              fit: BoxFit.cover,

                              // width: 300,
                              // height: 300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text(
                        'Recupera la password',
                        style: GoogleFonts.getFont(
                          'Lato',
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: TextFormField(
                          controller: username,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'inserisci username';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.white),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              //focusedBorder: InputBorder.none,
                              //enabledBorder: InputBorder.none,
                              //labelText: 'inserisci il tuo username',
                              hintText: 'username',
                              hintStyle: const TextStyle(color: Colors.grey),
                              labelStyle: GoogleFonts.getFont(
                                'Nunito Sans',
                                fontSize: 14,
                                letterSpacing: 0.1,
                              ),
                              prefixIcon: Icon(Icons.people))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 32),
                          child: Text('Ricevi il ',
                              style: TextStyle(fontSize: 14)),
                        ),
                        InkWell(
                          onTap: () {
                            inviaCodice();
                          },
                          child: const Text(
                            ' codice di sicurezza',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        if (isLoading)
                          const Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: TextFormField(
                          obscureText: visibile,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: codice,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'inserisci il codice di sicurezza';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              //focusedBorder: InputBorder.none,
                              //enabledBorder: InputBorder.none,
                              //labelText: 'password',
                              hintText: 'codice di sicurezza',
                              hintStyle: const TextStyle(color: Colors.grey),
                              labelStyle: GoogleFonts.getFont(
                                'Nunito Sans',
                                fontSize: 14,
                                letterSpacing: 0.1,
                              ),
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      visibile = !visibile;
                                    });
                                  },
                                  icon: Icon(Icons.visibility)))),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 32),
                          child: Text(
                              'Inserisci il codice ricevuto nella email di registrazione ',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: TextFormField(
                          obscureText: visibile,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'inserisci il codice di sicurezza';
                            } else
                              return null;
                          },
                          decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.white),
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              //focusedBorder: InputBorder.none,
                              //enabledBorder: InputBorder.none,
                              //labelText: 'password',
                              hintText: 'inserisci la nuova password',
                              hintStyle: const TextStyle(color: Colors.grey),
                              labelStyle: GoogleFonts.getFont(
                                'Nunito Sans',
                                fontSize: 14,
                                letterSpacing: 0.1,
                              ),
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      visibile = !visibile;
                                    });
                                  },
                                  icon: Icon(Icons.visibility)))),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading2 = true;
                          });
                          final resp = await modificaPw();
                          String a;
                          if (resp == 200) {
                            a = "Password modificata";
                            Navigator.pushAndRemoveUntil<void>(context,
                                MaterialPageRoute(builder: (context) {
                              //return Mainscreen(username.text);
                              return Login();
                            }), (Route<dynamic> route) => false);
                          } else if (resp != 0) {
                            a = "Login errato";
                          } else {
                            a = "Si è verificato un errore";
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(a)));
                          setState(() {
                            isLoading2 = false;
                          });
                        }
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(5),
                          gradient: LinearGradient(
                              colors: [Colors.blue, Colors.lightBlue]),
                        ),
                        child: Center(
                            child: isLoading2
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    'Modifica',
                                    style: GoogleFonts.getFont('Lato',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Torna a '),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Login();
                            }));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<int> modificaPw() async {
    setState(() {
      isLoading2 = true;
    });

    try {
      Proxy p = Proxy();

      String url = "http://" + p.getProxy() + "/recovery";
      print("connessione a : $url");

      final response = await http.post(Uri.parse(url), headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      }, body: <String, String>{
        "username": username.text,
        "uuid": codice.text,
        "newPw": password.text,
      }).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('Success!');
        setState(() {
          isLoading2 = false;
        });

        return 200;
      } else {
        print('Failed' + response.statusCode.toString());
        setState(() {
          isLoading2 = false;
        });

        return 400;
      }
    } catch (e) {
      setState(() {
        isLoading2 = false;
      });
      log(e.toString());

      return 0;
    }
  }

  Future<int> emailHttp() async {
    setState(() {
      isLoading = true;
    });

    try {
      Proxy p = Proxy();

      String url = "http://" + p.getProxy() + "/email";
      print("connessione a : $url");

      final response = await http.post(Uri.parse(url), headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      }, body: <String, String>{
        "username": username.text,
      }).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('Success!');
        setState(() {
          isLoading = false;
        });

        return 200;
      } else {
        print('Failed' + response.statusCode.toString());
        setState(() {
          isLoading = false;
        });

        return 400;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log(e.toString());

      return 0;
    }
  }

  void inviaCodice() async {
    int ret = await emailHttp();
    log(ret.toString());
    if (ret.toString() == "200") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Codice inviato alla tua email di registrazione'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Si è verificato un errore'),
        ),
      );
    }
  }
}
