import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Addproduct extends StatefulWidget {
  const Addproduct({super.key});

  @override
  State<Addproduct> createState() => _AddproductState();
}

class _AddproductState extends State<Addproduct> {
  String selectedKategori = "Makanan";
  TextEditingController nama = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController deskripsi = TextEditingController();

  File? pickedImage;
  final picker = ImagePicker();

  // FUNGSI PILIH GAMBAR
  Future pickImage() async {
    final result = await picker.pickImage(source: ImageSource.gallery);

    if (result!= null) {
      setState(() {
        pickedImage = File(result.path);
      });
    }
  }

  // FUNGSI API TAMBAH PRODUK
  Future<bool> tambahProduk() async {
    var url = Uri.parse("http://localhost/resto/add_produk.php");

    var request = http.MultipartRequest("POST", url);

    request.fields['nama_produk'] = nama.text;
    request.fields['harga'] = harga.text;
    request.fields['kategori'] = selectedKategori;
    request.fields['deskripsi'] = deskripsi.text;

    // UPLOAD GAMBAR
    request.files.add(
      await http.MultipartFile.fromPath(
        'gambar', 
        pickedImage!.path
      ),
    );

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    return response.statusCode == 200 && responseBody.contains('"success":true');
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
          "Tambah Produk",
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
                ),
                child: pickedImage == null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 60,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Tap untuk memilih gambar",
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    pickedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
              ),
            ),

            // NAMA PRODUK
            SizedBox(height: 25),
            TextField(
              controller: nama,
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
              controller: harga,
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
              controller: deskripsi,
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

                // NOTIFIKASI JIKA GAMBAR BELUM DIINPUT
                if (pickedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gambar harus dipiih!"))
                  );
                  return;
                }

                // VALIDASI FORM NAMA DAN HARGA HARUS DIISI
                if (nama.text.isEmpty || harga.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Nama dan Harga wajib diisi!")),
                  );
                  return;
                }

                showDialog(
                  context: context, 
                  barrierDismissible: false,
                  builder: (context) => Center(child: CircularProgressIndicator()),
                );

                bool success = await tambahProduk();
                Navigator.pop(context);

                // JIKA BERHASIL, KEMBALI KE HALAMAN MANAGE PRODUK
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Produk berhasil ditambahkan"))
                  );
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menambahkan produk"))
                  );
                }
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
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
            )
          ],
        ),
      ),
    );
  }
}