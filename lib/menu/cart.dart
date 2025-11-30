import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Future<List<dynamic>> _futureCart;

  @override
  void initState() {
    super.initState();
    _futureCart = fetchCart();
  }

  Future<List<dynamic>> fetchCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUser = prefs.getInt("id_user");

    if (idUser == null) return [];

    final url = Uri.parse("http://localhost/resto/get_cart.php");

    final response = await http.post(url, body: {
      "id_user": idUser.toString(),
    });

    var data = jsonDecode(response.body);

    if (data['success'] == true) {
      return data['cart']; // list item keranjang
    }

    return [];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondWhite,
        title: Text("Keranjang"),
      ),
      body: FutureBuilder(
        future: _futureCart,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!;

          if (cartItems.isEmpty) {
            return Center(child: Text("Keranjang kosong"));
          }

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];

              return ListTile(
                leading: Image.network(
                  "http://localhost${item['path_gambar']}",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(item['nama_produk']),
                subtitle: Text("Rp. ${item['harga']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Tambah/Kurang
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // kamu bisa lanjut implementasikan di sini
                      },
                    ),
                    Text(item['jumlah'].toString()),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        // kamu bisa lanjut implementasikan di sini
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}