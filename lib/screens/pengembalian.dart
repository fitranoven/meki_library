import 'package:flutter/material.dart';

class PengembalianPage extends StatefulWidget {
  const PengembalianPage({super.key});

  @override
  State<PengembalianPage> createState() => _PengembalianPageState();
}

class _PengembalianPageState extends State<PengembalianPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController judulBukuController = TextEditingController();
  final TextEditingController tanggalKembaliController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final nama = namaController.text;
      final judulBuku = judulBukuController.text;
      final tanggalKembali = tanggalKembaliController.text;

      // Simpan atau kirim data ke backend di sini
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pengembalian berhasil oleh $nama')),
      );

      // Reset form
      namaController.clear();
      judulBukuController.clear();
      tanggalKembaliController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pengembalian Buku'),
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
                controller: tanggalKembaliController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pengembalian (yyyy-mm-dd)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal pengembalian wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Kembalikan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
