import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'database/db_helper.dart';
import 'earnings.dart';
import 'home.dart';
import 'invoices.dart';
import 'reminders.dart';
import 'splashscreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.database;
  runApp(MaterialApp(
    theme: ThemeData(useMaterial3: false,bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Colors.black)),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    initialRoute: '/',
    routes: {'/home' : (context) => MyHome(),'/invoices' : (context) => Invoices(),'/reminders': (context) => Reminders(),'/earnings' : (context) => Earnings(),},
  ));
}
























