import 'package:flutter/material.dart';
import 'package:ratailapp/App/AdminPanel/AdminDashboardPage.dart';
import 'package:ratailapp/App/Screen/DepositPage.dart';
import 'package:ratailapp/App/Screen/ProfilePage.dart';
import 'package:ratailapp/App/Screen/TransferNum.dart';
import 'package:ratailapp/App/Screen/TransferHisPage.dart';
import 'package:ratailapp/App/Screen/TransferPage.dart';




class AdminMainBottomNavBar extends StatefulWidget {
  AdminMainBottomNavBar({Key? key}) : super(key: key);

  @override
  State<AdminMainBottomNavBar> createState() => _AdminMainBottomNavBarState();
}

class _AdminMainBottomNavBarState extends State<AdminMainBottomNavBar> {
  int _selectedScreen = 0;
  final List<Widget> _screens =  [
    AdminDashBoardScreen(),
    AdminDepositScreen(),
    AdminReachargeScreen(),
    AdminTransferScreen(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            Expanded(child: _screens[_selectedScreen]),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.grey,
        showUnselectedLabels: true,
        unselectedIconTheme: IconThemeData(
          color: Colors.deepOrangeAccent,
        ),


        onTap: (index) {
          _selectedScreen = index;
          setState(() {});
        },

        currentIndex: _selectedScreen,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.new_label_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_outline), label: 'DepositHistory'),
          BottomNavigationBarItem(
              icon: Icon(Icons.close_outlined), label: 'RechargeHistory'),
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit_sharp), label: 'TransferHistory'),

        ],
      ),
    );
  }
}

