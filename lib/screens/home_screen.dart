import 'dart:ui';
import 'package:flutter/material.dart';
import 'book_list_screen.dart';
import './loan_list_screen.dart' as loan;
import 'return_screen.dart' as ret;
import 'profile_screen.dart';
import '../settings/notification_screen.dart';
import '../widgets/home_content.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  ThemeMode currentTheme = ThemeMode.light;

  final List<Widget> _screens = [
    const ModernHomeContent(),
    const BookListScreen(),
    const loan.LoanListScreen(), 
    const ret.ReturnScreen(),
    const ProfileScreen(),
  ];

  late final AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 1.0,
      upperBound: 1.2,
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void toggleTheme() {
    setState(() {
      currentTheme = currentTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void logout() async {
    await ApiService().clearToken();
    if (mounted) Navigator.of(context).pushReplacementNamed('/login');
  }

  void contactAdmin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          "Contact",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          "Email: admin@library.com\nWhatsApp: +62 812-3456-7890",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientAppBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.95),
            Theme.of(context).colorScheme.secondary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text(
                '📚 Library App',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
                tooltip: 'Notifications',
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                color: Theme.of(context).colorScheme.surface,
                onSelected: (value) {
                  if (value == 'theme') toggleTheme();
                  if (value == 'logout') logout();
                  if (value == 'contact') contactAdmin();
                },
                itemBuilder: (BuildContext context) => [
                  _buildPopupMenuItem(
                    context,
                    value: 'theme',
                    icon: currentTheme == ThemeMode.light ? Icons.nightlight_round : Icons.wb_sunny,
                    text: currentTheme == ThemeMode.light ? 'Dark Mode' : 'Light Mode',
                  ),
                  _buildPopupMenuItem(
                    context,
                    value: 'contact',
                    icon: Icons.person,
                    text: 'Contact Admin',
                  ),
                  _buildPopupMenuItem(
                    context,
                    value: 'logout',
                    icon: Icons.logout,
                    text: 'Logout',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      BuildContext context, {
        required String value,
        required IconData icon,
        required String text,
      }) {
    return PopupMenuItem<String>(
      value: value,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.indigo,
          secondary: Colors.indigoAccent,
          background: const Color(0xFFF5F6FA),
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF181A20),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.indigo,
          secondary: Colors.indigoAccent,
          background: const Color(0xFF181A20),
          surface: const Color(0xFF1F1F1F),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: currentTheme,
      routes: {
        '/notifications': (context) => const NotificationScreen(),
      },
      home: Builder(
        builder: (context) => Scaffold(
          extendBody: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: _buildGradientAppBar(context),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeInOutCubic,
            switchOutCurve: Curves.easeInOutCubic,
            child: _screens[_currentIndex],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() {
                        _currentIndex = index;
                        _iconController.forward(from: 1.0);
                      });
                    },
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    selectedFontSize: 15,
                    unselectedFontSize: 12,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    unselectedItemColor: Theme.of(context).unselectedWidgetColor,
                    showUnselectedLabels: true,
                    items: [
                      _buildAnimatedNavBarItem(Icons.home, 'Home', 0),
                      _buildAnimatedNavBarItem(Icons.menu_book, 'Books', 1),
                      _buildAnimatedNavBarItem(Icons.book_online, 'Loans', 2),
                      _buildAnimatedNavBarItem(Icons.assignment_return, 'Returns', 3),
                      _buildAnimatedNavBarItem(Icons.person, 'Profile', 4),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildAnimatedNavBarItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedScale(
        scale: isSelected ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: Icon(icon),
      ),
      label: label,
    );
  }
}