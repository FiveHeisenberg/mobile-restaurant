import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projek_mobile/menu/checkout.dart';
import 'package:projek_mobile/var.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<dynamic> cartItems = [];
  bool isLoading = true;
  String? userId;
  int total = 0;

  // FUNGSI MEMUAT ID USER
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    int? saveId = prefs.getInt('id_user');

    if (saveId != null) {
      setState(() {
        userId = saveId.toString();
      });
      fetchCart();
    }
  }

  // FUNGSI API MENGAMBIL DATA KERANJANG
  Future<void> fetchCart() async {
    final url = Uri.parse("$urlAPI/get_cart.php");

    try {
      final response = await http.post(
        url,
        body: {'id_user': userId.toString()},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          setState(() {
            total = 0;
            cartItems = jsonResponse['cart'];
            isLoading = false;
          });

          fetchTotal();
        } else {
          throw Exception("Gagal memuat keranjang");
        }
      } else {
        throw Exception('Gagal menghubungi server');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"))
      );
    }
  }

  // FUNGSI API MENGHITUNG TOTAL PAYMENT
  Future<void> fetchTotal() async {
    if (userId == null) return;

    final url = Uri.parse("$urlAPI/get_total.php");
    try {
      final response = await http.post(
        url,
        body: {'id_user': userId!},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          int fetchedTotal = data['total'] is int
            ? data['total']
            : int.tryParse(data['total'].toString()) ?? 0;
          
          setState(() {
            total = fetchedTotal;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("GAGAL MEMUAT TOTAL PEMBAYARAN"))
      );
    }
  }

  // FUNGSI API MEMPERBARUI JUMLAH PRODUK
  Future<void> updateCartItem(int idCartItem, int newQuantity) async {
    final url = Uri.parse("$urlAPI/update_jumlah.php");

    try {
      final response = await http.post(
        url,
        body: {
          'id_cart_item': idCartItem.toString(),
          'jumlah': newQuantity.toString(),
        }
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          
          // JIKA ITEM DIHAPUS (JUMLAH <= 0)
          if (data['deleted'] == true) {
            // HAPUS ITEM DARI DAFTAR LOKAL
            setState(() {
              cartItems.removeWhere((item) => item['id_cart_item'] == idCartItem.toString());
            });
          } else {
            // PERBARUI JUMLAH DI DAFTAR LOKAL
            setState(() {
              final index = cartItems.indexWhere((item) => item['id_cart_item'] == idCartItem.toString());
              if (index != -1) {
                cartItems[index]['jumlah'] = newQuantity.toString();
              }
            });
          }
          // SETELAH UPDATE, AMBIL ULANG TOTAL
          fetchTotal();
        } else {
          throw Exception('Gagal memperbarui jumlah');
        }
      } else {
        throw Exception('Reponse server tidak valid');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: $e'))
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondWhite,
        title: Text("Keranjang"),
      ),

      body: Column(
        children: [
          // LIST PRODUK KERANJANG
          Expanded(
            child: isLoading
            ? Center(child: CircularProgressIndicator())
            : cartItems.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Keranjang Kosong',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  String nama = item['nama_produk'] ?? 'Produk';
                  String pathGambar = item['path_gambar'] ?? '';
                  String harga = NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(int.parse(item['harga']));
                  String jumlah = item['jumlah'] ?? '1';

                  // TEMPLATE CARD
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: AppColors.secondWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ]
                    ),

                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          
                          // GAMBAR PRODUK
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'http://10.0.2.2/${pathGambar}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // INFORMASI PRODUK
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // NAMA PRODUK
                                Text(
                                  nama,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),

                                // HARGA
                                SizedBox(height: 5),
                                Text(
                                  harga,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            )
                          ),

                          // TOMBOL + DAN -
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [

                                // TOMBOL -
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.secondWhite,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: () {
                                      int current = int.tryParse(jumlah) ?? 1;
                                      if (current > 1) {
                                        updateCartItem(int.parse(item['id_cart_item']), current - 1);
                                      } else {
                                        // JIKA JUMLAH = 1, TOMBOL - AKAN KIRIM 0, DAN BACKEND AKAN MENGHAPUS
                                        updateCartItem(int.parse(item['id_cart_item']), 0);
                                      }
                                    }, 
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.remove),
                                    )
                                  ),
                                ),

                                // ANGKA
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    jumlah,
                                    style: TextStyle(fontSize: 18),
                                  )
                                ),

                                // TOMBOL +
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.secondWhite,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      int current = int.tryParse(jumlah) ?? 1;
                                      updateCartItem(int.parse(item['id_cart_item']), current + 1);
                                    }, 
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              )
          ),

          // PANEL PEMBAYARAN
          // KALO KERANJANG KOSONG, GA MUNCUL
          Visibility(
            visible: !cartItems.isEmpty,
            child: Container(
              padding: EdgeInsets.all(20),
              height: 140,
              decoration: BoxDecoration(
                color: Color(0xFFF2EFEF),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Payment",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondBlack
                        ),
                      ),

                      // TOTAL HARGA
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(total),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondBlack,
                        ),
                      )
                    ],
                  ),

                  // TOMBOL CHECKOUT
                  SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => Checkout(
                            cartItems: [cartItems],
                            total: total,
                            idUser: int.parse(userId ?? '0'),
                          ))
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        ),
                        padding: EdgeInsets.all(17)
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.secondWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}