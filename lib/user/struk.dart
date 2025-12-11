import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projek_mobile/main.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:http/http.dart' as http;

class Struk extends StatefulWidget {
  final int idPembelian;
  const Struk({super.key, required this.idPembelian});

  @override
  State<Struk> createState() => _StrukState();
}

class _StrukState extends State<Struk> {

  // FUNGSI API MENGAMBIL DATA STRUK
  Future<Map<String, dynamic>> getStruk(int idPembelian) async {
    final url = Uri.parse('http://localhost/resto/struk.php?id_pembelian=$idPembelian');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Gagal Load Data");
    }
  }

  @override
  void initState() {
    super.initState();
    getStruk(widget.idPembelian);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: Text(
          "Struk Pembelian",
          style: TextStyle(
            color: AppColors.secondWhite
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: Icon(Icons.arrow_back),
          color: AppColors.secondWhite,
        ),
      ),

      body: FutureBuilder(
        future: getStruk(widget.idPembelian), 
        builder:(context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final struk = snapshot.data!;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // HEADER TOKO
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [

                      // ICON
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.thirdGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.storefront,
                          color: AppColors.primaryGreen,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 5),

                      // TULISAN DIBAWAH ICON
                      Text(
                        'e-Restoran',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Jl. Medan - B.Aceh, Kota Lhokseumawe, Aceh',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey
                        ),
                      )
                    ],
                  ),
                ),

                // INFORMASI TRANSAKSI
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.thirdGreen,
                    borderRadius: BorderRadius.circular(12)
                  ),

                  child: Column(
                    children: [
                      _infoPayment('ID Pembelian', "${struk['id_pembelian']}"),
                      SizedBox(height: 10),
                      _infoPayment("Date", "${struk['tanggal']}"),
                      SizedBox(height: 10),
                      _infoPayment('Payment', '${struk['payment_type']}'),
                      SizedBox(height: 10),
                      _infoPayment('Ordey Type', "${struk['order_type']}"),
                      SizedBox(height: 10),
                      _infoPayment('Customer Name', '${struk['customer_name']}'),
                    ],
                  ),
                ),

                // TULISAN "RINGKASAN PESANAN"
                SizedBox(height: 24),
                Text(
                  'Ringkasan Pesanan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 16),

                // LOOP
                ...struk['items'].map<Widget>((item) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['nama_produk'],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${item['jumlah']}x',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey
                                ),
                              )
                            ],
                          ),
                        ),

                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp ',
                            decimalDigits: 0
                          ).format(item['subtotal'])
                        )
                      ],
                    ),
                  );
                }).toList(),

                // GARIS
                Padding(
                  padding: EdgeInsets.all(10),
                  child: DottedLine(
                    dashLength: 6,
                    dashGapLength: 4,
                    lineThickness: 1,
                    dashColor: Colors.grey,
                  ),
                ),

                // SUBTOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: TextStyle(fontSize: 15)),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0
                      ).format(struk['subtotal'])
                    )
                  ],
                ),

                // BIAYA ADMIN
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Biaya Admin", style: TextStyle(fontSize: 15),),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0,
                      ).format(struk['tax'])
                    )
                  ],
                ),

                // BIAYA ONGKIR (JIKA ADA)
                ...(
                  struk['order_type'] == 'Delivery'
                  ?[
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ongkos Kirim", style: TextStyle(fontSize: 15)),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp ',
                            decimalDigits: 0
                          ).format(2000)
                        )
                      ],
                    )
                  ] : []
                ),

                // TOTAL AKHIR PEMBAYARAN
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Grand Total', style: TextStyle(fontSize: 16),),
                    Text(
                      NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                        decimalDigits: 0
                      ).format(struk['grand_total']),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),

                // TOMBOL CETAK STRUK
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12)
                      )
                    ),
                    child: Text(
                      'Cetak Struk',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.secondWhite
                      ),
                    )
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoPayment(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
          ),
        )
      ],
    );
  }
}
