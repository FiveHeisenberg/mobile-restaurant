import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:projek_mobile/var.dart' as globals;
import 'package:projek_mobile/login/Signin.dart';
import 'package:http/http.dart' as http;

class Menu extends StatefulWidget {
  final int idKategori;
  const Menu({super.key, required this.idKategori});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List produk = [];

  Future getProdukByKategori() async {
    final response = await http.get(
      Uri.parse('http://localhost/menu.php?id_kategori=${widget.idKategori}')
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      setState(() {
        produk = body['data'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProdukByKategori();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Makan Apa Hari ini, ${globals.username}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ),

      endDrawer: Drawer(
        backgroundColor: AppColors.primaryGreen,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 200),

              if (globals.isLogin)
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 20, 20, 5),
                child: ListTile(
                  title: Text(
                    "Profiles",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {

                  },
                ),
              ),

              if (globals.isLogin)
              Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Keranjang",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {

                  },
                ),
              ),

              if(globals.isLogin)
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {

                  },
                ),
              ),
              
              if (globals.isLogin)
              SizedBox(height: 250),
              globals.isLogin ? 
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  onTap: () {
                    globals.logout(context);
                  },
                ),
              ) : 
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => LoginPage())
                    );
                  },
                ),
              )              
            ],
          ),
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Nasi Goreng . . .',
                hintStyle: TextStyle(color: AppColors.secondBlack),
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                filled: true,
                fillColor: AppColors.thirdGreen,
              ),
            ),
          ),

          // 🔥 LISTVIEW HARUS DI DALAM EXPANDED
          Expanded(
            child: ListView.builder(
              itemCount: produk.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(produk[index]['nama_produk']),
                  subtitle: Text("${produk[index]['harga']}"),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}