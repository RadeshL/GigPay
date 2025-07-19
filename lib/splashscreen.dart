import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'database/db_helper.dart';
import 'earnings.dart';
import 'home.dart';
import 'invoices.dart';
import 'reminders.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration(seconds: 2),() {
    //  Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHome()));
    //});
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/home');
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Padding(padding: EdgeInsets.fromLTRB(130, 250, 50, 50),child: CircleAvatar(backgroundImage: AssetImage('assets/logogp.png'),radius: 80,)),
            SizedBox(height: 20,),
            Padding(padding: EdgeInsets.fromLTRB(130, 450, 50, 50),child: Text("GigPay", style: TextStyle(fontFamily: 'MyFonts',fontSize: 100,fontWeight: FontWeight.bold,color: Colors.white),)),
            SizedBox(height: 150,),
            Padding(padding: EdgeInsets.fromLTRB(150, 700, 50, 50),child: Text("Tap to continue",style: TextStyle(fontSize: 15,color: Colors.white),))
          ],
        ),
      ),
    );
  }
}