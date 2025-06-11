import 'package:flutter/material.dart';
import 'package:library_frontend/screens/return_screen.dart' as return_screen;
import 'package:library_frontend/settings/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/book_list_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/loan_list_screen.dart';
// Make sure the class name in loan_list_screen.dart matches the usage below.
import 'settings/notification_screen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(isLoggedIn: token != null && token.isNotEmpty));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perpustakaan App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/loans': (context) => const LoanListScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        // Navigasi dinamis untuk halaman yang butuh parameter
        if (settings.name == '/returns') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => return_screen.ReturnScreen(loanId: args['loanId']),
          );
        }
        // Return null if no match, so default behavior applies
        return null;
      },
    );
  }
}
