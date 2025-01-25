import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sts/nuova_fattura.dart';
import 'package:sts/views/screens/auth/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

final username = TextEditingController();
final passwordKey = TextEditingController();
final passwordKeyCont = TextEditingController();

bool password = false;
bool password2 = false;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SigninState();
}

class _SigninState extends State<Signup> {
  // const Signin({super.key});
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordKey.clear();
    passwordKeyCont.clear();
    username.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.withOpacity(0.9),
      body: Container(
        /*decoration: BoxDecoration(
            image: DecorationImage(
          image: const AssetImage("assets/images/sfondo.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.5),
            BlendMode.dstATop,
          ),
        )),*/
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            //per centrare orrizontalmente
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  //allinamento centrale verticale
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*  Text('per continuare',
                        style: GoogleFonts.getFont(
                          'Lato',
                          fontSize: 14,
                          letterSpacing: 0.2,
                        )),*/
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 20,
                            offset: const Offset(
                                0, 3), // changes position of shadow
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
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Text(
                        'Effettua la registrazione',
                        style: GoogleFonts.getFont(
                          'Lato',
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                          fontSize: 23,
                        ),
                      ),
                    ),
                    /* Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Registrazione',
                          style: GoogleFonts.getFont(
                            'Nunito Sans',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),*/
                    TextFormField(
                        controller: username,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'inserisci username';
                          } else
                            return null;
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
                            hintText: 'inserisci il tuo username',
                            hintStyle: const TextStyle(color: Colors.grey),
                            labelStyle: GoogleFonts.getFont(
                              'Nunito Sans',
                              fontSize: 14,
                              letterSpacing: 0.1,
                            ),
                            prefixIcon: const Icon(Icons.people))),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        obscureText: !password,
                        controller: passwordKey,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'inserire una password';
                          } else
                            return null;
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
                                    password = !(password);
                                  });
                                },
                                icon: Icon(Icons.visibility)))),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        obscureText: !password2,
                        // controller: passwordKeyCont,
                        validator: (value) {
                          if (value != passwordKey.text) {
                            return 'le password devono essere uguali';
                          } else
                            return null;
                        },
                        decoration: InputDecoration(
                            errorStyle: const TextStyle(color: Colors.white),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            //focusedBorder: InputBorder.none,
                            //enabledBorder: InputBorder.none,
                            //labelText: 'conferma password',
                            hintText: 'conferma password',
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
                                    password2 = !(password2);
                                  });
                                },
                                icon: Icon(Icons.visibility)))),
                    const SizedBox(
                      height: 40,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          print("-----------");
                          int a = await signupHttp();
                          print("-->" + a.toString());
                          if (a == 200) {
                            print("utente ok");
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Registrazione effettuata correttamente")));
                            Navigator.pop(context);
                            /*  Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Login();
                            }));*/
                          } else if (a != 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Utente già registrato")));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Si è verificato un errore.")));
                          }
                        } else
                          print("non valido");
                        setState(() {
                          isLoading = false;
                        });
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
                          gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.lightBlue]),
                        ),
                        child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Registrati',
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
                          child: Text('torna alla pagina di'),
                        ),
                        InkWell(
                          onTap: () async {
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
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<int> signupHttp() async {
  try {
    final response = await http
        .post(Uri.parse('http://$proxy/signup'),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "username": username.text,
              "password": passwordKey.text,
            }))
        .timeout(const Duration(seconds: 5));

    String res = response.body;

    if (response.statusCode == 200) {
      print('Richiesta andata a buon fine');
      print("---" + res);
      if (res != "errore") {
        print("ritorno 200");
        return 200;
      } else
        return 201;
    } else {
      print('Richiesta fallita' + response.statusCode.toString());
      return 400;
    }
  } catch (e) {}
  //print(res);
  return 0;
  //return response.statusCode;
}
