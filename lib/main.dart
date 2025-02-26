
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:ratailapp/App/Screen/LogInPage.dart';
import 'package:ratailapp/App/Screen/NavigationBar.dart';

import 'package:ratailapp/firebase_options.dart';
import 'package:ratailapp/App/AdminPanel/AdminNavigationBarPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Retail App",
      debugShowCheckedModeBanner: false,
      color: Colors.blueAccent,
      theme: ThemeData(primaryColor: Colors.lightBlue),
      darkTheme: ThemeData(primaryColor: Colors.black54),
      themeMode: ThemeMode.dark,
      home: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // or a splash screen
              ),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else {
            final user = snapshot.data;
            if (user != null) {
              if (user.uid == "O2GV6e7kUUN4ZhRTgs4JwvUipg43") {
                return AdminMainBottomNavBar();
              } else {
                return MainBottomNavBar();
              }
            } else {
              return LogInSreen();
            }
          }
        },
      ),
    );
  }
}