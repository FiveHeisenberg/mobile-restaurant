import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projek_mobile/user/struk.dart';

class ManageOrder extends StatefulWidget {
  const ManageOrder({super.key});

  @override
  State<ManageOrder> createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  int _selectedIndex = 0;
  int? idUser;

  Future<void> loadUser() async {
    idUser = await getUser();
    setState(() {}); // agar rebuild setelah dapat idUser
  }
  
  // FUNGSI AMBI ID USER
  Future<int?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id_user');
  }

  // FUNGSI API AMBIL PESANAN ON PROSES
  Future<List<dynamic>> getProcess() async {
    if (idUser == null) {
      await getUser();
    }

    final url = Uri.parse('http://localhost/resto/get_order.php?status=On Proses&id_user=$idUser');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['orders'];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  // FUNGSI API AMBIL PESANAN DONE
  Future<List<dynamic>> getDone() async {
    if (idUser == null) {
      await getUser();
    }

    final url = Uri.parse('http://localhost/resto/get_order.php?status=Done&id_user=$idUser');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['orders'];
    } else {
      throw Exception("Gagal mengambil pesanan Selesai");
    }
  }

  // FUNGSI API AMBIL PESANAN SELESAI (TUNGGU KONFIRMASI)
  Future<List<dynamic>> getSelesai() async {
    if (idUser == null) {
      await getUser();
    }

    final url = Uri.parse('http://localhost/resto/get_order.php?status=Selesai&id_user=$idUser');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['orders'];
    } else {
      throw Exception('Gagal Mengambil Pesanan');
    }
  }

  // FUNGSI API KONFIRMASI ORDER
  Future<void> konfirmasi(int idPembelian) async {
    final url = Uri.parse(
      'http://localhost/resto/konfirmasi_order.php?id_pembelian=$idPembelian'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        print("Konfirmasi berhasil");
      } else {
        throw Exception('Gagal Konfirmasi Pesanan');
      }
    } else {
      throw Exception('gagal Menghubungi Server');
    }
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondWhite,

      appBar: AppBar(
        backgroundColor: AppColors.secondWhite,
        title: Text("Pesanan Anda"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
              (route) => false,
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),

      body: Column(
        children: [

          // TAB
          Container(
            color: AppColors.secondWhite,
            child: Row(
              children: [
                
                // TAB ON PROCESS
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 0
                                ? AppColors.primaryGreen
                                : Colors.grey,
                            width: _selectedIndex == 0 ? 2.5 : 1,
                          ),
                        ),
                      ),

                      child: Center(
                        child: Text(
                          "On Process",
                          style: TextStyle(
                            color: _selectedIndex == 0
                                ? AppColors.primaryGreen
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // TAB SELESAI
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedIndex == 1
                                ? AppColors.primaryGreen
                                : Colors.grey,
                            width: _selectedIndex == 1 ? 2.5 : 1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Selesai",
                          style: TextStyle(
                            color: _selectedIndex == 1
                                ? AppColors.primaryGreen
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // CARD PESANAN
          _selectedIndex == 0
          ? Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([
                getProcess(),
                getSelesai()
              ]),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                }

                final prosesOrders = snapshot.data![0];
                final selesaiOrders = snapshot.data![1];
                final allOrders = [...prosesOrders, ... selesaiOrders];

                if (allOrders.isEmpty) {
                  return Center(child: Text('Tidak ada pesanan'));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: allOrders.length,
                  itemBuilder: (context, index) {
                    final proses = allOrders[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey)
                      
                      ),
                      // ISI CARD
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // ID PESANAN DAN STATUS PESANAN
                            Row(
                              children: [

                                // ID PESANAN
                                Text(
                                  "ID Pesanan #${proses['id_pembelian']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Spacer(),

                                // STATUS PESANAN
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: proses['status'] == 'On Proses'
                                    ? Colors.grey[400]
                                    : AppColors.thirdGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "${proses['status']}",
                                    style: TextStyle(
                                      color: proses['status'] == 'On Proses'
                                      ? AppColors.secondBlack
                                      : AppColors.primaryGreen,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5),

                            // DETAIL PRODUK
                            Text(
                              proses['detail'] != null
                              ? proses['detail']
                                .map((item) => "${item['qty']} ${item['nama']}")
                                .join(", ")
                              : '-',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),

                            // GARIS PEMBATAS
                            Divider(),
                            SizedBox(height: 5),

                            // TOTAL HARGA DAN TOMBOL KONFIRMASI
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                    ),

                                    // TOTAL HARGA
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0
                                      ).format(proses['total_harga']),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),

                                // TOMBOL KONFIRMASI
                                proses['id_order_type'] == 3 && proses['status'] == 'On Proses'
                                ? ElevatedButton(
                                  onPressed: () {

                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    backgroundColor: AppColors.primaryGreen,
                                    foregroundColor: AppColors.secondWhite
                                  ), 
                                  child: Text('Lacak Pesanan'),
                                )
                                : ElevatedButton(
                                  onPressed: (proses['status']) == 'Selesai'
                                  ? () async {
                                    await konfirmasi(proses['id_pembelian']);

                                    showDialog(
                                      context: context, 
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Terima Kasih :)",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Text(
                                            "Selamat Menikmati :D",
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }
                                    );
                                    setState(() {
                                      
                                    });
                                  }
                                  : null,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    ),
                                    backgroundColor: AppColors.primaryGreen,
                                    foregroundColor: AppColors.secondWhite
                                  ), 
                                  child: Text('Konfirmasi'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          )
          : Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: getDone(), 
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(child: Text("Gagal memuat data"));
                }

                final orders = snapshot.data ?? [];

                if (orders.isEmpty) {
                  return Center(child: Text("Belum ada pesanan selesai"));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final done = orders[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey)
                      
                      ),

                      // ISI CARD
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // ID PESANAN DAN STATUS PESANAN
                            Row(
                              children: [

                                // ID PESANAN
                                Text(
                                  "ID Pesanan #${done['id_pembelian']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Spacer(),

                                // STATUS PESANAN
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.thirdGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Selesai",
                                    style: TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5),

                            // DETAIL PRODUK
                            Text(
                              done['detail'] != null
                              ? done['detail']
                                .map((item) => "${item['qty']} ${item['nama']}")
                                .join(", ")
                              : '-',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 5),

                            // GARIS PEMBATAS
                            Divider(),
                            SizedBox(height: 5),

                            // TOTAL HARGA DAN TOMBOL
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                    ),

                                    // TOTAL HARGA
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: 'Rp ',
                                        decimalDigits: 0
                                      ).format(done['total_harga']),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),

                                // TOMBOL DETAIL
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context, 
                                      MaterialPageRoute(builder: (context) => Struk(idPembelian: done['id_pembelian']))
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryGreen,
                                    foregroundColor: AppColors.secondWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                    )
                                  ), 
                                  child: Text('Detail'),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            ),
            
          ),
        ],
      ),
    );
  }
}
