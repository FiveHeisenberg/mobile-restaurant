import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:projek_mobile/var.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const Userpage(id: 1,));
}

class Userpage extends StatefulWidget {
  final int? id;

  const Userpage({super.key, required this.id});

  @override
  State<Userpage> createState() => _UserpageState();
}

class _UserpageState extends State<Userpage> {
  TextEditingController _namaController = TextEditingController();
  TextEditingController _hpController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordBaruController = TextEditingController();
  TextEditingController _konfirmasiPasswordController = TextEditingController();

  bool _obscurePasswordBaru = true;
  bool _obscureKonfirmasiPassword = true;

  Map<String, dynamic>? userData;
  
  // FUNGSI API AMBIL DATA USER
  Future<Map<String, dynamic>?> getUserData(int id) async {
    final response = await http.get(
      Uri.parse('$urlAPI/get_user.php?id=$id')
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data['status'] == true) {
        return data['data'];
      }
    }
    return null;
  }

  // FUNGSI MEMUAT DATA USER
  Future<void> loadUser() async {
    if (widget.id == null) return;

    final data = await getUserData(widget.id!);
    if (data == null) return;

    setState(() {
      userData = data;

      _namaController.text = data['nama_lengkap'] ?? '';
      _hpController.text = data['no_hp'] ?? '';
      _emailController.text = data['email'] ?? '';
      _usernameController.text = data['username'] ?? '';
    });
  }

  // FUNGSI API UPDATE USER
  Future<void> updateUser() async {
    if (widget.id == null) return;

    // validasi password
    if (_passwordBaruController.text.isNotEmpty &&
        _passwordBaruController.text != _konfirmasiPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password tidak sama")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('$urlAPI/update_user.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": widget.id,
        "username": _usernameController.text,
        "nama_lengkap": _namaController.text,
        "no_hp": _hpController.text,
        "email": _emailController.text,
        "password": _passwordBaruController.text.isEmpty
            ? null
            : _passwordBaruController.text,
      }),
    );

    final data = jsonDecode(response.body);

    if (data['status'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profil berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? "Gagal update")),
      );
    }
  }



  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      loadUser();
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordBaruController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final user = userData;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Profile"),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10
                ),
                minimumSize: Size(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)
                )
              ),
              onPressed: () {
                updateUser();
              }, 
              child: Text(
                'Simpan',
                style: TextStyle(color: AppColors.secondWhite, fontWeight: FontWeight.bold),
              )
            ),
          )
        ],
      ),
      body: user == null
      ? Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // BAGIAN PROFIL
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // NAMA LENGKAP
                Text(
                  'Nama Lengkap',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700]
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[200]!)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!)
                    ),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400]),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    constraints: BoxConstraints(maxHeight: 50)
                  ),
                ),

                // NO HP
                SizedBox(height: 16),
                Text(
                  'No HP',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700]
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _hpController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[200]!)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!)
                    ),
                    prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey[400]),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    constraints: BoxConstraints(maxHeight: 50)
                  ),
                ),

                // EMAIL
                SizedBox(height: 16),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700]
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[200]!)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!)
                    ),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[400]),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    constraints: BoxConstraints(maxHeight: 50)
                  ),
                ),
                
                // BAGIAN KEAMANAN AKUN
                SizedBox(height: 32),
                Row(
                  children: [
                    Icon(
                      Icons.shield_sharp,
                      color: Color(0xFF4CAF50),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Keamanan Akun',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),

                // USERNAME
                Text(
                  'Username *',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700]
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondWhite,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[200]!)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!)
                    ),
                    prefixIcon: Icon(Icons.alternate_email_sharp, color: Colors.grey[400]),
                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    constraints: BoxConstraints(maxHeight: 50)
                  ),
                ),

                // ATUR PASSWORD
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // PASSWORD BARU
                    Text(
                      'Password Baru',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _passwordBaruController,
                      obscureText: _obscurePasswordBaru,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.secondWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!)
                        ),
                        prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey[400]),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePasswordBaru = !_obscurePasswordBaru;
                            });
                          }, 
                          icon: Icon(
                            _obscurePasswordBaru
                              ? Icons.visibility_off
                              : Icons.visibility
                          )
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        constraints: BoxConstraints(maxHeight: 50)
                      ),
                    ),

                    // KONFIRMASI PASSWORD
                    SizedBox(height: 16),
                    Text(
                      'Password Baru',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _konfirmasiPasswordController,
                      obscureText: _obscureKonfirmasiPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.secondWhite,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[200]!)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!)
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!)
                        ),
                        prefixIcon: Icon(Icons.lock_outlined, color: Colors.grey[400]),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureKonfirmasiPassword = !_obscureKonfirmasiPassword;
                            });
                          }, 
                          icon: Icon(
                            _obscureKonfirmasiPassword
                            ? Icons.visibility_off
                            : Icons.visibility
                          )
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        constraints: BoxConstraints(maxHeight: 50)
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      )
    );
  }
}