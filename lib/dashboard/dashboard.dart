import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:projek_mobile/var.dart' as globals;
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List produk = [];

  // FUNGSI API MENGAMBIL PRODUK YANG HABIS
  Future<void> getProdukSoldOut() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost/menu.php?status=Habis") 
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);        
        setState(() {
          if (body['data'] != null && body['data'] is List) {
            produk = List<dynamic>.from(body['data']);
          }
        });
      } 
    } catch (e) {
      setState(() {
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProdukSoldOut();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),

      endDrawer: Drawer(
        backgroundColor: AppColors.primaryGreen,
        child: SingleChildScrollView(
          child: Column(
            children: [

              // MANAJEMEN PRODUK
              SizedBox(height: 150),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                child: ListTile(
                  title: Text(
                    "Manajemen Produk",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    
                  },
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12) 
                  ),
                ),
              ),

              // MANAJEMEN PESANAN
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Manajemen Pesanan",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {

                  },
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ),
            
              // MANAJEMEN USER
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Manajemen User",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {

                  },
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ),

              // LOGOUT
              SizedBox(height: 250),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    setState(() {
                      globals.isLogin = false; 
                    });
                    globals.logout(context);
                  },
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // TOTAL PENDAPATAN
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Pendapatan",
                          style: TextStyle(
                            color: AppColors.secondWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Rp. 1.200.00,-",
                          style: TextStyle(
                            color: AppColors.secondWhite,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),

                  // PRODUK TERJUAL & HABIS
                  SizedBox(height: 20),
                  Row(
                    children: [
                      
                      // PRODUK TERJUAL
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Produk Terjual",
                                style: TextStyle(
                                  color: AppColors.secondWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "43",
                                style: TextStyle(
                                  color: AppColors.secondWhite,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          ),
                        )
                      ),

                      // PRODUK HABIS
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Produk Habis",
                                style: TextStyle(
                                  color: AppColors.secondWhite,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${produk.length}",
                                style: TextStyle(
                                  color: AppColors.secondWhite,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                        )
                      )
                    ],
                  )
                ],
              ),
            )
    );
  }
}