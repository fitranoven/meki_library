import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class ReturnScreen extends StatefulWidget {
  final int? loanId;

  const ReturnScreen({super.key, this.loanId});

  @override
  State<ReturnScreen> createState() => _ReturnScreenState();
}

class _ReturnScreenState extends State<ReturnScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _returnsFuture;

  @override
  void initState() {
    super.initState();
    _loadReturnableBooks();
  }

  void _loadReturnableBooks() {
    setState(() {
      _returnsFuture = apiService.getReturnableLoans();
    });
  }

  Future<void> _returnBook(int loanId) async {
    try {
      final result = await apiService.returnBook(loanId);
      if (!mounted) return;
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Buku berhasil dikembalikan'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigasi ke HomeScreen setelah sukses
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Gagal mengembalikan buku: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Pengembalian Buku'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang',
            onPressed: _loadReturnableBooks,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _returnsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada buku yang sedang dipinjam.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final loans = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: loans.length,
            itemBuilder: (context, index) {
              final loan = loans[index];
              final loanId = loan['id'];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18, horizontal: 20),
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[100],
                    child: const Icon(Icons.book, color: Colors.green, size: 28),
                    radius: 28,
                  ),
                  title: Text(
                    loan['book_title'] ?? 'Judul tidak tersedia',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${loan['status']}',
                            style: TextStyle(
                                color: Colors.blueGrey[700], fontSize: 14)),
                        if (loan['loan_date'] != null)
                          Text('Tanggal Pinjam: ${loan['loan_date']}',
                              style: TextStyle(
                                  color: Colors.blueGrey[500], fontSize: 13)),
                        if (loan['due_date'] != null)
                          Text('Jatuh Tempo: ${loan['due_date']}',
                              style: TextStyle(
                                  color: Colors.red[400], fontSize: 13)),
                      ],
                    ),
                  ),
                  trailing: ElevatedButton.icon(
                    onPressed: () => _returnBook(loanId),
                    icon: const Icon(Icons.keyboard_return, size: 20),
                    label: const Text("Kembalikan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
