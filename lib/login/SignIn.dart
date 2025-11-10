import 'package:flutter/material.dart';
import 'package:projek_mobile/login/SignUp.dart';
import 'package:projek_mobile/main.dart';
import 'package:projek_mobile/var.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const LoginPage());
}

class LoginPage extends StatefulWidget {  
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('http://localhost/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      })
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          islogin = true;
        });
        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => MyHomePage()),
          (Route<dynamic> Route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username atau Password Salah'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal Koneksi ke Server"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondWhite,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.secondWhite,
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(30, 100, 30, 30),
            child: Center(
              child: Text(
                "Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ),

          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(20, 20, 20, 5),
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelStyle: TextStyle(
                  color: AppColors.secondBlack
                ),
                prefixIcon: Icon(
                  Icons.person, 
                  color: AppColors.secondBlack
                ),
                labelText: 'Username',
                border: OutlineInputBorder(),
                fillColor: AppColors.thirdGreen,
                filled: true,
              ),
              controller: _usernameController,
            ),
          ),
          
          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(20, 20, 20, 5),
            child: TextFormField(
              obscureText: _obscureText,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelStyle: TextStyle(
                  color: AppColors.secondBlack
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: AppColors.secondBlack,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  }, 
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  color: AppColors.secondBlack,
                ),
                labelText: 'Password',
                border: OutlineInputBorder(),
                fillColor: AppColors.thirdGreen,
                filled: true,
              ),
              controller: _passwordController,
            ),
          ),

          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(20, 5, 0, 1),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => SignUp())
                  );
              },
              child: Text(
                "Belum Punya Akun?",
                style: TextStyle(
                  color: AppColors.secondBlack,
                  decoration: TextDecoration.underline
                ),
              ),
            )
          ),

          Padding(
            padding: EdgeInsetsGeometry.fromLTRB(50, 20, 50, 50),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  login();
                }, 
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: AppColors.secondWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20
                  )
                )
              )
            ),
          ),
        ],
      ),
    );
  }
}