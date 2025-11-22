import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:projek_mobile/var.dart' as globals;
import 'package:projek_mobile/login/Signin.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Menu extends StatefulWidget {
  final int idKategori;
  const Menu({super.key, required this.idKategori});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final formatter = NumberFormat('#,###', 'id_ID');
  List produk = [];

  // FUNGSI API MENGAMBIL PRODUK BERDASARKAN KATEGORI
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: Icon(
          Icons.shopping_cart,
          color: AppColors.secondWhite,
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(16)
        ),
      ),

      appBar: AppBar(
        title: Text(
          () {
            if (globals.isLogin == false) {
              return "Selamat Datang";
            } else {
              if (widget.idKategori == 1) {
                return "Makan apa hari ini, ${globals.username}?";
              } else if (widget.idKategori == 2) {
                return "Mau Minum apa, ${globals.username}?";
              } else {
                return "Kategori Tidak Dikenal";
              }
            }
          }(),
        ),
      ),

      // DRAWER
      endDrawer: Drawer(
        backgroundColor: AppColors.primaryGreen,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 150),

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

              if (globals.username == "admin" )
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Dashboard",
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
              
            if (globals.isLogin == true)
              SizedBox(height: 200),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    globals.logout(context);
                  },
                ),
              ),

              if (globals.isLogin == false)            
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
              ),

            ],
          ),
        ),
      ),

      body: Column(
        children: [

          // SEARCH BAR
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: widget.idKategori == 1 ? "Nasi Goreng..." : "Teh Dingin...",
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

          // TULISAN HEADER (Makanan /  Minuman)
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(12, 20, 0, 0),
                  child: Text(
                    widget.idKategori == 1 ? "Makanan" : "Minuman", //widget.idKategori apakah 1? kalo iya makanan, kalo engga, Minuman
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                )
              ],
            ),
          ),

          // LISTVIEW HARUS DI DALAM EXPANDED
          Expanded(
            child: ListView.builder(
              itemCount: produk.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // BAGIAN KIRI
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // NAMA PRODUK
                                Text(
                                  produk[index]['nama_produk'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),

                                // HARGA
                                Text(
                                  "Rp, ${formatter.format(produk[index]['harga'])},-",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 5),

                                // RATING (STATIC)
                                Row(
                                  children: List.generate(5, (i) {
                                    return Icon(
                                      Icons.star,
                                      size: 18,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                                SizedBox(height: 6),

                                // DESKRIPSI PRODUK
                                Text(
                                  produk[index]['deskripsi'] ?? "",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),

                          //  BAGIAN KANAN (GAMBAR + ADD)
                          Column(
                            children: [
                              // GAMBAR
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(10),
                                  image: produk[index]['path_gambar'] != null
                                      ? DecorationImage(
                                          image: NetworkImage(
                                            "http://localhost${produk[index]['path_gambar'].replaceAll('\\', '/')}",
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(height: 10),

                              // Tombol ADD
                              SizedBox(
                                width: 90,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryGreen,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8))
                                  ),
                                  onPressed: produk[index]['status'] == 'Tersedia'
                                  ? () {

                                  }
                                  : null,
                                  child: Center(
                                    child: Text(
                                      produk[index]['status'] ==  "Tersedia" ? "ADD" : "Habis",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    // GARIS PEMBATAS
                    Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      )
    );
  }
}