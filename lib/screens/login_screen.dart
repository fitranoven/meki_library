import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:library_frontend/services/api_service.dart';
import 'package:library_frontend/screens/home_screen.dart';
import 'package:library_frontend/screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  bool isLoading = false;
  bool isPasswordVisible = false;

  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Lebih cepat
    )..repeat(reverse: true);
    _iconAnimation = Tween<double>(begin: 0, end: 32).animate( // Lebih jauh
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  bool _isEmailValid(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password tidak boleh kosong')),
      );
      return;
    }
    if (!_isEmailValid(email)) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email tidak valid')),
      );
      return;
    }
    try {
      final result = await apiService.login(email: email, password: password);
      if (result['success']) {
        final token = result['data']['access_token'];
        final user = result['data']['user'];
        if (token != null && token.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('email', email);
          await prefs.setString('name', user['name']);
          await prefs.setString('phone', user['phone'] ?? '');
          await prefs.setString('photo_url', user['photo_url'] ?? '');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login berhasil!')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Token tidak valid')),
            );
          }
        }
      } else {
        final message = result['message'] ?? 'Login gagal';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isSmall = mq.size.width < 400;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Animated icon & title
          Positioned(
            top: isSmall ? 40 : 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _iconAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _iconAnimation.value),
                      child: child,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_stories_rounded,
                      size: isSmall ? 60 : 90,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: isSmall ? 12 : 24),
                Text(
                  'DIGITAL LIBRARY',
                  style: TextStyle(
                    fontSize: isSmall ? 22 : 34,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Glassmorphism login card
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmall ? 8 : 24,
                  vertical: isSmall ? 16 : 32,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double cardWidth = constraints.maxWidth;
                    if (cardWidth > 400) cardWidth = 400;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          width: cardWidth,
                          padding: EdgeInsets.all(isSmall ? 18 : 32),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Selamat Datang!',
                                style: TextStyle(
                                  fontSize: isSmall ? 16 : 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Masuk ke akun Digital Library Anda',
                                style: TextStyle(
                                  fontSize: isSmall ? 12 : 15,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                              SizedBox(height: isSmall ? 18 : 28),
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.08),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: isSmall ? 12 : 20,
                                    vertical: isSmall ? 12 : 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmall ? 12 : 18),
                              TextField(
                                controller: passwordController,
                                obscureText: !isPasswordVisible,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.08),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: isSmall ? 12 : 20,
                                    vertical: isSmall ? 12 : 16,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: isSmall ? 18 : 28),
                              isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : SizedBox(
                                      width: double.infinity,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF4E54C8), Color(0xFF8F94FB)],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: ElevatedButton(
                                          onPressed: _handleLogin,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            padding: EdgeInsets.symmetric(
                                              vertical: isSmall ? 12 : 16,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                          ),
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: isSmall ? 14 : 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(height: isSmall ? 12 : 18),
                              RichText(
                                text: TextSpan(
                                  text: 'Belum punya akun? ',
                                  style: TextStyle(color: Colors.white70, fontSize: isSmall ? 12 : 15),
                                  children: [
                                    TextSpan(
                                      text: 'Daftar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: isSmall ? 13 : 16,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const SignUpScreen(),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
