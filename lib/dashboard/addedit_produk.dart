import 'package:flutter/material.dart';
import 'package:projek_mobile/main.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class AddEditProductPage extends StatefulWidget {
  final Map? produk; // null = tambah produk, ada isi = edit produk
  const AddEditProductPage({super.key, this.produk});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController namaController;
  late TextEditingController hargaController;
  late TextEditingController deskripsiController;
  String selectedKategori = "Makanan";
  bool isLoading = false;

  // FUNGSI MENGIRIM DATA KE API
  Future<void> saveProduk() async {
    // Tampilkan Loading
    setState(() {
      isLoading = true;
    });

    try {
      final url = widget.produk == null
      ? "http://localhost/resto/add_produk.php" // MODE TAMBAH PRODUK
      : "http://localhost/resto/update_produk.php"; // MODE EDIT PRODUK

      // SISIPKAN DATA YANG AKAN DIKIRIM
      Map<String, String> body = {
        "nama_produk": namaController.text,
        "harga": hargaController.text,
        "deskripsi": deskripsiController.text,
        "Kategori": selectedKategori,
      };

      // JIKA MODE EDIT, TAMBAHKAN id_produk
      if (widget.produk != null) {
        body['id_produk'] = widget.produk!['id_produk'].toString();
      }

      // KIRIM REQUEST KE API
      final response = await http.post(
        Uri.parse(url),
        body : body,
      );

      // CEK RESPONSE DARI SERVER
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        // MENAMPILKAN NOTIFIKASI SUKSES
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.produk == null
                ? "Produk berhasil ditambahkan"
                : "Produk berhasil di update"),
              backgroundColor: AppColors.primaryGreen,
            )
          );
          // KEMBALI KE HALAMAN SEBELUMNYA DENGAN RESULT = TRUE
          Navigator.pop(context, true);
        } else {
          throw Exception(result['message']);
        }
      } else {
        throw Exception("Server error");
      }
    } catch (e) {
      // TAMPILKAN ERROR
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan produk: $e"),
          backgroundColor: Colors.red,
        )
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // ISI CONTROLLER DENGAN DATA DIMUNCULKAN (EDIT) ATAU KOSONG (TAMBAH)
    namaController = TextEditingController(
      text: widget.produk?['nama_produk'] ?? '',
    );
    hargaController = TextEditingController(
      text: widget.produk?['harga']?.toString() ?? '',
    );
    deskripsiController = TextEditingController(
      text: widget.produk?['deskripsi'] ?? '',
    );

    if (widget.produk != null) {
      selectedKategori = widget.produk!['nama_kategori'] ?? 'Makanan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.produk == null ? "Tambah Produk" : "Edit Produk",
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // NAMA PRODUK
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama produk harus diisi";
                  }
                  return null;
                },
              ),

              // HARGA
              SizedBox(height: 15),
              TextFormField(
                controller: hargaController,
                decoration: InputDecoration(
                  labelText: "Harga",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixText: "Rp ",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Harga harus diisi";
                  }
                  if (int.tryParse(value) == null) {
                    return "Harga harus berupa angka";
                  }
                  return null;
                },
              ),

              // KATEGORI
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: selectedKategori,
                decoration: InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: ['Makanan', 'Minuman']
                .map((kategori) => DropdownMenuItem(
                  value: kategori,
                  child: Text(kategori)
                ))
                .toList(), 
                onChanged: (value) {
                  setState(() {
                    selectedKategori = value!;
                  });
                }
              ),

              // DESKRIPSI
              SizedBox(height: 15),
              TextFormField(
                controller: deskripsiController,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Deskripsi harus diisi";
                  }
                  return null;
                },
              ),

              // TOMBOL SIMPAN
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: isLoading ? null : saveProduk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                child: isLoading
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondWhite
                  ),
                )
              )
            ],
          )
        ),
      ),
    );
  }
}