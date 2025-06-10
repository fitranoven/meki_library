import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../settings/setting_screen.dart';
import '../settings/notification_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Memuat...';
  String? photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Tidak diketahui';
      photoUrl = prefs.getString('avatar'); // pastikan disimpan saat login
    });
  }

  Widget buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: (photoUrl != null && photoUrl!.isNotEmpty)
                      ? NetworkImage('http://localhost:8000/storage/$photoUrl')
                      : const AssetImage('assets/images/profile_placeholder.png') as ImageProvider,
                ),
                const SizedBox(height: 12),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          buildProfileOption(
            icon: Icons.lock,
            title: 'Privasi',
            subtitle: 'Pengaturan privasi',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          buildProfileOption(
            icon: Icons.notifications,
            title: 'Notifikasi',
            subtitle: 'Preferensi notifikasi',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationScreen()),
            ),
    
          ),
        ],
      ),
    );
  }
}
