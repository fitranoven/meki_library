import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  final String token;
  final int userId;

  const HistoryPage({super.key, required this.token, required this.userId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> loans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLoanHistory();
  }

  Future<void> fetchLoanHistory() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/getLoan/${widget.userId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        loans = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data riwayat'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Peminjaman"),
        backgroundColor: const Color(0xFF3A86FF),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : loans.isEmpty
              ? const Center(child: Text("Belum ada peminjaman."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: loans.length,
                  itemBuilder: (context, index) {
                    final loan = loans[index];
                    final bookTitle = loan['book']?['title'] ?? 'Judul tidak tersedia';
                    final date = loan['created_at']?.substring(0, 10) ?? 'Tanggal tidak diketahui';

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(Icons.history, color: Colors.orange),
                        title: Text(bookTitle),
                        subtitle: Text("Tanggal pinjam: $date"),
                      ),
                    );
                  },
                ),
    );
  }
}
