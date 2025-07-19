import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'database/db_helper.dart';
import 'home.dart';
import 'invoices.dart';
import 'reminders.dart';


class Earnings extends StatefulWidget {
  const Earnings({super.key});

  @override
  State<Earnings> createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  double totalEarnings = 0.0;
  double paidAmount = 0.0;
  double unpaidAmount = 0.0;
  Map<String, dynamic>? topClient;

  @override
  void initState() {
    super.initState();
    _fetchEarningsData();
  }

  Future<void> _fetchEarningsData() async {
    final Database db = await DatabaseHelper.instance.database;
    final totalResult = await db.rawQuery("SELECT SUM(amount) as total FROM invoices");
    totalEarnings = totalResult.first["total"] as double? ?? 0.0;
    final paidResult = await db.rawQuery("SELECT SUM(amount) as paid FROM invoices WHERE status = 'Paid'");
    paidAmount = paidResult.first["paid"] as double? ?? 0.0;
    final unpaidResult = await db.rawQuery("SELECT SUM(amount) as unpaid FROM invoices WHERE status = 'Unpaid'");
    unpaidAmount = unpaidResult.first["unpaid"] as double? ?? 0.0;
    final topClientResult = await db.rawQuery('''
      SELECT client_name, SUM(amount) AS total_amount 
      FROM invoices 
      WHERE status = 'Paid' 
      GROUP BY client_name 
      ORDER BY total_amount DESC 
      LIMIT 1
    ''');
    if (topClientResult.isNotEmpty) {
      topClient = topClientResult.first;
    }
    setState(() {});
  }

  int _selectedIndex = 1;

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
      appBar: AppBar(title: Text("Earnings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)), backgroundColor: Colors.green[900], centerTitle: true,),
      body: Stack(
        children: [
          Expanded(child: Container(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)),)),
          Padding(padding: const EdgeInsets.all(20), child: Stack(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(10, 50, 5, 5),child: Row(children: [Expanded(child: Card(color: Colors.blue[300],child: Padding(padding: EdgeInsets.all(10),child: Text("TOTAL EARNINGS: ₹$totalEarnings",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.blue[900]),))))],)),
              Padding(padding: EdgeInsets.fromLTRB(10, 200, 5, 5),child: Row(children: [Expanded(child: Card(color: Colors.green[300],child: Padding(padding: EdgeInsets.all(10),child: Text("PAID AMOUNT: ₹$paidAmount",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.green[900]),))))],)),
              Padding(padding: EdgeInsets.fromLTRB(10, 350, 5, 5),child: Row(children: [Expanded(child: Card(color: Colors.red[300],child: Padding(padding: EdgeInsets.all(10),child: Text("UNPAID AMOUNT: ₹$unpaidAmount",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.red[900]),))))],)),
              Padding(padding: EdgeInsets.fromLTRB(25, 500, 5, 5),child: Text("TOP CLIENT 🔥:",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),)),
              if ( topClient != null) ... [
                Padding(padding: EdgeInsets.fromLTRB(25, 550, 5, 5),child: Text("${topClient!['client_name']}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),)),
                Padding(padding: EdgeInsets.fromLTRB(25, 590, 5, 5),child: Text("Earnings: ${topClient!['total_amount']}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),)),
              ],

            ],
          )
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green[300],
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home",),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: "Earnings",),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Invoices"),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.bell_solid), label: "reminders"),
        ],
      ),
    );
  }
}