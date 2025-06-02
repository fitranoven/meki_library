import 'package:flutter/material.dart';

// Model untuk item navbar agar mudah dikembangkan
class NavbarItem {
  final IconData icon;
  final String label;
  final Widget page;

  NavbarItem({required this.icon, required this.label, required this.page});
}

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  // Daftar item navbar, ganti/extend sesuai kebutuhan
  final List<NavbarItem> _items = [
    NavbarItem(
      icon: Icons.home_rounded,
      label: 'Beranda',
      page:
          const Center(child: Text('Beranda', style: TextStyle(fontSize: 24))),
    ),
    NavbarItem(
      icon: Icons.book_rounded,
      label: 'Peminjaman',
      page: const Center(
          child: Text('Peminjaman', style: TextStyle(fontSize: 24))),
    ),
    NavbarItem(
      icon: Icons.assignment_return_rounded,
      label: 'Pengembalian',
      page: const Center(
          child: Text('Pengembalian', style: TextStyle(fontSize: 24))),
    ),
    NavbarItem(
      icon: Icons.settings_rounded,
      label: 'Pengaturan',
      page: const Center(
          child: Text('Pengaturan', style: TextStyle(fontSize: 24))),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _items[_currentIndex].page,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF22223B) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                final selected = _currentIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? (isDark
                                ? const Color(0xFF3A86FF)
                                    .withAlpha((0.15 * 255).toInt())
                                : const Color(0xFF3A86FF)
                                    .withAlpha((0.08 * 255).toInt()))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _items[index].icon,
                            size: selected ? 32 : 26,
                            color: selected
                                ? const Color(0xFF3A86FF)
                                : (isDark ? Colors.white70 : Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              color: selected
                                  ? const Color(0xFF3A86FF)
                                  : (isDark ? Colors.white70 : Colors.black54),
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: selected ? 14 : 12,
                            ),
                            child: Text(_items[index].label),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
