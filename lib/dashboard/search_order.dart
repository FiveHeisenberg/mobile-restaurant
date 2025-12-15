import 'package:flutter/material.dart';
import 'package:projek_mobile/var.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:projek_mobile/user/struk.dart';

class SearchOrder extends StatefulWidget {
  final String keyword;

  const SearchOrder({super.key, required this.keyword});

  @override
  State<SearchOrder> createState() => _SearchOrderState();
}

class _SearchOrderState extends State<SearchOrder> {
  TextEditingController searchController = TextEditingController();
  bool isNavigate = false;

  // FUNGSI API UPDATE STATUS ORDER
  Future getStatusOrders(int id_pembelian) async {
    String url = '$urlAPI/update_statusorder.php?id_pembelian=$id_pembelian';
    final response = await http.get(
      Uri.parse(url)
    );
  }

  // FUNGSI API CARI PRODUK
  Future searchOrder(String keyword) async {
    String url = "$urlAPI/cari_pesanan.php?keyword=$keyword";
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

  // FUNGSI FORMAT TANGGAL
  String formatTanggal(String tanggal) {
    DateTime dt = DateTime.parse(tanggal);
    return DateFormat('dd-MM-yyyy, HH:mm').format(dt);
  }

  @override
  void initState() {
    super.initState();
    searchOrder(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(15, 40, 15, 0),
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
                          MaterialPageRoute(builder: (context) => SearchOrder(keyword: value))
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
              ],
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: searchOrder(widget.keyword), 
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
                  padding: EdgeInsets.all(15),
                  itemCount: search.length,
                  itemBuilder:(context, index) {
                    final hasil = search[index];

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
                                          'ID Pesanan #${hasil['id_pembelian']}',
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
                                              formatTanggal(hasil['tanggal']),
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
                                        ).format(hasil['total_harga']),
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
                                          hasil['order_type'],
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
                              Text(hasil['customer']),

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
                                  children: hasil['products'].map<Widget>((item) {
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

                              // TOMBOL
                              if (hasil['status'] == "On Proses" ) ...[
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(builder: (context) => Struk(idPembelian: hasil['id_pembelian']))
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
                                          getStatusOrders(hasil['id_pembelian']);
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
                              ] else ...[
                                SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context, 
                                          MaterialPageRoute(builder: (context) => Struk(idPembelian: hasil['id_pembelian']))
                                        );
                                      }, 
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.secondWhite,
                                        foregroundColor: AppColors.primaryGreen,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          side: BorderSide(
                                            color: AppColors.primaryGreen,
                                            width: 1.5
                                          )
                                        )
                                      ),
                                      child: Text('Detail')
                                    ),
                                  ),
                                ],
                              )
                              ]
                            ],
                          ),
                        ),
                    );
                  },
                );
              },
            )
          )
        ],
      ),
    );
  }
}