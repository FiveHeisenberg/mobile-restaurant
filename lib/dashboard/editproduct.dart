import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Editproduct extends StatefulWidget {
  final Map produk;

  Editproduct({required this.produk});

  @override
  State<Editproduct> createState() => _EditproductState();
}

class _EditproductState extends State<Editproduct> {

  late TextEditingController nama;
  late TextEditingController harga;
  late TextEditingController deskripsi;
  late String selectedKategori;
  File? pickedImage;

  // FUNGSI PILIH GAMBAR
  Future pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        pickedImage = File(img.path);
      });
    }
  }

  // FUNGSI API UNTUK UPDATE PRODUK
  Future<bool> updateProduk() async {
    final uri = Uri.parse("http://localhost/resto/update_produk.php");

    var request = http.MultipartRequest("POST", uri);

    request.fields['id_produk'] = widget.produk['id_produk'].toString();
    request.fields['nama_produk'] = nama.text;
    request.fields['harga'] = harga.text;
    request.fields['deskripsi'] = deskripsi.text;
    request.fields['kategori'] = selectedKategori;

    if (pickedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'gambar', 
          pickedImage!.path
        ),
      );
    }

    var response = await request.send();
    var res = await response.stream.bytesToString();
    final data = jsonDecode(res);

    return data['success'] == true;
  }

  // FUNGSI API UNTUK HAPUS PRODUK
  Future<bool> hapusProduk() async {
    final response = await http.post(
      Uri.parse("http://localhost/resto/delete_produk.php"),
      body: {"id_produk": widget.produk['id_produk'].toString()},
    );

    final data = jsonDecode(response.body);
    return data['success'] == true;
  }

  @override
  void initState() {
    super.initState();

    nama = TextEditingController(text: widget.produk['nama_produk']);
    harga = TextEditingController(text: widget.produk['harga'].toString());
    deskripsi = TextEditingController(text: widget.produk['deskripsi']);
    selectedKategori = widget.produk['kategori'] ?? "Makanan";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondWhite,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.secondBlack,
        title: Text(
          "Edit Produk",
          style: TextStyle(
            color: AppColors.secondBlack
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // GAMBAR UPLOAD
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFEDEDED),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey.shade300
                  ),
                  image: pickedImage == null
                  ? DecorationImage(
                    image: NetworkImage(
                      "http://localhost${widget.produk['path_gambar']}"
                    ),
                    fit: BoxFit.cover,
                  )
                  : DecorationImage(
                    image: FileImage(pickedImage!),
                    fit: BoxFit.cover,
                  )
                ),
                child: pickedImage == null
                ? null
                : null,
              ),
            ),

            // NAMA PRODUK
            SizedBox(height: 25),
            TextField(
              decoration: InputDecoration(
                labelText: "Nama Produk",
                filled: true,
                fillColor: AppColors.secondWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                )
              ),
            ),

            // HARGA
            SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Harga",
                filled: true,
                fillColor: AppColors.secondWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)
                )
              ),
            ),

            // KATEGORI (DROPDOWN)
            SizedBox(height: 20),
            DropdownButtonFormField(
              value: selectedKategori,
              decoration: InputDecoration(
                labelText: "Kategori",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              items: ['Makanan', 'Minuman']
              .map((kategori) => DropdownMenuItem(
                value: kategori,
                child: Text(kategori),
                )) .toList(),
              onChanged: (value) {
                setState(() {
                  selectedKategori = value!;
                });
              }
            ),

            // DESKRIPSI
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
              maxLines: 4,
            ),

            // TOMBOL SIMPAN
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await updateProduk();

                if (success) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal update produk")),
                  );
                }
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 50)
              ),
              child: Text(
                "Simpan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondWhite,
                ),
              )
            ),

            // TOMBOL HAPUS
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                bool deleted = await hapusProduk();

                if (deleted) {
                  Navigator.pop(context, true);
                }
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              ),
              child: Text(
                "Hapus",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondWhite,
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}