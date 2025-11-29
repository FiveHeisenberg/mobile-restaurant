import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projek_mobile/dashboard/addproduct.dart';
import 'package:projek_mobile/dashboard/editproduct.dart';


class manageProduk extends StatefulWidget {
  const manageProduk({super.key});

  @override
  State<manageProduk> createState() => _manageProdukState();
}

class _manageProdukState extends State<manageProduk> {
  String selectedKategori = "Semua";
  late Future<List> _futureProduk;

  // FUNGSI API MENGAMBIL DATA PRODUK
  Future<List> fetchProduk() async {
    final response = await http.get(
      Uri.parse("http://localhost/resto/menu.php")
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['data'];
    } else {
      throw Exception("Gagal mengambil data produk");
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
    _futureProduk = fetchProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manajemen Produk"),
      ),

      // TOMBOL TAMBAH PRODUK
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => Addproduct()),
          );
          if (result == true) {
            setState(() {
              _futureProduk = fetchProduk();
            });
          }
        },
        backgroundColor: AppColors.primaryGreen,
        child: Icon(
          Icons.add,
          color: AppColors.secondWhite,
          size: 32,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // SEARCH BAR
            Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 20),
              child: TextField(
                decoration: InputDecoration(
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
                    : AppColors.primaryGreen,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                SizedBox(width: 15),
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
                SizedBox(width: 15),
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
              ]
            ),
            
            Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Kelola Produk',
                style: TextStyle(
                  color: AppColors.secondBlack,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // LIST PRODUK
            FutureBuilder(
              future: _futureProduk, 
              builder: (context, snapshot) {

                // jika masih loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Jika ada error
                if (snapshot.hasError) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                // Jika data kosong
                if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text("Tidak ada produk")),
                  );
                }

                // Ambil dan filter data
                List allProduk = snapshot.data!;
                List dataProduk = getFilteredProduk(allProduk);

                // Jika hasil filter kosong
                if (dataProduk.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Text("Tidak ada produk $selectedKategori"),),
                  );
                }
          
                
                return ListView.builder(
                  itemCount: dataProduk.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (context, index) {
                    final p = dataProduk[index];

                    // TEMPLATE CARD UI LIST PRODUK
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
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

                      // ISI CARD NYA
                      child: Row(
                        children: [
                          // FOTO PRODUK
                          ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(8),
                            child: Image.network(
                              "http://localhost${p['path_gambar']}",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,

                              // KALO GAMBARNYA GAADA, MUNCUL ICON
                              errorBuilder: (context, error, StackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: Icon(
                                    Icons.fastfood,
                                    color: Colors.grey[600],
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),

                          // DETAIL PRODUK
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // NAMA PRODUK
                                Text(
                                  p['nama_produk'] ?? "Nama Tidak Tersedia",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // HARGA
                                Text(
                                  NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: 'Rp ',
                                    decimalDigits: 0,
                                  ).format(p['harga'] ?? 0),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),

                                // DESKRIPSI
                                SizedBox(height: 4),
                                Text(
                                  p['deskripsi'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            )
                          ),

                          // TOMBOL EDIT
                          ElevatedButton(
                            onPressed: ()  async {
                              final result = await Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => Editproduct(produk: p))
                              );
                              
                              if (result == true) {
                                setState(() {
                                  _futureProduk = fetchProduk();
                                });
                              }
                            }, 
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                color: AppColors.secondWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              )
                            ),
                          )
                        ],
                      ),
                    );
                  }
                );
              }
            )
          ],
        ),
      ),
    );
  }
}