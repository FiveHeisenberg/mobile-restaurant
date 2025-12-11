import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';

class ManageOrder extends StatefulWidget {
  const ManageOrder({super.key});

  @override
  State<ManageOrder> createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
  int _selectedIndex = 0;
  String _selectedFilter = 'Semua';
  String _selectedDate = 'Semua';

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
          ],

          // JIKA TAB SELESAI DITEKAN
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