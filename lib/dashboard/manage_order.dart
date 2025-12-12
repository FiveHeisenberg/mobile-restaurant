import 'dart:convert';
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
  String _selectedFilter = 'Semua';
  String _selectedDate = 'Semua';

  // FUNGSI API AMBIL DATA PESANAN ON PROCES
  Future<List<dynamic>> getOrders(String filter) async {
    String url = 'http://localhost/resto/get_orderforadmin.php?filter=$filter';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('MASALAH KONEKSI');
    }
  }

  // FUNGSI FORMAT TANGGAL
  String formatTanggal(String tanggal) {
    DateTime dt = DateTime.parse(tanggal);
    return DateFormat('dd-MM-yyyy, HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondWhite,
      appBar: AppBar(
         backgroundColor: AppColors.secondWhite,
         title: Text("Manajemen Pesanan"),
      ),

      body: Column(
        children: [

          // TAB
          Container(
            color: AppColors.secondWhite,
            child: Row(
              children: [

                // TAB ON PROCES
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
                          )
                        )
                      ),

                      child: Center(
                        child: Text(
                          'On Process',
                          style: TextStyle(
                            color: _selectedIndex == 0
                            ? AppColors.primaryGreen
                            : Colors.grey
                          ),
                        ),
                      ),
                    ),
                  )
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
                          )
                        )
                      ),
                      child: Center(
                        child: Text(
                          'Selesai',
                          style: TextStyle(
                            color: _selectedIndex == 1
                            ? AppColors.primaryGreen
                            : Colors.grey
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // KOLOM PENCARIAN
          Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ID Pesanan . . .',
                hintStyle: TextStyle(color: AppColors.secondBlack),
                prefixIcon: Icon(Icons.search),                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50)
                ),
                filled: true,
                fillColor: AppColors.thirdGreen,
              ),
            ),
          ),

          // JIKA TAB ON PROCESS DITEKAN
          if (_selectedIndex == 0) ...[

            // TOMBOL - TOMBOL FILTER
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'Semua';
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'Semua'
                        ? AppColors.primaryGreen
                        : Colors.grey,
                        foregroundColor: AppColors.secondWhite
                      ),
                      child: Text('Semua')
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'Dine In';
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'Dine In'
                        ? AppColors.primaryGreen
                        : Colors.grey,
                        foregroundColor: AppColors.secondWhite
                      ),
                      child: Text('Dine In')
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'Takeaway';
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'Takeaway'
                        ? AppColors.primaryGreen
                        : Colors.grey,
                        foregroundColor: AppColors.secondWhite
                      ),
                      child: Text('Takeaway')
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFilter = 'Delivery';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedFilter == 'Delivery'
                        ? AppColors.primaryGreen
                        : Colors.grey,
                        foregroundColor: AppColors.secondWhite
                      ), 
                      child: Text('Delivery')
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // DAFTAR PESANAN
            Expanded(
              child: FutureBuilder(
                future: getOrders(_selectedFilter), 
                builder:(context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
              
                  if (snapshot.hasError) {
                    return Center(child: Text('TERJADI KESALAHAN'));
                  }
              
                  if (!snapshot.hasData) {
                    return Center(child: Text('TIDAK ADA DATA'));
                  }
              
                  if (snapshot.data!.isEmpty) {
                    return Center(child: Text('TIDAK ADA PESANAN'));
                  }
              
                  final orders = snapshot.data!;
              
                  return ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
              
                      // TEMPLATE CARD
                      return Card(
                        margin: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        // ID PESANAN
                                        Text(
                                          'ID Pesanan ${order['id_pembelian']}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16
                                          ),
                                        ),
                                        SizedBox(height: 3),

                                        // TANGGAL PESANAN
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 14,
                                              color: AppColors.primaryGreen,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              formatTanggal(order['tanggal']),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ),

                                  Column(
                                    children: [

                                      // TOTAL HARGA
                                      Text(
                                        NumberFormat.currency(
                                          locale: 'id_ID',
                                          symbol: 'Rp ',
                                          decimalDigits: 0
                                        ).format(order['total_harga']),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15
                                        ),
                                      ),
                                      SizedBox(height: 5),

                                      // TIPE ORDER
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: AppColors.thirdGreen,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          order['order_type'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primaryGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // NAMA CUSTOMER
                              SizedBox(height: 5),
                              Text(order['customer']),

                              // DAFTAR PRODUK YANG DIPESAN
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5)
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: order['products'].map<Widget>((item) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(item['nama_produk']),
                                        SizedBox(height: 5),
                                        Text("x ${item['jumlah']}")
                                      ],
                                    );
                                  }).toList()
                                ),
                              ),

                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(builder: (context) => Struk(idPembelian: order['id_pembelian']))
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadiusGeometry.circular(5)
                                        ),
                                        foregroundColor: AppColors.secondWhite,
                                      ), 
                                      child: Text('Detail')
                                    )
                                  ),

                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          
                                        });
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryGreen,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadiusGeometry.circular(5)
                                        ),
                                        foregroundColor: AppColors.secondWhite,
                                        
                                      ), 
                                      child: Text("Selesai")
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],

          // JIKA TAB 'SELESAI' DITEKAN
          if (_selectedIndex == 1) ...[

            // TOMBOL - TOMBOL FILTER
            Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = 'Semua';
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedDate == 'Semua'
                        ? AppColors.primaryGreen
                        : Colors.grey,
                        foregroundColor: AppColors.secondWhite
                      ),
                      child: Text('Semua')
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = 'Hari Ini';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedDate == 'Hari Ini'
                        ? AppColors.primaryGreen
                        : Colors.grey,
                        foregroundColor: AppColors.secondWhite
                      ), 
                      child: Text('Hari Ini')
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDate = "Kemarin";
                        });
                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedDate == 'Kemarin'
                        ? AppColors.primaryGreen
                        : Colors.grey,
                        foregroundColor: AppColors.secondWhite
                      ),
                      child: Text('Kemarin')
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}