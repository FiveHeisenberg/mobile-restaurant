import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projek_mobile/user/manage_order.dart';
import 'package:projek_mobile/var.dart';

class Checkout extends StatefulWidget {
  final List<dynamic> cartItems;
  final int total;
  final int idUser;
  const Checkout({super.key, required this.cartItems, required this.total, required this.idUser});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  final TextEditingController _alamatController = TextEditingController();
  String selectedPayment = "Bayar Ditempat";
  String selectedOrder = "Takeaway";
  int biayaAdmin = 2000;
  int biayaKirim = 0;

  // FUNGSI API CHECKOUT
  Future<void> checkoutOrder() async {
    try {
      final url = Uri.parse('$urlAPI/checkout.php');

      final totalPayment = widget.total + biayaAdmin + biayaKirim;

      List<Map<String, dynamic>> formattedcartItems = [];
      for (var item in widget.cartItems[0]) {
        formattedcartItems.add({
          'id_produk': item['id_produk'],
          'jumlah': int.parse(item['jumlah']?.toString() ?? '1') ?? 1,
          'harga': int.parse(item['harga']?.toString() ?? '0') ?? 0,
        });
      }

      final requestBody = {
        'id_user': widget.idUser,
        'cart_items': formattedcartItems,
        'total_harga': totalPayment,
        'order_type': selectedOrder,
        'payment_type': selectedPayment,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'success') {
        showDialog(
          context: context, 
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.primaryGreen,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text('Berhasil'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pesanan anda akan diproses'),
                SizedBox(height: 10),
                Text('ID Pembelian: ${responseData['id_pembelian']}'),
                Text('Total: ${NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(totalPayment)}')
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ManageOrder()),
                    (Route<dynamic> route) => false,
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: AppColors.secondWhite
                  ),
                ),
              )
            ],
          )
        );
      } else {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 30,
                ),
                SizedBox(width: 10),
                Text('Gagal'),
              ],
            ),
            content: Text(responseData['message'] ?? 'Terjadi Kesalahan'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                child: Text('OK')
              )
            ],
          )
        );
      }

    } catch (e) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 30,
              ),
              SizedBox(width: 10),
              Text('Error')
            ],
          ),
          content: Text('Tidak dapat terhubung ke server: $e'),
          actions: [
            TextButton(
              onPressed: () {

              }, 
              child: Text('OK'),
            ),
          ],
        )
      );
    }
  }

  // FUNGSI UNTUK MENGUBAH METODE
  void _selectedMethod(String method){
    setState(() {
      selectedOrder = method;

      if (selectedOrder == 'Delivery') {
        biayaKirim = 3000;
      } else {
        biayaKirim = 0;
      }
    });
  }

  @override
  void dispose() {
    _alamatController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondWhite,
      appBar: AppBar(
        title: Text("Checkout Payment"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
        
              // TOMBOL DINE IN, TAKEAWAY, DAN DELIVERY
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
        
                  // DINE IN
                  GestureDetector(
                    onTap: () => _selectedMethod("Dine In"),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedOrder == "Dine In"
                        ? AppColors.primaryGreen
                        : AppColors.secondWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryGreen)
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant, 
                            color: selectedOrder == "Dine In"
                            ? AppColors.secondWhite
                            : AppColors.primaryGreen,
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Dine In",
                            style: TextStyle(
                              color: selectedOrder == "Dine In"
                              ? AppColors.secondWhite
                              : AppColors.primaryGreen
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
        
                  // TAKEAWAY
                  GestureDetector(
                    onTap: () => _selectedMethod("Takeaway"),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedOrder == "Takeaway"
                        ? AppColors.primaryGreen
                        : AppColors.secondWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryGreen)
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_dining, 
                            color: selectedOrder == "Takeaway"
                              ? AppColors.secondWhite
                              : AppColors.primaryGreen
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Takeaway",
                            style: TextStyle(
                              color: selectedOrder == "Takeaway"
                              ? AppColors.secondWhite
                              : AppColors.primaryGreen
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
        
                  // DELIVERY
                  GestureDetector(
                    onTap: () => _selectedMethod("Delivery"),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selectedOrder == "Delivery"
                          ? AppColors.primaryGreen
                          : AppColors.secondWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryGreen)
                      ),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Icon(
                            Icons.motorcycle, 
                            color: selectedOrder == "Delivery"
                              ? AppColors.secondWhite
                              : AppColors.primaryGreen
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Delivery",
                            style: TextStyle(
                              color: selectedOrder == "Delivery"
                              ? AppColors.secondWhite
                              : AppColors.primaryGreen
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            // "RINGKASAN PESANAN"
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ringkasan Pesanan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
        
            // BOX RINGKASAN PESANAN
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.secondWhite,
                boxShadow:[
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.grey,
                    offset: Offset(0, 2)
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.cartItems[0].map((item) {
                    String nama = item['nama_produk'] ?? 'Produk';
                    int jumlah = int.tryParse(item['jumlah']?.toString() ?? '1') ?? 1;
                    int harga = int.tryParse(item['harga']?.toString() ?? '0') ?? 0;
                    int totalhargaItem = jumlah * harga;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${jumlah}x $nama', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: 'Rp ',
                                decimalDigits: 0,
                              ).format(totalhargaItem)
                            )
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
        
            // "METODE PEMBAYARAN"
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Metode Pembayaran",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),
                ),
              ),
            ),
        
            // DROPDOWN METODE PEMBAYARAN
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  padding: EdgeInsets.all(10),
                  value: selectedPayment,
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  items: [
                    DropdownMenuItem(
                      value: "Bayar Ditempat",
                      child: Row(
                        children: [
                          Icon(Icons.wallet, color: AppColors.primaryGreen),
                          SizedBox(width: 12),
                          Text("Bayar Ditempat"),
                        ],
                      )
                    ),
                    DropdownMenuItem(
                      value: "Transfer Bank",
                      child: Row(
                        children: [
                          Icon(Icons.account_balance, color: AppColors.primaryGreen),
                          SizedBox(width: 12),
                          Text("Transfer Bank"),
                        ],
                      )
                    ),
                    DropdownMenuItem(
                      value: "E-Wallet",
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet, color: AppColors.primaryGreen),
                          SizedBox(width: 12),
                          Text("E-Wallet"),
                        ],
                      )
                    ),
                  ], 
                  onChanged: (value) {
                    setState(() {
                      selectedPayment = value!;
                    });
                  }
                )
              ),
            ),

            // INPUT ALAMAT (JIKA DELIVERY)
            SizedBox(height: 10),
            selectedOrder == 'Delivery'
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Alamat",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _alamatController,
                    decoration: InputDecoration(
                      hintText: "Masukkan Alamat . . .",
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.secondBlack
                      ),
                  
                      // ICON DI KIRI
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.location_on,
                          color: AppColors.primaryGreen,
                          size: 24,
                        ),
                      ),
                      
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey)
                      )
                    ),
                  ),
                ),
              ],
            )
            : SizedBox.shrink(),

            // GARIS
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(10),  
              child: DottedLine(
                dashLength: 6,
                dashGapLength: 4,
                lineThickness: 2,
                dashColor: Colors.grey,
              ),
            ),

            // RINCIAN BIAYA
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal"),
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(widget.total)
                      )
                    ],
                  ),  
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Biaya Admin"),
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(biayaAdmin)
                      )
                    ],
                  ),  
                  SizedBox(height: 8),
                  selectedOrder == "Delivery"
                  ? 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Biaya Pengiriman"),
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0,
                        ).format(biayaKirim)
                      )
                    ],
                  )
                  : SizedBox(),
                ],
              ),
            ),

            // GARIS
            Padding(
              padding: const EdgeInsets.all(10),
              child: DottedLine(
                dashLength: 6,
                dashGapLength: 4,
                lineThickness: 2,
                dashColor: Colors.grey,
              ),
            ),

            // TOTAL PAYMENT
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Payment", style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp ',
                          decimalDigits: 0
                        ).format(widget.total + biayaAdmin + biayaKirim),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),

            // TOMBOL CHECKOUT
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: checkoutOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.all(15)
                  ),
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.secondWhite
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
