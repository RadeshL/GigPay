import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'database/db_helper.dart';
import 'earnings.dart';
import 'home.dart';
import 'reminders.dart';

class Invoices extends StatefulWidget {
  const Invoices({super.key});

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  List<Map<String, dynamic>> invoices = [];
  @override
  void initState() {
    super.initState();
    fetchInvoices();
  }

  Future<void> clearDatabase() async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('invoices');
  }

  Future<void> fetchInvoices() async {
    final db = await DatabaseHelper.instance.database;
    final data = await db.query('invoices');
    setState(() {
      invoices = data;
    });
  }

  Future<void> updateStatus(int id, String newStatus) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'invoices',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
    fetchInvoices();
  }

  int _selectedIndex = 2;

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
      appBar: AppBar(title: Text("Invoices",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),backgroundColor: Colors.green[900],centerTitle: true,),
      body: Stack(children: [
        Expanded(child: Container(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)),)),
        invoices.isEmpty
            ? Center(child: Text("No invoices yet!", style: TextStyle(fontSize: 18, color: Colors.green[300])))
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final invoice = invoices[index];
            bool isPaid = invoice['status'] == "Paid";

            return Card(
              color: Colors.green[300],
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  invoice['client_name'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Amount: ₹${invoice['amount']}",
                  style: TextStyle(fontSize: 14),
                ),
                trailing: ToggleButtons(
                  isSelected: [isPaid, !isPaid],
                  onPressed: (index) {
                    String newStatus = index == 0 ? "Paid" : "Unpaid";
                    updateStatus(invoice['id'], newStatus);
                  },
                  color: Colors.black,
                  selectedColor: Colors.green,
                  fillColor: isPaid ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(8),
                  children: [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("paid",style: TextStyle(color: Colors.white),)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("Unpaid",style: TextStyle(color: Colors.white),)),
                  ],
                ),
              ),
            );
          },
        ),
        Align(alignment: Alignment(0.8, 0.85), child: FloatingActionButton(onPressed: () async{await Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateInvoice()));fetchInvoices();}, child: Icon(Icons.add,color: Colors.white,),backgroundColor: Colors.green,)),
        Align(
          alignment: Alignment(-0.85, 0.85),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green,),
            onPressed: () async {
              await clearDatabase();
              fetchInvoices();
            },
            child: Text("Clear Database",style: TextStyle(fontSize: 15,color: Colors.white),),
          ),
        )
      ],),
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

class CreateInvoice extends StatefulWidget {
  const CreateInvoice({super.key});

  @override
  State<CreateInvoice> createState() => _CreateInvoiceState();
}

class _CreateInvoiceState extends State<CreateInvoice> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _duedateController = TextEditingController();
  bool isPaid=false;
  Future<void> saveInvoiceToDB() async {
    final db = await DatabaseHelper.instance.database;

    String clientName = _clientNameController.text;
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    String dueDate = _duedateController.text;
    String status = isPaid ? "Paid" : "Unpaid";

    if (clientName.isEmpty || amount <= 0 || dueDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter all details correctly!"))
      );
      return;
    }

    await db.insert(
      'invoices',
      {
        'client_name': clientName,
        'amount': amount,
        'due_date': dueDate,
        'status': status,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invoice Saved Successfully!"))
    );
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
        Navigator.pushReplacementNamed(context, '/invoices');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/reminders');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/earnings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Invoice",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),backgroundColor: Colors.green[900],centerTitle: true,),
      body: Stack(children: [
        Expanded(child: Container(height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/background.png'),fit: BoxFit.cover)),)),
        Stack(children: [
          Padding(padding: EdgeInsets.fromLTRB(40, 60, 20, 10),child: Text("CLIENT'S NAME:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
          SizedBox(width: 50,),
          Padding(padding: EdgeInsets.fromLTRB(40, 110, 20, 10),child: Expanded(child: TextField(controller: _clientNameController,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter Client's name",enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),),))),
          Padding(padding: EdgeInsets.fromLTRB(40, 210, 20, 10),child: Text("AMOUNT:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
          SizedBox(width: 50,),
          Padding(padding: EdgeInsets.fromLTRB(40, 260, 20, 10),child: Expanded(child: TextField(controller: _amountController,keyboardType:TextInputType.number,inputFormatters:[FilteringTextInputFormatter.digitsOnly],decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter amount",enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),),))),
          Padding(padding: EdgeInsets.fromLTRB(40, 360, 20, 10),child: Text("DUE DATE:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
          SizedBox(width: 50,),
          Padding(padding: EdgeInsets.fromLTRB(40, 410, 20, 10),child: Expanded(child: TextField(controller: _duedateController,decoration: InputDecoration(border: OutlineInputBorder(),hintText: "Enter due date",enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),),))),
          Row(children: [
            Padding(padding: EdgeInsets.fromLTRB(40, 510, 20, 10),child: Text("STATUS:",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
            SizedBox(width: 10,),
            Padding(
              padding: EdgeInsets.fromLTRB(60, 510, 20, 10),
              child: ToggleButtons(
                isSelected: [isPaid,!isPaid],
                onPressed: (index) {
                  setState(() {
                    isPaid = (index==0);
                  });
                },
                color: Colors.white,
                selectedColor: Colors.white,
                fillColor: isPaid ? Colors.green : Colors.red,
                borderColor: Colors.grey,
                selectedBorderColor: isPaid ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
                children: [
                  Padding(padding: EdgeInsets.symmetric(vertical: 10),child: Text("Paid",style: TextStyle(fontSize: 15,color: Colors.white),),),
                  Padding(padding: EdgeInsets.symmetric(vertical: 10),child: Text("Unpaid",style: TextStyle(fontSize: 15,color: Colors.white),),),
                ],

              ),
            )
          ],),
          Align(alignment: Alignment(0,0.8),child: OutlinedButton(onPressed: () async{
            await saveInvoiceToDB();
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MyHome()));},
            child: Text("OK",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),),
            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white,width: 2)),))
        ],)
      ],),
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