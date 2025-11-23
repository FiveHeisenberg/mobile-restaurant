import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cslider;
import 'package:projek_mobile/dashboard/dashboard.dart';
import 'package:projek_mobile/login/SignIn.dart';
import 'package:projek_mobile/menu/menu.dart';
import 'package:projek_mobile/var.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

// TEMPLATE WARNA
class AppColors {
  static const Color primaryGreen = Color(0xFF4AA433);
  static const Color secondBlack = Color(0xFF000000);
  static const Color secondWhite = Color(0xFFFFFFFF);
  static const Color thirdGreen = Color(0xFFDBEDD6);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String query = '';
  String displayedUsername = username;

  // FUNGSI AMBIL USERNAME DARI API
  Future<void> fetchUsername() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost/login.php"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            displayedUsername = data['username'];
          });
        }
      }
    } catch (e) {
      print("Error");
    }
  }
  
  @override
  void initState() {
    super.initState();
    fetchUsername();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondWhite,

      appBar: AppBar(
        backgroundColor: AppColors.secondWhite,
        title: Text(
          isLogin ?
          "Halo, $displayedUsername":"Selamat Datang",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        // TOMBOL LOGIN
        actions: [
          if (isLogin == false)
            Padding(
              padding: EdgeInsetsGeometry.only(right: 10),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );

                  if(result == true) {
                    setState(() {
                      isLogin = true;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                child: Text(
                  "LOGIN",
                  style: TextStyle(color: AppColors.secondWhite),
                )
              ),
            )
        ],
      ),

      // DRAWER
      endDrawer: isLogin ?
      Drawer(
        backgroundColor: AppColors.secondWhite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 150),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 5),
                child: ListTile(
                  title: Text(
                    "Profiles",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.primaryGreen,
                  textColor: AppColors.secondWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {

                  },
                ),
              ),
              Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Keranjang",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.primaryGreen,
                  textColor: AppColors.secondWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {

                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.primaryGreen,
                  textColor: AppColors.secondWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {

                  },
                ),
              ),

              username == "admin" 
              ? Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Dashboard",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.primaryGreen,
                  textColor: AppColors.secondWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => Dashboard())
                    );
                  },
                ),
              ) : SizedBox.shrink(), // < --- WIDGET KOSONG

              SizedBox(height: 200),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.primaryGreen,
                  textColor: AppColors.secondWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {
                    setState(() {
                      isLogin = false;
                      username = '';
                    });
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => MyHomePage()), 
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ) : null,

      body: ListView(
        children: [

          // SEARCH BAR
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(15, 15, 15, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Nasi Goreng . . .',
                hintStyle: TextStyle(color: AppColors.secondBlack),
                prefixIcon: Icon(Icons.search),                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50)
                ),
                filled: true,
                fillColor: AppColors.thirdGreen,
              ),
            ),
          ),

          // SLIDES BANNER PROMO
          cslider.CarouselSlider(
            items: [
              Image.asset("img/banner1.png", fit: BoxFit.contain),
              Image.asset("img/banner2.png", fit: BoxFit.contain),
              Image.asset("img/banner3.png", fit: BoxFit.contain),
            ], 
            options: cslider.CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              aspectRatio: 16/9,
              autoPlayInterval: Duration(seconds: 3),              
            )
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 5, 20),
            child: Text(
              "Mau Pesan Apa Hari Ini?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // TOMBOL MENU MAKANAN
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Menu(idKategori: 1))
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10)
                  )
                ),
                child: Text(
                  "Makanan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondWhite,
                  ),
                )
              ),

              // TOMBOL MENU MINUMAN
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Menu(idKategori: 2))
                  );
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10)
                  ),
                ),
                child: Text(
                  "Minuman",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondWhite,
                  ),
                )
              ),
            ],
          ),

          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 5, 10),
            child: Text(
              "Promo Terbaru Dari Kami",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),
            ),
          ),

          // GAMBAR PROMO - PROMO
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 5),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(10),
                    child: Image.asset(
                      "img/promo1.png"
                    ),
                  )
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(20, 5, 5, 10),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Image.asset(
                            "img/promo0.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(5, 5, 20, 10),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Image.asset(
                            "img/promo2.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    )
                  ],
                )
              ],
            )
          ),

          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isLogin == false) {
                  isLogin = true;
                } else {
                  isLogin = false;
                }
              });
            }, 
            child: Text("RESET")
          ),
        ],
      ),
    );
  }
}