import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ratailapp/App/Screen/DepositHisPage.dart';

import 'package:ratailapp/App/Screen/RechargeHisPage.dart';

import 'package:ratailapp/App/Screen/TransferHisPage.dart';
import 'package:ratailapp/App/Screen/LogInPage.dart';
import 'package:ratailapp/Widget/AppEevatedButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'SettingPage.dart';

class MyhomePage extends StatefulWidget {
  MyhomePage({super.key});

  @override
  State<MyhomePage> createState() => _MyhomePageState();
}

class _MyhomePageState extends State<MyhomePage> {
  MySnackBar(message, context) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  MyAlertDialog(context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Expanded(
              child: AlertDialog(
            title: Text("Log Out"),
            content: Text("Are You sure you want to log out?"),
            actions: [
              Center(
                child: Column(
                  children: [
                    AppElevatedButton(
                      Color: Colors.yellow,
                      onTap: () {
                        // Navigator.of(context).pop();
                        _signOut();
                        //Navigator.push(context, MaterialPageRoute(builder: (context) =>  LogInScreen()));
                      },
                      child: Center(
                        child: Text(
                          "Confirm",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              //fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 5),
                    AppElevatedButton(
                      onTap: () {
                        Navigator.of(context).pop();
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const MainBottomNavBar()));
                      },
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              //fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
        });
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  late Future<QuerySnapshot> _depositFuture;
  late Future<QuerySnapshot> _receiptFuture;
  late Future<QuerySnapshot> _transferPlusFuture;
  late Future<QuerySnapshot> _transferMinusFuture;

  @override
  void initState() {
    super.initState();
    _depositFuture = _getDepositDetails();
    _receiptFuture = _getReceiptDetails();
    _transferPlusFuture = _getTransferPlusDetails();
    _transferMinusFuture = _getTransferMinusDetails();
  }

  Future<QuerySnapshot> _getDepositDetails() async {
    try {
      return await _firestore
          .collection('DepositDetails')
          .where('Status', isEqualTo: 'paid')
          .where('user', isEqualTo: user?.uid)
          .get();
    } catch (e) {
      throw Exception('Error fetching deposit details: $e');
    }
  }

  Future<QuerySnapshot> _getReceiptDetails() async {
    try {
      return await _firestore
          .collection('ReceiptDetails')
          .where('Status', isEqualTo: 'Approve')
          .where('user', isEqualTo: user?.uid)
          .get();
    } catch (e) {
      throw Exception('Error fetching receipt details: $e');
    }
  }

  Future<QuerySnapshot> _getTransferPlusDetails() async {
    try {
      return await _firestore
          .collection('TransferDetails')
          .where('user', isEqualTo: user?.uid)
          .get();
    } catch (e) {
      throw Exception('Error fetching receipt details: $e');
    }
  }

  Future<QuerySnapshot> _getTransferMinusDetails() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Check') // Replace 'users' with your collection name
        .doc(user?.uid)
        .get();
    try {
      return await _firestore
          .collection('TransferDetails')
          .where('TransferNumber', isEqualTo: userDoc['mobile'])
          .get();
    } catch (e) {
      throw Exception('Error fetching receipt details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FutureBuilder(
              future: Future.wait([
                _depositFuture,
                _receiptFuture,
                _transferPlusFuture,
                _transferMinusFuture
              ]),
              builder: (BuildContext context,
                  AsyncSnapshot<List<QuerySnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                double totalUserDiamond = 0;
                double todayUserDiamond = 0;

                snapshot.data![0].docs.forEach((doc) {
                  double userDiamond =
                      double.tryParse(doc['User Diamond'] ?? '0') ?? 0;
                  totalUserDiamond += userDiamond;

                  DateTime now = DateTime.now();
                  DateTime startOfDay = DateTime(now.year, now.month, now.day);
                  DateTime endOfDay =
                      DateTime(now.year, now.month, now.day, 23, 59, 59);

                  Timestamp createdAt = doc['created_at'];
                  if (createdAt.toDate().isAfter(startOfDay) &&
                      createdAt.toDate().isBefore(endOfDay)) {
                    todayUserDiamond += userDiamond;
                  }
                });

                double totalTransferDiamond = 0;
                double todayTransferDiamond = 0;
                snapshot.data![1].docs.forEach((doc) {
                  double transferDiamond =
                      double.tryParse(doc['TransferDiamond'] ?? '0') ?? 0;
                  totalTransferDiamond += transferDiamond;

                  DateTime now = DateTime.now();
                  DateTime startOfDay = DateTime(now.year, now.month, now.day);
                  DateTime endOfDay =
                      DateTime(now.year, now.month, now.day, 23, 59, 59);

                  Timestamp createdAt = doc['created_at'];
                  if (createdAt.toDate().isAfter(startOfDay) &&
                      createdAt.toDate().isBefore(endOfDay)) {
                    todayTransferDiamond += transferDiamond;
                  }
                });

                double totalTransferPlusDiamond = 0;
                double todayTransferPlusDiamond = 0;
                snapshot.data![2].docs.forEach((doc) {
                  double transferPlusDiamond =
                      double.tryParse(doc['TransferDiamond'] ?? '0') ?? 0;
                  totalTransferPlusDiamond += transferPlusDiamond;

                  DateTime now = DateTime.now();
                  DateTime startOfDay = DateTime(now.year, now.month, now.day);
                  DateTime endOfDay =
                      DateTime(now.year, now.month, now.day, 23, 59, 59);

                  Timestamp createdAt = doc['created_at'];
                  if (createdAt.toDate().isAfter(startOfDay) &&
                      createdAt.toDate().isBefore(endOfDay)) {
                    todayTransferPlusDiamond += transferPlusDiamond;
                  }
                });

                double totalTransferMinusDiamond = 0;
                double todayTransferMinusDiamond = 0;
                snapshot.data![3].docs.forEach((doc) {
                  double transferMinusDiamond =
                      double.tryParse(doc['TransferDiamond'] ?? '0') ?? 0;
                  totalTransferMinusDiamond += transferMinusDiamond;

                  DateTime now = DateTime.now();
                  DateTime startOfDay = DateTime(now.year, now.month, now.day);
                  DateTime endOfDay =
                      DateTime(now.year, now.month, now.day, 23, 59, 59);

                  Timestamp createdAt = doc['created_at'];
                  if (createdAt.toDate().isAfter(startOfDay) &&
                      createdAt.toDate().isBefore(endOfDay)) {
                    todayTransferMinusDiamond += transferMinusDiamond;
                  }
                });

                int totalResult =
                    ((totalUserDiamond + totalTransferPlusDiamond) -
                            (totalTransferDiamond + totalTransferMinusDiamond))
                        .toInt();

                int todayResult =
                    ((todayUserDiamond + todayTransferPlusDiamond) -
                            (todayTransferMinusDiamond + todayTransferDiamond))
                        .toInt();

                return Column(
                  children: [
                    Card(
                      elevation: 10,
                      child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                CircleAvatar(
                                  radius: 10,
                                  //   backgroundImage:AssetImage('assets/images/profile.png'),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Account balance"),

                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                   Icon(FontAwesomeIcons.sketch,)
                                  ],
                                ),

                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 40,
                          child: Card(
                            elevation: 10,
                            child: Container(
                                height: 80,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.teal[900],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {

                                  },
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          " Sales Today daimond", //Diamond
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: Text(
                                              "Taka",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: Icon(FontAwesomeIcons.sketch, color: Colors.black,)
                                          )




                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 40,
                          child: Card(
                            elevation: 10,
                            child: Container(
                                height: 80,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.teal[900],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {

                                  },
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Text(
                                          " Sales Today Taka", //Total Diamond
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: Text(
                                              "Taka",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),


                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 50,
                          child: Card(
                            elevation: 10,
                            child: Container(
                                height: 80,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.teal[900],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {

                                  },
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Text(
                                          "Today Deposit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: Text(
                                              "$todayResult",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child:Icon(FontAwesomeIcons.sketch, color: Colors.black,)
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 50,
                          child: Card(
                            elevation: 10,
                            child: Container(
                                height: 80,
                                width: 150,
                                decoration: BoxDecoration(
                                  color: Colors.teal[900],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () {

                                  },
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 16.0,
                                        ),
                                        child: Text(
                                          "Today Diposit ",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: Text(
                                              "Taka",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: Text(
                                              "",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(10),
              child: Center(
                  child: Text("Main Dashbord",
                      style: TextStyle(color: Colors.black))),


            ),
            ListTile(
              title: Text("Navigation"),
            ),
            ListTile(
                leading: Icon(Icons.add_box_outlined),
                title: Text("Deposit History"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrderScreen()));
                }),
            ListTile(
                leading: Icon(Icons.add_box_outlined),
                title: Text("Recharge History"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReceiptAcceptScreen()));
                }),
            ListTile(
                leading: Icon(Icons.work_history_rounded),
                title: Text("Transfer History"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransferScreen()));
                }),

            ListTile(
                leading: Icon(Icons.settings),
                title: Text("Setting"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingScreen()));//SettingScreen
                }),

          ],
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signOut() async {
    await _auth.signOut();
    // Optionally, you can navigate to the login screen or show a message
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LogInSreen()));
  }
}
