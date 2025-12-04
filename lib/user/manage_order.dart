import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';

class ManageOrder extends StatefulWidget {
  const ManageOrder({super.key});

  @override
  State<ManageOrder> createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History Pembelian"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) => MyApp()), 
              (route) => false,
            );
          }, 
          icon: Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}