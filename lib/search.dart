import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';

class SearchPage extends StatefulWidget {
  final String keyword;

  const SearchPage({super.key, required this.keyword});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isNavigate = false;


  // FUNGSI API CAR PRODUK
  // Future<void> searchProduk(String keyword) {
    
  // }

  @override
  void initState() {
    super.initState();
    // searchProduk(widget.keyword);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
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
                          MaterialPageRoute(builder: (context) => SearchPage(keyword: value))
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
        ],
      ),
    );
  }
}