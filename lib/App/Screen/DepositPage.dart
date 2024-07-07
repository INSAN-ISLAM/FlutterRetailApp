

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ratailapp/Widget/AppEevatedButton.dart';
import 'package:ratailapp/Widget/AppTextField.dart';


import 'DepositHisPage.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  // XFile? pickedImage;
  // String? base64Image;

// uncomplete action

  String? imgUrl;
  String? file;
  final TextEditingController AmountETController = TextEditingController();

  // }

  // MySnackBar(message, context) {
  //   return ScaffoldMessenger.of(context)
  //       .showSnackBar(SnackBar(content: Text(message)));
  // }
  //
  // MyAlertDialog(context) {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Expanded(
  //             child: AlertDialog(
  //               title:Text("Diposit "),
  //               // ListTile(
  //               //   leading:Text("Diposit "),
  //               // trailing: IconButton(onPressed: () {  Navigator.of(context).pop(); },icon: Icon( Icons.clear_rounded,)),
  //               // ),
  //               content: Text("Alart!"),
  //               actions: [
  //                 Center(
  //                   child: Column(
  //                     children: [
  //                       SizedBox(height: 3,),
  //
  //                       SizedBox(height: 3,),
  //                       AppElevatedButton(
  //                         Color: Colors.deepOrange,
  //
  //                         onTap: () {
  //                           Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                   builder: (context) =>
  //                                       PayMentPage()));
  //                         },
  //                         child: Center(
  //                           child: Text(
  //                             "Deposit Now",
  //                             style: GoogleFonts.poppins(
  //                               textStyle: const TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: 14,
  //                                 //fontWeight: FontWeight.w700,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //
  //                       SizedBox(height: 5),
  //                       AppElevatedButton(
  //                         Color: Colors.blueGrey,
  //                         onTap: () {
  //                           Navigator.of(context).pop();
  //                           // Navigator.push(context, MaterialPageRoute(builder: (context) => const MainBottomNavBar()));
  //                         },
  //                         child: Center(
  //                           child: Text(
  //                             "Close",
  //                             style: GoogleFonts.poppins(
  //                               textStyle: const TextStyle(
  //                                 color: Colors.black,
  //                                 fontSize: 14,
  //                                 //fontWeight: FontWeight.w700,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ));
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'PayMent',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,

                  fontSize: 30,

                  //fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 50),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PayMentPage()));

                },
                child: SvgPicture.asset(
                  'assets/images/BKashLogo.svg',
                  height: 100,
                  width: 108,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PayMentPage()));


                },
                child: SvgPicture.asset(
                  'assets/images/NagadLogo.svg',
                  height: 120,
                  width: 200,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayMentPage extends StatefulWidget {
  //final String image;

  const PayMentPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PayMentPage> createState() => _PayMentPageState();
}

class _PayMentPageState extends State<PayMentPage> {
  final TextEditingController _nameETController = TextEditingController();
  final TextEditingController _AmountETController = TextEditingController();
  final TextEditingController _TrxIDETController = TextEditingController();
  final TextEditingController _RateRETController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool m = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedGateway;
  final List<String> _gateways = ['Bkash', 'Nagad'];
  final user = FirebaseAuth.instance.currentUser;
  int? userRate;
  int? userNumber;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchUserRate();
  }

  void _fetchData() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('DepositDetails').get();
    setState(() {
      m = false;
    });
  }

  void _fetchUserRate() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('Check').doc(user!.uid).get();

    if (documentSnapshot.exists) {
      setState(() {
        userRate = documentSnapshot.get('rate');
        userNumber = documentSnapshot.get('rate');
      });
    }
  }

  Future<void> updateProfile() async {
    try {
      await FirebaseFirestore.instance.collection('DepositDetails').add({
        'Amount': int.tryParse(_AmountETController.text) ?? 0,
        'TrxID': _TrxIDETController.text,
        'User Diamond': _RateRETController.text,
        'Payment Gateway': _selectedGateway,
        'Status': 'unpaid',
        'created_at': FieldValue.serverTimestamp(),
        'user': user!.uid,
        'mobile': userNumber,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Deposit Request Send To Admin successfully, Please Wait For Accept ')));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderScreen()),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update data')));
      });
    } catch (e) {
      print('Error signing up: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Failed! Try again')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text('Payment Information',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Color(0xFF6A7189),
                        fontSize: 16,
                      ),
                    )),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedGateway,
                  hint: Text('Select Payment Gateway'),
                  items: _gateways.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGateway = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a payment gateway';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppTextFieldWidget(
                  controller: _TrxIDETController,
                  hintText: 'TrxID',
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Wrong Number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppTextFieldWidget(
                  controller: _AmountETController,
                  hintText: 'Amount',
                  suffixIcon: Text('Taka'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Wrong Number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (userRate != null && userRate != 0) {
                      setState(() {
                        print('value: $value, userRate: $userRate');
                        if (value != null) {
                          final amount = int.tryParse(value) ?? 0;
                          final rateInt =
                              userRate!.toInt(); // Convert userRate to integer
                          _RateRETController.text = ((amount ~/ 100) * rateInt )
                              .toString(); // Use integer division
                        } else {
                          // Handle the case where value is null
                          _RateRETController.text = '0';
                        }
                      });
                    } else {
                      setState(() {
                        _RateRETController.text = '0';
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),
                AppTextFieldWidget(
                  controller: _RateRETController,
                  hintText: 'Diamond',
                  readOnly:
                      true, // Set the text field to read-only instead of using enabled
                ),
                const SizedBox(height: 12),
                Container(
                  height: 48,
                  width: 358,
                  child: AppElevatedButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        updateProfile();
                      }
                    },
                    child: Center(
                      child: Text(
                        "Deposit Now",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
