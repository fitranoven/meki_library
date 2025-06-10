import 'package:flutter/material.dart';

class PeminjamanPage extends StatefulWidget {
  const PeminjamanPage({super.key});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController judulBukuController = TextEditingController();
  final TextEditingController tanggalPinjamController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final nama = namaController.text;
      final judulBuku = judulBukuController.text;
      final tanggalPinjam = tanggalPinjamController.text;

      // Simpan atau kirim data ke backend di sini
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Peminjaman berhasil untuk $nama')),
      );

      // Reset form
      namaController.clear();
      judulBukuController.clear();
      tanggalPinjamController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Peminjaman Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Peminjam',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: judulBukuController,
                decoration: const InputDecoration(
                  labelText: 'Judul Buku',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Judul buku wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tanggalPinjamController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pinjam (yyyy-mm-dd)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal pinjam wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Pinjam'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
