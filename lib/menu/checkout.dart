import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:dotted_line/dotted_line.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  String selectedPayment = "Bayar Ditempat";
  String selectedOrder = "Takeaway";

  // FUNGSI UNTUK MENGUBAH METODE
  void _selectedMethod(String method){
    setState(() {
      selectedOrder = method;
    });
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("1x Mie Ayam", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Rp. 10.00,-')
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("2x Sate Ayam", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Rp. 20.00,-')
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("2x Teh Dingin", style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Rp. 10.00,-')
                    ],
                  ),
                  SizedBox(height: 8),
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
                      Text("Rp. 45.000")
                    ],
                  ),  
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Biaya Admin"),
                      Text("Rp. 2.000")
                    ],
                  ),  
                  SizedBox(height: 8),
                  selectedOrder == "Delivery"
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Biaya Pengiriman"),
                      Text("Rp. 3.000")
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
                      Text("Rp. 50.000", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
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
                  onPressed: () {

                  }, 
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