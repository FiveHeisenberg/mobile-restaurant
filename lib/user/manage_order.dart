import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';

class ManageOrder extends StatefulWidget {
  const ManageOrder({super.key});

  @override
  State<ManageOrder> createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  int _selectedIndex = 0;

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
          ?Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Card(
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
                            "ID Pesanan #12345",
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
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Proses",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 16),

                      // DETAIL PRODUK
                      Text(
                        '2 Nasi Goreng, 1 Sate Ayam, 2 Teh Dingin',
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
                                'Rp. 50.000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          Spacer(),

                          // TOMBOL KONFIRMASI
                          ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                              )
                            ), 
                            child: Text('Konfirmasi'),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          )
          : Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Card(
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
                            "ID Pesanan #12345",
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
                      SizedBox(height: 16),

                      // DETAIL PRODUK
                      Text(
                        '2 Nasi Goreng, 1 Sate Ayam, 2 Teh Dingin',
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
                                'Rp. 50.000',
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
              ),
            )
          ),
        ],
      ),
    );
  }
}
