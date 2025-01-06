import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sts/models/fattura.dart';
import 'package:sts/proprietario.dart';
import 'sts_db.dart';
import 'utente.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sts/controllers/proxy.dart';

TextEditingController risultato = TextEditingController();
TextEditingController nFat = TextEditingController();

TextEditingController importo2 = TextEditingController();
TextEditingController nDisp = TextEditingController();
String? cfUtente;
//String? nomeUtente;
//String? cognomeUtente;

final proxy = Proxy().getProxy();

bool anticip = false;
bool opposiz = false;
bool tracciato = false;
bool aggiungi = false;

String protocollo = "";

SQLite slq = SQLite();
//dati per invio
late Future? myFuture;

final cf = TextEditingController();
final nome = TextEditingController();
final cognome = TextEditingController();
final indirizzo = TextEditingController();
final importo1 = TextEditingController();
final dataPag = TextEditingController();
final dataFat = TextEditingController();

final sql = SQLite();
String? tipoSpesa;
String? natIva1;
String natIva2 = "N1";

class DettaglioFattura extends StatelessWidget {
  const DettaglioFattura({super.key, required this.nProtocollo});
  final String nProtocollo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio fattura'),
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.blueAccent.withOpacity(0.9),
      ),
      body: DettaglioFattura2(nProtocollo),
    );
  }
}

class DettaglioFattura2 extends StatefulWidget {
  const DettaglioFattura2(this.nProtocollo, {super.key});
  final String nProtocollo;

  @override
  State<DettaglioFattura2> createState() => _DettaglioFattura2();
}

class _DettaglioFattura2 extends State<DettaglioFattura2> {
  @override
  void initState() {
    super.initState();
    print("initState Called");
    risultato.clear();
    nFat.clear();
    dataFat.clear();
    dataPag.clear();
    importo1.clear();
    importo2.clear();
    nDisp.text = "1";
    //aggiungi = false;
    myFuture = carica();
    cfUtente = null;
    //carica();
  }

  Future<void> carica() async {
    //Utente? utente = await sql.getUtenteByCf(codfisc, user!);

    Fattura fat = await sql.getFatturaByProtocollo(widget.nProtocollo);
    //Utente? utente = await sql.getUtenteByCf(fat.cf);

    try {
      cf.text = fat.cf;
      nome.text = fat.nome;
      cognome.text = fat.cognome;

      importo1.text = fat.importo1.toStringAsFixed(2);

      nFat.text = fat.nFat;
      dataPag.text = fat.dataPag;
      dataFat.text = fat.dataFat;

      tipoSpesa = fat.tipoSpesa;

      tracciato = fat.tracciato == "SI" ? true : false;
      anticip = fat.anticipato == "SI" ? true : false;
      opposiz = fat.opposizione == "SI" ? true : false;

      natIva1 = fat.natIva1;

      cfUtente = fat.cf;

      risultato.text = fat.protocollo;

      aggiungi = fat.aggiungi == "SI" ? true : false;
      if (aggiungi) {
        importo2.text = fat.importo2.toStringAsFixed(2);
        natIva2 = fat.natIva2;
      }
    } on Exception {}
  }

  //TK	FC	FV	AD	AS	SR	CT	PI	IC	AA	SV	SP
  var itemsSpesa = [
    "SP",
    "TK",
    "FC",
    "FV",
    "AD",
    "AS",
    "SR",
    "CT",
    "PI",
    "IC",
    "AA",
    "SV",
  ];

  var itemsNatIva = [
    'N1',
    "N2.1",
    'N2.2',
    'N3.1',
    'N3.2',
    'N3.3',
    'N3.4',
    'N3.5',
    'N3.6',
    'N4',
    'N5',
    'N6',
    'N6.1',
    'N6.2',
    'N6.3',
    'N6.4',
    'N6.5',
    'N6.6',
    'N6.7',
    'N6.8',
    'N6.9',
    'N7',
  ];

  bool isLoading = false;
  //String dropdownValue = list.first;

  //Future<List<String>> lista = sql.utentiMenu();
  //Future<List<Utente>> lista2 = sql.utenti();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //ottieniLista();
    //print('lista: $_lista');
    return Form(
      key: _formKey,
      child: Container(
          child: FutureBuilder<void>(
              future: myFuture,
              builder: (context, data) {
                //mentre è in attesa
                if (data.connectionState == ConnectionState.waiting) {
                  // until data is fetched, show loader
                  return const CircularProgressIndicator();
                } else if (!data.hasData) {
                  //var menu = data.data![0].cf;
                  // cfUtente = menu;
                  return Scaffold(
                    body: SingleChildScrollView(
                      child: Form(
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.wrap_text),
                                      title: Text(
                                          'Modifica i dati di una fattura già inviata'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(children: [
                              Flexible(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 100,
                                  height: 50,
                                  child: TextField(
                                      readOnly: true,
                                      controller: nFat,
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
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
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                  controller: dataFat,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.lock),
                                      labelStyle: TextStyle(
                                        fontSize: 10,
                                      ),
                                      labelText: "Data Fattura",
                                      floatingLabelStyle: TextStyle(
                                        fontSize: 14,
                                      )),
                                  readOnly: true,
                                  /*onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
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
                                    }*/
                                ),
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
                                      DateTime? pickedDate =
                                          await showDatePicker(
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
                                          dataPag.text = formatDate;
                                        });
                                      }
                                    }),
                              )),
                            ]),
                            /* Padding(
                              padding: const EdgeInsets.all(9.0),
                              child: DropdownButton<String>(
                                //    hint: Text('seleziona un utente'),
                                isDense: true,
                                isExpanded:
                                    true, // Key property to handle text overflow
                                // Initial Value
                                value: cfUtente,
                                onChanged: (newValue) {
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
                            ),*/
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                initialValue: nome.text + " " + cognome.text,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.lock),
                                  labelText: 'Utente',
                                ),
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
                                        controller: importo1,
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
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: DropdownMenu<String>(
                                    initialSelection: tipoSpesa,
                                    label: const Text("Tipo spesa"),
                                    dropdownMenuEntries:
                                        itemsSpesa.map((String items) {
                                      return DropdownMenuEntry(
                                        value: items,
                                        label: items,
                                      );
                                    }).toList(),
                                    onSelected: (String? spesa) {
                                      setState(() {
                                        tipoSpesa = spesa!;
                                      });
                                    },
                                  ),
                                )

                                /*DropdownButton<String>(
                                  value: tipoSpesa,
                                  // Array list of items
                                  items: itemsSpesa.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(items),
                                    );
                                  }).toList(),
                                  // After selecting the desired option,it will
                                  // change button value to selected value
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      tipoSpesa = newValue!;
                                    });
                                  },
                                ),*/
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  child: Column(children: [
                                Row(children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(' Anticipato'),
                                  ),
                                  Switch(
                                      // This bool value toggles the switch.

                                      value: anticip,
                                      activeColor: Colors.blueAccent,
                                      onChanged: (bool value) {
                                        // This is called when the user toggles the switch.
                                        setState(() {
                                          anticip = value;
                                        });
                                      }),
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Opposizione'),
                                  ),
                                  Switch(
                                      // This bool value toggles the switch.

                                      value: opposiz,
                                      activeColor: Colors.blueAccent,
                                      onChanged: (bool value) {
                                        // This is called when the user toggles the switch.
                                        setState(() {
                                          opposiz = value;
                                        });
                                      }),
                                ]),
                                Row(children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(' Tracciato  '),
                                  ),
                                  Switch(
                                      // This bool value toggles the switch.

                                      value: tracciato,
                                      activeColor: Colors.blueAccent,
                                      onChanged: (bool value) {
                                        // This is called when the user toggles the switch.
                                        setState(() {
                                          tracciato = value;
                                        });
                                      }),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Natura Iva'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: DropdownButton<String>(
                                      value: natIva1,
                                      // Array list of items
                                      items: itemsNatIva.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          natIva1 = newValue!;
                                        });
                                      },
                                    ),
                                  )
                                ]),
                              ])),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Text("Bollo"),
                                    ),
                                    //  Flexible(child: Text("data")),
                                    Flexible(
                                      child: Checkbox(
                                        //  checkColor: Colors.blueAccent,
                                        activeColor: Colors.blueAccent,
                                        // title: Text("Bollo"),
                                        value: aggiungi,

                                        onChanged: (newValue) {
                                          setState(() {
                                            aggiungi = newValue!;
                                          });
                                        },
                                        //  controlAffinity: ListTileControlAffinity
                                        //    .leading, //  <-- leading Checkbox
                                      ),
                                    ),
                                    Flexible(
                                        child: SizedBox(
                                      width: 100,
                                      child: TextField(
                                          enabled: aggiungi,
                                          controller: importo2,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            labelStyle: TextStyle(fontSize: 10),
                                            prefixIcon: Icon(Icons.payment),
                                            labelText: 'importo',
                                          )),
                                    )),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Natura Iva'),
                                    ),
                                    DropdownButton<String>(
                                      value: natIva2,

                                      // Array list of items
                                      items: !aggiungi
                                          ? []
                                          : itemsNatIva.map((String items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          natIva2 = newValue!;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.black,
                                        elevation: 7,
                                      ),
                                      onPressed: () {
                                        (cfUtente != null) && (cfUtente != "")
                                            ? invia()
                                            : {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      {
                                                        return AlertDialog(
                                                          title: const Text(
                                                              'Attenzione'),
                                                          content: const Text(
                                                            'Seleziona un utente.',
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge,
                                                              ),
                                                              child: const Text(
                                                                  'Ok'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    })
                                              };
                                      },
                                      child: isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text('Invia'),
                                      /* isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text('Invia')*/
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.black,
                                        elevation: 7,
                                      ),
                                      onPressed: () {
                                        initState();
                                      },
                                      child: const Text('Nuovo'),
                                      /* isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text('Invia')*/
                                    ),
                                  ]),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Esito operazione',
                                    ),
                                    controller: risultato,
                                    enabled: false,
                                    style: const TextStyle(
                                      color: (Colors.black),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  print("vuoto");
                  return /* Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: (const Text("Nessun utente archiviato")),
                  );*/

                      AlertDialog(
                    backgroundColor: Colors.blueAccent.withOpacity(0.5),
                    title:
                        const Text('Attenzione:', textAlign: TextAlign.center),
                    content: const Text(
                        'Non puoi inviare fatture perchè\nnon hai registrato nessun utente.',
                        textAlign: TextAlign.center),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Ok'),
                        child: const Text('Ok'),
                      ),
                    ],
                  );
                }
              })),
    );
  }

  Future<void> salvaFattura() async {
    List<Proprietario> prop = await sql.getProprietario();
    Utente? user = await sql.getUtenteByCf(cfUtente!);
    print(user!.nome);

    String cfProp = prop[0].username;

    SharedPreferences shared = await SharedPreferences.getInstance();
    String? username = shared.getString('username');

    print("username $username");

    Fattura fat = Fattura(
        username: username!,
        aggiungi: aggiungi ? "SI" : "NO",
        proprietario: cfProp,
        nome: user.nome,
        cognome: user.cognome,
        cf: cfUtente!,
        natIva1: natIva1!,
        natIva2: natIva2,
        dataFat: dataFat.text,
        dataPag: dataPag.text,
        importo1: double.parse(importo1.text),
        importo2: aggiungi ? double.parse(importo2.text) : 0,
        protocollo: protocollo,
        opposizione: opposiz ? "SI" : "NO",
        anticipato: anticip ? "SI" : "NO",
        tracciato: tracciato ? "SI" : "NO",
        tipoSpesa: tipoSpesa!,
        nDisp: int.parse(nDisp.text),
        nFat: nFat.text);
    try {
      sql.insertFattura(fat);
    } catch (e) {
      print(e);
    }
    protocollo = "";
  }

  Future<void> invia() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Proprietario> prop = await sql.getProprietario();

      String cfProp = prop[0].username;
      String pw = prop[0].password;
      String pincode = prop[0].pincode;
      String piva = prop[0].piva;

      final url =
          //Uri.parse('http://10.0.2.2:8080/invio'); //Repclace Your Endpoint
          Uri.parse('http://$proxy/modifica'); //Repclace Your Endpoint
      final headers = {'Content-Type': 'application/json'};
      //final body = jsonEncode({'name': 'John Doe', 'email': 'john@example.com'});

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username') ?? 0;

      //late final aggiunta;
      late final imp2;
      late final naturaBollo;
      if (aggiungi) {
        //aggiunta = "SI";
        imp2 = importo2.text;
        naturaBollo = natIva2;
      } else {
        //aggiunta = "";
        imp2 = "";
        naturaBollo = "";
      }
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
          "impTot1": importo1.text,
          "natIva1": natIva1,
          "tipoSpesa": tipoSpesa,
          "aggiungi": aggiungi,
          "bollo": imp2,
          "natIva2": naturaBollo,
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

          List respChar = [];
          for (int b = 0; b < res.toString().length; b++) {
            respChar.add(res[b]);
          }

          //per controllare il corretto invio
          String a = "";
          for (int b = 0; b < 33; b++) {
            a = a + res[b];
          }
          print("-->$a");
          if (a == "Operazione eseguita correttamente") {
            print("-->OK"); //invio corretto
            for (int c = 34; c < 51; c++) {
              print(res[c]);
              protocollo = protocollo + res[c];
            }
            salvaFattura();
          }
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Esito invio'),
                  content: Text(res),
                  actions: [
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        } else {
          print('Data: ${response.statusCode}');
          risultato.text = "Si è verificato un errore";
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  // backgroundColor: Colors.grey.withOpacity(0.9),
                  title: const Text('Attenzione:', textAlign: TextAlign.center),
                  content: const Text(
                      'Si è verificato un errore.\n Controlla tutti i dati.',
                      textAlign: TextAlign.center),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Ok'),
                      child: const Text('Ok'),
                    ),
                  ],
                );
              });
          //print(response.body);
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Si è verificato un errore.'),
          ),
        );
      }
    } catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Attenzione'),
              content: Text(
                  "Inserisci i tuoi dati necessari per l'invio prima di procedere"),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
    ;

    setState(() {
      isLoading = false;
    });
  }

/*

void invia() {
  print('invia');
}
*/
  showError() async {
    await Future.delayed(Duration(microseconds: 1));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.blueAccent.withOpacity(0.5),
            title: const Text('Attenzione:', textAlign: TextAlign.center),
            content: const Text(
                'Non puoi inviare fatture perchè\nnon hai registrato nessun utente.',
                textAlign: TextAlign.center),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Ok'),
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }
}
