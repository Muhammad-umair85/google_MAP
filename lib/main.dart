import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Screens/main_screen.dart';
import 'package:rider_app/Screens/rider_login.dart';
import 'package:rider_app/Screens/signup_rider.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Handler/appData.dart';


final databaseReference = FirebaseDatabase.instance.reference().child("Users");
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          primarySwatch: Colors.blue,
        ),
        home:MainScreen(),
      ),
    );
  }
}

