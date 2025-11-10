import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cslider;
import 'package:projek_mobile/login/SignIn.dart';
import 'package:projek_mobile/menu/menu.dart';
import 'package:projek_mobile/var.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

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
  
  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.secondWhite,

      appBar: AppBar(
        backgroundColor: AppColors.secondWhite,
        title: Text(
          "Selamat Datang",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          if (islogin == false)
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
                      islogin = true;
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

      endDrawer: islogin ?
      Drawer(
        backgroundColor: AppColors.secondWhite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 200),
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 20, 20, 5),
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
                      islogin = false;
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Menu())
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

              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => Menu())
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
                if (islogin == false) {
                  islogin = true;
                } else {
                  islogin = false;
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

