import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'database/db_helper.dart';
import 'earnings.dart';
import 'invoices.dart';
import 'reminders.dart';


class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/earnings');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/invoices');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/reminders');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),backgroundColor: Colors.green[900],centerTitle: true,leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.black,)),),
      body: Stack(
        children: [
          Expanded(child: Container(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)),)),
          Align(alignment: Alignment(0,-0.65),child: OutlinedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> Invoices()));},child: Text("  Invoices  ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40),),style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white,width: 2)),)),
          Align(alignment: Alignment(0,-0.25),child: OutlinedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> Reminders()));},child: Text("Reminders",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40),),style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white,width: 2)),)),
          Align(alignment: Alignment(0,0.15),child: OutlinedButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=> Earnings()));},child: Text("  Earnings  ",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40),),style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white,width: 2)),))
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: BottomNavigationBar(backgroundColor: Colors.black,selectedItemColor: Colors.green[300], unselectedItemColor: Colors.white, currentIndex: _selectedIndex,
          onTap: _onItemTapped, items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",),
            BottomNavigationBarItem(icon: Icon(Icons.money), label: "Earnings",),
            BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Invoices"),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.bell_solid), label: "reminders"),
          ],
        ),
      ),
    );
  }
}