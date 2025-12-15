import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projek_mobile/var.dart';

class ManageStock extends StatefulWidget {
  const ManageStock({super.key});

  @override
  State<ManageStock> createState() => _ManageStockState();
}

class _ManageStockState extends State<ManageStock> {
  late Future<List> _futureProduk = fetchProduk(); 
  String selectedKategori = "Semua";

  // FUNGSI API MENGAMBIL DATA PRODUK
  Future<List> fetchProduk() async {
    final response = await http.get(
      Uri.parse("$urlAPI/menu.php")
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'];
    } else {
      throw Exception("Gagal mengambil data produk");
    }
  }

  // FUNGSI API UPDATE STATUS PRODUK
  Future<void> updateStatus(int idProduk, bool tersedia) async {
    final response = await http.post(
      Uri.parse("$urlAPI/update_stok.php"),
      body: {
        "id_produk": idProduk.toString(),
        "status": tersedia ? "Tersedia" : "Habis",
      }
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal update status");
    }
  } 

  // FUNGSI FILTER PRODUK BERDASARKAN KATEGORI
  List getFilteredProduk(List allProduk) {
    if (selectedKategori == "Semua") {
      return allProduk;
    }
    return allProduk.where((p) => p['nama_kategori'] == selectedKategori).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manajemen Stok Menu"),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SEARCH BAR
            // Padding(
            //   padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       hintStyle: TextStyle(color: AppColors.secondBlack),
            //       prefixIcon: Icon(Icons.search),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(50),
            //       ),
            //       filled: true,
            //       fillColor: AppColors.thirdGreen,
            //     ),
            //   ),
            // ),

            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // TOMBOL SEMUA PRODUK
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedKategori = "Semua";
                    });
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedKategori == "Semua"
                    ? Colors.grey
                    : AppColors.primaryGreen,                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: Text(
                    "Semua",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondWhite,
                    ),
                  )
                ),

                // TOMBOL MENU MAKANAN
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedKategori = "Makanan";
                    });
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedKategori == "Makanan"
                    ? Colors.grey
                    : AppColors.primaryGreen,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: Text(
                    "Makanan",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondWhite,
                    ),
                  )
                ),

                // TOMBOL MENU MINUMAN
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedKategori = "Minuman";
                    });
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedKategori == "Minuman"
                    ? Colors.grey
                    : AppColors.primaryGreen,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  child: Text(
                    "Minuman",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondWhite,
                    ),
                  )
                ),
              ],
            ),

            // "KELOLA STOK PRODUK"
            SizedBox(height: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Kelola Stok Produk",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25
                    ),
                  ),
                )
              ],
            ),
          
            // MENU
            FutureBuilder(
              future: _futureProduk, 
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("Tidak ada produk"),
                  );
                }

                List allProduk = snapshot.data!;
                List dataProduk = getFilteredProduk(allProduk);

                if (dataProduk.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("Tidak ada produk $selectedKategori"),
                  );
                }

                return ListView.builder(
                  itemCount: dataProduk.length,
                  shrinkWrap: true,
                  physics:  NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder:(context, index) {
                    final p = dataProduk[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondWhite,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            offset: Offset(0, 3)
                          )
                        ]
                      ),

                      child: Row(
                        children: [

                          // FOTO PRODUK
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(
                                  "http://10.0.2.2/${p['path_gambar']}"
                                )
                              )
                            ),
                          ),

                          // NAMA + HARGA
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // NAMA PRODUK
                                Text(
                                  p['nama_produk'] ?? 'Nama tidak Tersedia',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),

                                // HARGA PRODUK
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(p['harga'] ?? 0),
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            )
                          ),

                          // TOGLE STATUS PRODUK
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Switch(
                                value: p['status'] == 'Tersedia',
                                activeColor: AppColors.secondWhite,
                                activeTrackColor: AppColors.primaryGreen,
                                inactiveThumbColor: AppColors.secondWhite,
                                inactiveTrackColor: Colors.grey,

                                onChanged: (value) async {
                                  dataProduk[index]['status'] = value ? 'Tersedia' : 'Habis';
                                  setState(() {});
                                  await updateStatus(p['id_produk'], value);
                                },
                              ),

                              Text(
                                p['status'] == 'Tersedia' ? "Tersedia" : "Habis",
                                style: TextStyle(
                                  color: p['status'] == 'Tersedia'
                                  ? AppColors.primaryGreen
                                  : Colors.grey,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              }
            )
          ],
        ),
      ),
    );
  }
}