import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
    final url = Uri.parse("http://localhost/resto/get_cart.php");

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

    final url = Uri.parse("http://localhost/resto/get_total.php");
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
            : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                String nama = item['nama_produk'] ?? 'Produk';
                String harga = NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(int.parse(item['harga']));
                String jumlah = item['jumlah'] ?? '1';

                // TEMPLATE CARD
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
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
                        Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
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
                                  fontSize: 16,
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {

                              }, 
                              icon: Icon(Icons.add),
                            ),
                            Text(jumlah),
                            IconButton(
                              onPressed: () {

                              }, 
                              icon: Icon(Icons.remove)
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            )
          ),

          // PANEL PEMBAYARAN
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Payment",
                      style: TextStyle(fontSize: 16),
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
                        fontWeight: FontWeight.bold
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

                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.secondBlack
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}