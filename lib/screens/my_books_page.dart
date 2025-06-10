import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyBooksPage extends StatefulWidget {
  const MyBooksPage({super.key});

  @override
  State<MyBooksPage> createState() => _MyBooksPageState();
}

class _MyBooksPageState extends State<MyBooksPage> {
  List<dynamic> books = [];
  String token = '';
  int userId = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenString = prefs.getString('token') ?? '';
    final userString = prefs.getString('user') ?? '{}';
    final user = jsonDecode(userString);

    setState(() {
      token = tokenString;
      userId = user['id'] is int
          ? user['id']
          : int.tryParse(user['id'].toString()) ?? 0;
    });

    print('Token: $token');
    print('User ID: $userId');

    fetchBooks();
  }

  Future<void> fetchBooks() async {
    if (token.isEmpty) return;

    final url = 'http://127.0.0.1:8000/api/books'; // Ganti IP sesuai jaringanmu
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Status Code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      setState(() {
        books = decoded is List ? decoded : decoded['data'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat buku')),
      );
    }
  }

  Future<void> _pinjamBuku(int bookId) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/loan'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_id': userId, 'book_id': bookId}),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Buku berhasil dipinjam!')),
      );
      fetchBooks();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal meminjam buku')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Buku')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? const Center(child: Text('Tidak ada buku tersedia.'))
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(book['title'] ?? 'Tanpa Judul'),
                        subtitle: Text('Penulis: ${book['author'] ?? '-'}'),
                        trailing: ElevatedButton(
                          onPressed: () => _pinjamBuku(book['id']),
                          child: const Text('Pinjam'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
