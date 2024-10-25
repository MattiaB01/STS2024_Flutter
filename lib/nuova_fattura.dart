import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sts/proprietario.dart';
import 'package:sts/proprietario_routes.dart';
import 'sts_db.dart';
import 'utente.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sts/controllers/proxy.dart';

TextEditingController risultato = TextEditingController();
TextEditingController dataFat = TextEditingController();
TextEditingController dataPag = TextEditingController();
TextEditingController nFat = TextEditingController();
TextEditingController importo = TextEditingController();
TextEditingController nDisp = TextEditingController();
String? cfUtente;
final proxy = Proxy().getProxy();

bool anticip = false;
bool opposiz = false;
bool tracciato = true;

SQLite slq = SQLite();
//dati per invio

class NuovaFattura extends StatelessWidget {
  const NuovaFattura({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova fattura'),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
      ),
      body: const nuovaFattura(),
    );
  }
}

class nuovaFattura extends StatefulWidget {
  const nuovaFattura({super.key});

  @override
  State<nuovaFattura> createState() => _nuovaFattura();
}

class _nuovaFattura extends State<nuovaFattura> {
  @override
  void initState() {
    print("initState Called");
    risultato.clear();
    nFat.clear();
    dataFat.clear();
    dataPag.clear();
    importo.clear();
    nDisp.text = "1";
  }

  bool isLoading = false;
  //String dropdownValue = list.first;

  Future<List<String>> lista = sql.utentiMenu();
  Future<List<Utente>> lista2 = sql.utenti();

  @override
  Widget build(BuildContext context) {
    //ottieniLista();
    //print('lista: $_lista');
    return Container(
        child: FutureBuilder<List<Utente>>(
            future: lista2,
            builder: (context, data) {
              //mentre è in attesa
              if (data.connectionState == ConnectionState.waiting) {
                // until data is fetched, show loader
                return const CircularProgressIndicator();
              } else if (data.data!.isNotEmpty) {
                //var menu = data.data![0].cf;
                // cfUtente = menu;
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        children: [
                          Row(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  invia();
                                },
                                child: isLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.blue,
                                      )
                                    : Text('Invia'),
                                /* isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text('Invia')*/
                              ),
                            ),
                            Expanded(
                                child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Esito operazione',
                              ),
                              controller: risultato,
                              enabled: false,
                              style: TextStyle(
                                color: (Colors.black),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ))
                          ]),
                          Row(children: [
                            Flexible(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100,
                                height: 50,
                                child: TextField(
                                    controller: nFat,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.inventory),
                                        labelText: 'N.Fat.',
                                        floatingLabelStyle: TextStyle(
                                          fontSize: 14,
                                        ),
                                        labelStyle: TextStyle(
                                          fontSize: 10,
                                        ))),
                              ),
                            )),
                            Flexible(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextField(
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  controller: dataFat,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      labelStyle: TextStyle(
                                        fontSize: 10,
                                      ),
                                      labelText: "Data Fattura",
                                      floatingLabelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2040),
                                    );

                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      String formatDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickedDate);
                                      print(formatDate);

                                      setState(() {
                                        dataFat.text = formatDate;
                                      });
                                    }
                                  }),
                            )),
                            Flexible(
                                child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TextField(
                                  style: TextStyle(fontSize: 14),
                                  controller: dataPag,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      labelText: "Data Pagamento",
                                      labelStyle: TextStyle(
                                        fontSize: 10,
                                      ),
                                      floatingLabelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2040),
                                    );

                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      String formatDate =
                                          DateFormat('dd/MM/yyyy')
                                              .format(pickedDate);
                                      print(formatDate);

                                      setState(() {
                                        dataPag.text = formatDate;
                                      });
                                    }
                                  }),
                            )),
                          ]),
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: DropdownButton<String>(
                              isDense: true,
                              isExpanded:
                                  true, // Key property to handle text overflow
                              // Initial Value
                              value: cfUtente,
                              onChanged: (String? newValue) {
                                setState(() {
                                  //newValue = menu;
                                  cfUtente = newValue;
                                });
                              },

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Array list of items
                              items: data.data?.map((Utente items) {
                                String utente = items.cognome +
                                    " " +
                                    items.nome +
                                    " " +
                                    items.cf;

                                return DropdownMenuItem(
                                  value: items.cf,
                                  child: Text(
                                    utente,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 120,
                                  height: 50,
                                  child: TextField(
                                      controller: importo,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelStyle: TextStyle(fontSize: 10),
                                        prefixIcon: Icon(Icons.payment),
                                        labelText: 'importo',
                                      )),
                                ),
                              )),
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 120,
                                  height: 50,
                                  child: TextField(
                                      controller: nDisp,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelStyle: TextStyle(fontSize: 10),
                                        prefixIcon: Icon(Icons.devices),
                                        labelText: 'n.Dispositivo',
                                      )),
                                ),
                              )),
                            ],
                          ),
                          Card(
                              child: Column(children: [
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: const Text(' Anticipato'),
                              ),
                              Switch(
                                  // This bool value toggles the switch.

                                  value: anticip,
                                  activeColor: Colors.green,
                                  onChanged: (bool value) {
                                    // This is called when the user toggles the switch.
                                    setState(() {
                                      anticip = value;
                                    });
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: const Text('Opposizione'),
                              ),
                              Switch(
                                  // This bool value toggles the switch.

                                  value: opposiz,
                                  activeColor: Colors.green,
                                  onChanged: (bool value) {
                                    // This is called when the user toggles the switch.
                                    setState(() {
                                      opposiz = value;
                                    });
                                  }),
                            ]),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: const Text(' Tracciato  '),
                                ),
                                Switch(
                                    // This bool value toggles the switch.

                                    value: tracciato,
                                    activeColor: Colors.green,
                                    onChanged: (bool value) {
                                      // This is called when the user toggles the switch.
                                      setState(() {
                                        tracciato = value;
                                      });
                                    }),
                              ],
                            )
                          ])),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                print("vuoto");
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: (const Text("Nessun utente archiviato")),
                );
              }
            }));
  }

  Future<void> invia() async {
    setState(() {
      isLoading = true;
    });

    List<Proprietario> prop = await sql.getProprietario();

    String cfProp = prop[0].username;
    String pw = prop[0].password;
    String pincode = prop[0].pincode;
    String piva = prop[0].piva;

    final url =
        //Uri.parse('http://10.0.2.2:8080/invio'); //Repclace Your Endpoint
        Uri.parse('http://$proxy/invio'); //Repclace Your Endpoint
    final headers = {'Content-Type': 'application/json'};
    //final body = jsonEncode({'name': 'John Doe', 'email': 'john@example.com'});

    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? 0;

    final body = jsonEncode({
      "proprietario": {
        /*
      "username": ",
      "password": "Salve123",
      "pincode": "3167676525",
      "piva": "65432109876",*/

        "username": cfProp,
        "password": pw,
        "pincode": pincode,
        "piva": piva,
      },
      "fattura": {
        "username": username,
        "proprietario": cfProp,
        "utente": cfUtente,
        "dataFat": dataFat.text,
        "dataPag": dataPag.text,
        "numFat": nFat.text,
        "impTot1": importo.text,
        "natIva1": "N2.2",
        "aggiungi": "",
        "bollo": "",
        "natIva2": "",
        "numDisp": nDisp.text,
        "tracciato": tracciato ? "SI" : "NO",
        "opposizione": opposiz ? "SI" : "NO",
        "anticipato": anticip ? "SI" : "NO",
      }
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      // .timeout(Duration(seconds: 2));
      //final url2 = Uri.parse('http://google.com');
      //final response = await http.post(url);

      if (response.statusCode == 200) {
        print('Data Sending Success.');
        print(response.body.toString());
        final res = response.body;
        risultato.text = res.toString();
      } else {
        print('Data: ${response.statusCode}');
        risultato.text = "Si è verificato un errore";
        //print(response.body);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Problema di connessione. Riprova più tardi.'),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

/*

void invia() {
  print('invia');
}
*/
}
