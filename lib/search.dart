import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek_mobile/main.dart';
import 'package:projek_mobile/var.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projek_mobile/login/SignIn.dart';
import 'package:projek_mobile/menu/cart.dart';

class SearchPage extends StatefulWidget {
  final String keyword;

  const SearchPage({super.key, required this.keyword});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isNavigate = false;

  // FUNGSI API CARI PRODUK
  Future searchProduk(String keyword) async {
    String url = "$urlAPI/cari_produk.php?keyword=$keyword";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json =  jsonDecode(response.body);

      if (json['data'] == null) {
        return [];
      }

      return json['data'];
    } else {
      throw Exception("MASALAH KONEKSI");
    }
  }

  // FUNGSI API TAMBAH PRODUK KERANJANG
  Future<bool> addToCart(int idUser, int idProduk) async {
    final url = Uri.parse("$urlAPI/add_to_cart.php");

    final response = await http.post(url, body: {
      "id_user": idUser.toString(),
      "id_produk": idProduk.toString(),
    });

    var data = jsonDecode(response.body);
    return data['success'] == true;
  }

  @override
  void initState() {
    super.initState();
    searchProduk(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
            child: Row(
              children: [

                // TOMBOL KEMBALI
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),

                // SEARCH BAR
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => SearchPage(keyword: value))
                        ).then((_) {
                          searchController.clear();
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: widget.keyword,
                      hintStyle: TextStyle(color: AppColors.secondBlack),
                      prefixIcon: Icon(Icons.search),                border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      filled: true,
                      fillColor: AppColors.thirdGreen,
                    ),
                  ),
                ),

                // TOMBOL KERANJANG
                Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => Cart())
                        
                      );
                    }, 
                    icon: Icon(
                      Icons.shopping_cart,
                      color: AppColors.secondWhite,
                    )
                  ),
                )
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: searchProduk(widget.keyword), 
              builder:(context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("ADA"));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("GA ADA DATA"),);
                }

                final search = snapshot.data!;

                return ListView.builder(
                  itemCount: search.length,
                  itemBuilder:(context, index) {
                    final hasil = search[index];

                    // TEMPLATE CARD
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
                                      hasil['nama_produk'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: 5),

                                    // HARGA
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0
                                      ).format(hasil['harga'])
                                    ),
                                    SizedBox(height: 5),

                                    // DESKRIPSI
                                    Text(
                                      hasil['deskripsi'],
                                      style: TextStyle(
                                        color: AppColors.secondBlack,
                                        fontSize: 14
                                      ),
                                    )
                                  ],
                                )
                              ),

                              // BAGIAN KANAN
                              Column(
                                children: [
                                  
                                  // GAMBAR
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10),
                                      image: hasil['path_gambar'] != null
                                      ? DecorationImage(
                                        image: NetworkImage(
                                          'http://10.0.2.2/${hasil['path_gambar'].replaceAll('\\', '/') }',
                                        ),
                                        fit: BoxFit.cover
                                      )
                                      : null,
                                    ),
                                  ),
                                  SizedBox(height: 10),

                                  // TOMBOL PESAN
                                  SizedBox(
                                    width: 90,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryGreen,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                                      ),
                                      onPressed: hasil['status'] == 'Tersedia'
                                      ? () async {
                                        if (isLogin == true) {
                                          final int idProduk = int.parse(hasil['id_produk'].toString());

                                          // AMBIL ID USER LOGIN (SHARRED PREFERANCE)
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          int? idUser = prefs.getInt('id_user');

                                          if (idUser == null) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("SILAHKAN LOGIN TERLEBIH DAHULU"))
                                            );
                                            return;
                                          }

                                          bool ok = await addToCart(idUser, idProduk);

                                          if (ok) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Ditambahkan Ke Keranjang"))
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('SILAHKAN LOGIN DULU :)'))
                                          );
                                          Navigator.push(
                                            context, 
                                            MaterialPageRoute(builder: (context) => LoginPage())
                                          );
                                        }
                                      }
                                      : null, 
                                      child: Center(
                                        child: Text(
                                          hasil['status'] == 'Tersedia'? "Pesan" : "Habis",
                                          style: TextStyle(
                                            color: AppColors.secondWhite,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      )
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),

                        // GARIS PEMBATAS
                        Divider(
                          indent: 10,
                          endIndent: 10,
                        )
                      ],
                    );
                  },
                );


              },
            ),
          )

        ],
      ),
    );
  }
}