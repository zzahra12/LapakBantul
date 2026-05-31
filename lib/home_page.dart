import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🚀 Wajib import ini untuk fitur Log Out
import 'appbar.dart';
import 'pbb_page.dart';
import 'main_navigation.dart';
import 'screens/auth/login_page.dart'; // 🚀 Pastikan jalur impor ke halaman login kamu benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// 🔄 Diubah menjadi StatefulWidget agar perpindahan halaman setelah Log Out aman 100%
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  // 🚀 FUNGSI UTAMA LOG OUT FIREBASE LIVE
  Future<void> _logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil keluar akun!'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        // Meluncur balik ke halaman Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal keluar: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: const MainNavigation(currentIndex: 0),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Beranda",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // 🚀 FOTO PROFIL DIUBAH JADI TOMBOL INTERAKTIF LOG OUT
                GestureDetector(
                  onTap: () {
                    // Munculkan kotak dialog konfirmasi saat foto profil diklik
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Keluar Akun?'),
                        content: const Text('Apakah Anda yakin ingin keluar dari LaPak Bantul?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('BATAL', style: TextStyle(color: Colors.grey)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Tutup dialog
                              _logOut(); // Jalankan fungsi log out
                            },
                            child: const Text('KELUAR', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('assets/profile.png'), 
                  ),
                ),
              ],
            ),
          ),

          // 🔵 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF0D3B66),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "LaPak Bantul",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Pusat layanan pajak terpadu",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔳 GRID MENU
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                MenuItem(
                  title: "PBB",
                  icon: Icons.home,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PBBPage(),
                      ),
                    );
                  },
                ),
                const MenuItem(
                  title: "BPHTB",
                  icon: Icons.receipt,
                ),
                const MenuItem(
                  title: "Rekap",
                  icon: Icons.receipt,
                ),
                MenuItem(
                  title: "Layanan Keliling",
                  icon: Icons.directions_bus,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppBarPage(),
                      ),
                    );
                  },
                ),
                const MenuItem(
                  title: "Informasi",
                  icon: Icons.info,
                ),
                const MenuItem(
                  title: "Lainnya",
                  icon: Icons.more_horiz,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔘 MENU ITEM (FIX SEMUA TOMBOL AKTIF)
class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ?? () {}, 
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}