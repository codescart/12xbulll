import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twelve_x_bull/bottom_navbar.dart';
import 'package:twelve_x_bull/login_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final userid=prefs.getString("userId");
  runApp(MyApp(
    userId:userid
  ));
}

class MyApp extends StatelessWidget{
  final String? userId;
  MyApp({this.userId});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:userId==null?Login_Page():Bottom_Navbar(),
    );
  }
}

