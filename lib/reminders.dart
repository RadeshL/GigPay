import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'database/db_helper.dart';
import 'earnings.dart';
import 'home.dart';
import 'invoices.dart';


class Reminders extends StatefulWidget {
  const Reminders({super.key});

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {

  List<Map<String, dynamic>> unpaidInvoices = [];

  @override
  void initState() {
    super.initState();
    _fetchUnpaidInvoices();
  }

  Future<void> _fetchUnpaidInvoices() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      'invoices',
      where: 'status = ?',
      whereArgs: ['Unpaid'],
    );

    setState(() {
      unpaidInvoices = result;
    });
  }

  int _selectedIndex = 3;

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
      appBar: AppBar(title: Text("Reminders",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),backgroundColor: Colors.green[900],centerTitle: true,),
      body: Stack(children: [
        Expanded(child: Container(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)),)),
        unpaidInvoices.isEmpty ? Center(child: Text("No unpaid invoices!", style: TextStyle(fontSize: 18, color: Colors.green[300]),),) :
        ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: unpaidInvoices.length,
          itemBuilder: (context, index) {
            final invoice = unpaidInvoices[index];
            return Card(margin: EdgeInsets.symmetric(vertical: 9), color: Colors.red,
              child: ListTile(
                leading: Icon(Icons.warning, color: Colors.black),
                title: Text(invoice['client_name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                subtitle: Text("Due Date: ${invoice['due_date']}", style: TextStyle(fontSize: 16, color: Colors.white),),
              ),
            );
          },
        ),
      ],),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
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