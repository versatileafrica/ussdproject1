import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:ussd/model/ussdModel.dart';
import 'package:ussd/view_model/UssdViewModel.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ussdViewModel = Get.put(UssdViewModel());
  TextEditingController numeroscontroller = TextEditingController();
  TextEditingController montantcontroller = TextEditingController();
  int? ussdId;
  @override
  Widget build(BuildContext context) {
    return
        // Obx(() => ussdViewModel.resultt.toString() == "4fec775aac6f7fc9" ?
        Scaffold(
            appBar: AppBar(
                title: Text("Ussd App"),
                backgroundColor: Color.fromARGB(255, 84, 194, 221)),
            body: Obx(
              () => Container(
                margin: EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Text(
                      // "Liste des payements en attente",
                      ussdViewModel.resultt.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: ussdViewModel.allussdlist.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                ussdId = ussdViewModel.allussdlist[index].id;
                                print(ussdViewModel.allussdlist[index].id);
                                numeroscontroller.text = ussdViewModel
                                    .allussdlist[index].numeros
                                    .toString();
                                montantcontroller.text = ussdViewModel
                                    .allussdlist[index].montant
                                    .toString();
                                opendialogUpdate(numeroscontroller,
                                    montantcontroller, ussdId);
                              },
                              child: Card(
                                  child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Contact:   " +
                                              ussdViewModel
                                                  .allussdlist[index].numeros
                                                  .toString()),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Montant:   " +
                                              ussdViewModel
                                                  .allussdlist[index].montant
                                                  .toString()),
                                          // SizedBox(
                                          //   width: 20,
                                          // ),
                                          // Text(ussdViewModel
                                          //     .allussdlist[index].status
                                          //     .toString()),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // InkWell(
                                  //   onTap: () => {print('appuyer1')},
                                  //   child: Icon(
                                  //     Icons.edit,
                                  //     color: Colors.greenAccent,
                                  //     size: 32,
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   width: 30,
                                  // ),
                                  InkWell(
                                    onTap: () => {
                                      ussdViewModel.deleteussd(
                                          ussdViewModel.allussdlist[index].id!)
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              )),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: SpeedDial(
              backgroundColor: Color.fromARGB(255, 84, 194, 221),
              overlayOpacity: 0,
              // spacing: 12,
              // spaceBetweenChildren: 12,
              // closeManually: true,
              animatedIcon: AnimatedIcons.menu_home,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.add),
                    label: "ajout une transaction",
                    onTap: () {
                      opendialog(montantcontroller, numeroscontroller);
                    }
                    // backgroundColor: Color.fromARGB(255, 51, 189, 162),
                    ),
                SpeedDialChild(
                    child: Icon(Icons.play_arrow_outlined),
                    label: "lacer la liste",
                    onTap: () {
                      ussdViewModel.sendUssdRequestgroup();
                    }
                    // backgroundColor: Color.fromARGB(255, 197, 215, 91),
                    ),
                SpeedDialChild(
                    child: Icon(Icons.play_arrow_outlined),
                    label: "TEST",
                    onTap: () {
                      ussdViewModel.getInfo();
                    }
                    // backgroundColor: Color.fromARGB(255, 197, 215, 91),
                    ),
              ],
            )

            // FloatingActionButton(
            //   backgroundColor: Color.fromARGB(255, 84, 194, 221),
            //   onPressed: () => {opendialog(montantcontroller, numeroscontroller)},
            //   tooltip: 'Increment',
            //   child: const Icon(Icons.add),
            // ), // This trailing comma makes auto-formatting nicer for build methods.
            );
    // : Scaffold(
    //     appBar: AppBar(
    //         title: Text("Ussd App"),
    //         backgroundColor: Color.fromARGB(255, 84, 194, 221)),
    //     body: Obx(() => Container(
    //         margin: EdgeInsets.all(10),
    //         child: Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: <Widget>[
    //               // Text(ussdViewModel.resultt.toString()),
    //               // SizedBox(
    //               //   height: 30,
    //               // ),
    //               Text(
    //                 "Vous n'avez pas le droit d'utiliser l'appli.  `\n Veuillez contactez les développeurs",
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.bold,
    //                     fontSize: 16,
    //                     fontStyle: FontStyle.italic),
    //               ),
    //             ],
    //           ),
    //         )))));
  }

  Future opendialog(TextEditingController montantcontroller,
          TextEditingController numeroscontroller) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Ajouter a la liste"),
                content: Container(
                  height: MediaQuery.of(context).size.height / 5.8,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: numeroscontroller,
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(hintText: "Entrer le numeros"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: montantcontroller,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(hintText: "Entrer le montant"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text('AJOUTER'),
                    onPressed: () {
                      if (numeroscontroller.text != "" &&
                          montantcontroller.text != "") {
                        ussdViewModel.addussd(ussdModel(
                            id: null,
                            numeros: int.parse(numeroscontroller.text),
                            montant: int.parse(montantcontroller.text),
                            status: 0));
                        numeroscontroller.text = "";
                        montantcontroller.text = "";
                        submit();
                      } else {
                        submit();
                        // libelercontroller.clear();
                        // usssdcontroller.clear();
                        show_FlushbarHelper(
                            context, "Veillez saisir les different champs");
                      }
                    },
                  )
                ],
              ));

  Future opendialogUpdate(TextEditingController numerocontroller,
          TextEditingController montantcontroller, int? ussdId) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Modifier l'élément"),
                content: Container(
                  height: MediaQuery.of(context).size.height / 5.8,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: numerocontroller,
                        maxLength: 8,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(hintText: "Entrer le numeros"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: montantcontroller,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(hintText: "Entrer le montant"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text('MODIFIER'),
                    onPressed: () {
                      if (numerocontroller.text != "" &&
                          montantcontroller.text != "") {
                        ussdViewModel.updateussd(ussdModel(
                            id: ussdId,
                            numeros: int.parse(numerocontroller.text),
                            montant: int.parse(montantcontroller.text),
                            status: 0));
                        numerocontroller.text = "";
                        montantcontroller.text = "";
                        submit();
                      } else {
                        submit();
                        // libelercontroller.clear();
                        // usssdcontroller.clear();
                        show_FlushbarHelper(
                            context, "Veillez saisir les different champs");
                      }
                    },
                  )
                ],
              ));

  void submit() {
    Navigator.of(context).pop();
  }

  void show_FlushbarHelper(BuildContext context, dynamic repe) {
    FlushbarHelper.createInformation(
        title: "Informations",
        message: repe.toString(),
        duration: Duration(seconds: 2))
      ..show(context);
  }
}
