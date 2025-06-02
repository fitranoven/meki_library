import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Kata Sandi")),
      body: Center(
        child: Text("Halaman Lupa Password (lanjutkan dengan koneksi ke Laravel)"),
      ),
    );
  }
}
