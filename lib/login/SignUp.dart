import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projek_mobile/var.dart';

void main() {
  runApp(const SignUp());
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  // FUNGSI API MEMBUAT AKUN
  Future<void> createAccount() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (username.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Semua field harus diisi!"))
      );
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password tidak cocok!"))
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("$urlAPI/register.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        })
      );

      if (response.statusCode == 200) {
        print(response.body);
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Akun Berhasil dibuat!"))
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Gagal Membuat akun"))
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server Error: ${response.statusCode}"))
        );
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e"))
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

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(30, 50, 30, 30),
              child: Center(
                child: Text(
                  "Create Your First Account",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
              )
            ),
        
            // INPUT USERNAME
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
            
            // INPUT PASSWORD
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
        
            // INPUT PASSWORD AGAIN
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
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  fillColor: AppColors.thirdGreen,
                  filled: true,
                ),
                controller: _confirmController,
              ),
            ),
        
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(20, 5, 0, 1),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Sudah Punya Akun?",
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
                  onPressed: createAccount, 
                  child: Text(
                    "Create Account",
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
      ),

    );
  }
}