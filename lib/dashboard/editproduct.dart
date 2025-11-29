import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';

class Editproduct extends StatefulWidget {
  const Editproduct({super.key});

  @override
  State<Editproduct> createState() => _EditproductState();
}

class _EditproductState extends State<Editproduct> {
  String selectedKategori = "Makanan";

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
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEDEDED),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey.shade300
                ),
              ),
              child: Column(
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
              onPressed: () {

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
              onPressed: () {

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