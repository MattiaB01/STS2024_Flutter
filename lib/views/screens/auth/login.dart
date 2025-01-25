import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sts/main.dart';
import 'package:sts/menu_principale.dart';
import 'package:sts/models/user.dart';
import 'package:sts/views/screens/auth/signup.dart';
import 'package:sts/views/screens/main/mainScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:sts/controllers/proxy.dart';

final username = TextEditingController();
final password = TextEditingController();

bool isLoading = false;
bool visibile = true;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
    password.clear();
    pathDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 68, 138, 255).withOpacity(0.9),
      body: Container(
        /*decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/sfondo.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.5),
            BlendMode.dstATop,
          ),
        )),*/
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
                    /*  Text(
                      'Sistema Tessera Sanitaria',
                      style: GoogleFonts.getFont('Lato',
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),*/
                    const SizedBox(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
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
                      height: 70,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text(
                        'Accedi al tuo account',
                        style: GoogleFonts.getFont(
                          'Lato',
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Text('per continuare',
                          style: GoogleFonts.getFont(
                            'Lato',
                            fontSize: 14,
                            letterSpacing: 0.2,
                          )),
                    ),*/
                    /*Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          'Accedi',
                          style: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),*/
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: TextFormField(
                          obscureText: visibile,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: password,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'inserisci password';
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
                              hintText: 'password',
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
                            isLoading = true;
                          });
                          final resp = await loginHttp();
                          String a;
                          if (resp == 200) {
                            a = "Login effettuato con successo";
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                                'username', username.text.toLowerCase());
                            Navigator.pushAndRemoveUntil<void>(context,
                                MaterialPageRoute(builder: (context) {
                              //return Mainscreen(username.text);
                              return MyApp(user: username.text);
                            }), (Route<dynamic> route) => false);
                          } else if (resp != 0) {
                            a = "Login errato";
                          } else {
                            a = "Si è verificato un errore";
                          }
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(a)));
                          setState(() {
                            isLoading = false;
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
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    'Login',
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('non sei registrato?'),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Signup();
                            }));
                          },
                          child: Text(
                            'Registrati',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "ver. 1.0.0",
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
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

  Future<int> loginHttp() async {
    try {
      Proxy p = new Proxy();

      String url = "http://" + p.getProxy() + "/login";
      print("connessione a : $url");

      final response = await http
          .post(Uri.parse(url),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                "username": username.text,
                "password": password.text,
              }))
          .timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        print('Post created successfully!');
        if (response.body == "trovato") {
          return 200;
        } else {
          return 400;
        }
      } else {
        print('Failed to create post.' + response.statusCode.toString());
        return 400;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<String> loginHttp2() async {
    print("asf");
    try {
      final response = await http
          .post(Uri.parse('http:/192.168.1.183:8080/login'),
              // NB: you don't need to fill headers field
              headers: {
                'Content-Type':
                    'application/json' // 'application/x-www-form-urlencoded' or whatever you need
              },
              body: jsonEncode({
                'username': username.text,
                'password': password.text,
              }))
          .timeout(const Duration(seconds: 2));

      if (response.body != "non trovato") {
        return "trovato";
      } else {
        return "Error ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      print(e);
      return "sdf";
    }
  }
}
