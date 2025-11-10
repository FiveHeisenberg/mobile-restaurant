import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart'; // pastikan arah import sesuai dengan struktur proyekmu

bool isLogin = false;
String username = '';


void logout(BuildContext context) {
  isLogin = false;
  username = '';

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const MyHomePage()),
    (Route<dynamic> route) => false,
  );
}
