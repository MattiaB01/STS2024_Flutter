import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sts/elenco_fatture.dart';
import 'package:sts/elenco_utenti.dart';
import 'package:sts/nuova_fattura.dart';
import 'package:sts/proprietario_routes.dart';
import 'package:sts/sts_db.dart';
import 'package:sts/utente_routes.dart';
import 'package:sts/views/screens/auth/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.user});
  final String user;

  @override
  Widget build(BuildContext context) {
    SQLite sql = SQLite();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema tessera sanitaria',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Sistema tessera sanitaria', userText: user),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.userText});
  final String title;
  final String userText;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  Card creaCard(String title, String img, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(3.0, -1.0),
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 3,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProprietarioRoute()),
              );

              //1.item
            }
            if (index == 1) {
              //2.item
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UtentiRoute()),
              );
              //3.item
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ElencoUtenti2()),
              );
              //4.item
            }
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NuovaFattura()),
              );
              //5.item
            }
            if (index == 5) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ElencoFatture()),
              );
              //6.item
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  img,
                  height: 70,
                  width: 70,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String user = widget.userText.toUpperCase();
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 170, 193, 232),
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.account_box),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
        title: Text(widget.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
        actions: [
          /*    IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),*/
          IconButton(
            onPressed: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: Text("Logout"),
                        content: Text("Confermi l'uscita?"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text("Annulla")),
                          TextButton(
                            onPressed: () => {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                return Login();
                              }), (Route<dynamic> route) => false),
                              /*
                              Navigator.pushAndRemoveUntil<void>(context,
                                  MaterialPageRoute(builder: (context) {
                                //return Mainscreen(username.text);
                                return Login();
                              }), (Route<dynamic> route) => false),
                              Navigator.pop(context, 'Ok'),*/
                            },
                            child: Text("Conferma"),
                          )
                        ],
                      ));

              /*  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );*/
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.sizeOf(context).width - 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.blueAccent.withOpacity(0.3),
                            Colors.blueAccent.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(Icons.person),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Benvenuto $user",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //                  SizedBox(height: 0),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(2),
              children: [
                creaCard("I tuoi dati", "assets/images/id.png", 0),
                creaCard("Impostazioni", "assets/images/settings.png", 1),
                creaCard("Nuovo utente", "assets/images/user.png", 2),
                creaCard("Elenco utenti", "assets/images/users.png", 3),
                creaCard("Nuova fattura", "assets/images/nuova_fattura.png", 4),
                creaCard(
                    "Elenco fatture", "assets/images/elenco_fatture.png", 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
