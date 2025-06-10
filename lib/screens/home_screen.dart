import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'my_books_page.dart';
import 'favorites_page.dart';
import 'history_page.dart';
import 'settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Digital Library";
  String token = "";
  int userId = 0; // Ubah ke int

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    final tokenString = prefs.getString('token');
    if (userString != null) {
      final user = jsonDecode(userString);
      setState(() {
        userName = user['name'];
        userId = user['id'] is int
            ? user['id']
            : int.tryParse(user['id'].toString()) ?? 0;
      });
    }
    if (tokenString != null) {
      setState(() {
        token = tokenString;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A85B6), Color(0xFFBAC8E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                    backgroundColor: Colors.white24,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome Back,',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurpleAccent.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.auto_stories,
                        color: Colors.white, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Explore New Books",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Find your next favorite book in our digital library.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Feature Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 600) {
                    // Untuk layar kecil: horizontal scroll + center
                    return SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        children: _buildFeatureCards(),
                      ),
                    );
                  } else {
                    // Untuk layar lebar: wrap dan center
                    return Center(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: _buildFeatureCards(),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(
                child: Text(
                  "",
                  style: TextStyle(color: Colors.white60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFeatureCards() {
    final List<Map<String, dynamic>> features = [
      {
        'icon': Icons.book,
        'title': "My Books",
        'color1': const Color(0xFF6DD5FA),
        'color2': const Color(0xFF2980B9),
        'pageBuilder': () => const MyBooksPage(),
      },
      {
        'icon': Icons.favorite,
        'title': "Favorites",
        'color1': const Color(0xFFFF6A00),
        'color2': const Color(0xFFFFC371),
        'pageBuilder': () => const FavoritesPage(),
      },
      {
        'icon': Icons.history,
        'title': "History",
        'color1': const Color(0xFF7F00FF),
        'color2': const Color(0xFFE100FF),
        'pageBuilder': () => HistoryPage(token: token, userId: userId),
      },
      {
        'icon': Icons.settings,
        'title': "Settings",
        'color1': const Color(0xFF56CCF2),
        'color2': const Color(0xFF2F80ED),
        'pageBuilder': () => const SettingsPage(),
      },
    ];

    final cards = <Widget>[];
    for (var i = 0; i < features.length; i++) {
      final f = features[i];
      cards.add(
        _featureCard(
          icon: f['icon'] as IconData,
          title: f['title'] as String,
          color1: f['color1'] as Color,
          color2: f['color2'] as Color,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => f['pageBuilder']()),
          ),
          margin: EdgeInsets.only(right: i == features.length - 1 ? 0 : 16),
        ),
      );
    }
    return cards;
  }

  Widget _featureCard({
    required IconData icon,
    required String title,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
    EdgeInsets margin = const EdgeInsets.only(right: 16),
  }) {
    return Semantics(
      label: title,
      button: true,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            width: 110,
            height: 110,
            margin: margin,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: color2.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 36),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
