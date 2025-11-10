import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:projek_mobile/var.dart';
import 'package:projek_mobile/login/Signin.dart';

void main() {
  runApp(const Menu());
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Makan Apa Hari ini, <User>?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
      ),

      endDrawer: Drawer(
        backgroundColor: AppColors.primaryGreen,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 200),

              if (islogin)
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 20, 20, 5),
                child: ListTile(
                  title: Text(
                    "Profiles",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {

                  },
                ),
              ),

              if (islogin)
              Padding(
                  padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Keranjang",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {

                  },
                ),
              ),

              if(islogin)
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Settings",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {

                  },
                ),
              ),
              
              if (islogin)
              SizedBox(height: 250),
              islogin ? 
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
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
              ) : 
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(20, 5, 20, 5),
                child: ListTile(
                  title: Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  tileColor: AppColors.secondWhite,
                  textColor: AppColors.secondBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(12)
                  ),
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => LoginPage())
                    );
                  },
                ),
              )              
            ],
          ),
        ),
      ),

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

        ],
      ),
    );
  }
}