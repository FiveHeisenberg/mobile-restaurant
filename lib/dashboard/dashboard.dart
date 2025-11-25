import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:projek_mobile/var.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projek_mobile/dashboard/manage_stock.dart';
import 'package:projek_mobile/dashboard/manage_produk.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List produk = [];
  int totalIncome = 0;
  int totalSold = 0;
  List produkData = [];
  bool isLoading = false;

  // FORMATER RUPIAH
  final rupiah = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // FUNGSI API MENGAMBIL PRODUK YANG HABIS
  Future<void> getProdukSoldOut() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost/resto/menu.php?status=Habis"),
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
      setState(() {});
    }
  }

  // FUNGSI API MENGAMBIL TOTAL PENDAPATAN
  Future getIncome() async {
    final response = await http.get(
      Uri.parse("http://localhost/getIncome.php"),
    );

    if (response.statusCode == 200){
      var data = jsonDecode(response.body);
      setState(() {
        totalIncome = data['total_pendapatan'];
      });
    }  
  }

  // FUNGSI API MENGAMBIL TOTAL TERJUAL
  Future getTotalSold() async {
    final response = await  http.get(
      Uri.parse("http://localhost/resto/getTotalSold.php")
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        totalSold = data['total_produk_terjual'];
      });
    }
  }

  // FUNGSI REFRESH DASHBOARD JIKA ADA PERUBAHAN
  Future<void> refreshDashboard() async {
    await getProdukSoldOut();
    await getIncome();
    await getTotalSold();
  }

  @override
  void initState() {
    super.initState();
    getProdukSoldOut();
    getIncome();
    getTotalSold();
    refreshDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),

      // DRAWER
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => manageProduk())
                    );
                  },
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                  onTap: () {},
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // MANAJEMEN STOCK
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Manajemen Stock",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => ManageStock())
                    );
                    
                    refreshDashboard();
                  },
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                  onTap: () {},
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // LOGOUT
              SizedBox(height: 200),
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
                    borderRadius: BorderRadius.circular(12),
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
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Pendapatan",
                    style: TextStyle(
                      color: AppColors.secondWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    rupiah.format(totalIncome),
                    style: TextStyle(
                      color: AppColors.secondWhite,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                    height: 120,
                    padding: EdgeInsets.all(15),
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
                        Text(
                          "$totalSold",
                          style: TextStyle(
                            color: AppColors.secondWhite,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // PRODUK HABIS
                SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 120,
                    padding: EdgeInsets.all(15),
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
                        Text(
                          "${produk.length}",
                          style: TextStyle(
                            color: AppColors.secondWhite,
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 15),
            Text(
              "Top 3 Produk Terlaris",
              style: TextStyle(
                color: AppColors.secondBlack,
                fontSize: 23,
                fontWeight: FontWeight.w600
              ),
            )
          ],
        ),
      ),
    );
  }
}