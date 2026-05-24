import 'package:flutter/material.dart';
import '../auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Data konten splash screen
  static const _pages = [
    _SplashData(
      title: 'Selamat Datang di LaPak Bantul',
      description:
          'Pusat Layanan Pajak Terpadu Kabupaten Bantul yang mudah, cepat, dan transparan.',
      icon: Icons.account_balance,
      color: Color(0xFF003566),
    ),
    _SplashData(
      title: 'Kelola Semua Pajak Anda',
      description:
          'Bayar dan pantau PBB, Pajak Kendaraan, dan Pajak Usaha Anda dalam satu aplikasi.',
      icon: Icons.receipt_long,
      color: Color(0xFF005A9E),
    ),
    _SplashData(
      title: 'Layanan Keliling Hadir untuk Anda',
      description:
          'Kami hadir di dekat Anda melalui layanan pajak keliling. Cek jadwal dan lokasi terkini.',
      icon: Icons.directions_bus,
      color: Color(0xFF0077CC),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _SplashPage(data: _pages[i]),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Indikator Titik (Dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? Colors.white : Colors.white38,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Tombol Utama
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _goToNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF003566),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Mulai' : 'Selanjutnya',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tombol Lewati
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: 50,
              right: 24,
              child: TextButton(
                onPressed: _skip,
                child: const Text(
                  'Lewati',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SplashData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _SplashData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _SplashPage extends StatelessWidget {
  final _SplashData data;

  const _SplashPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.color,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                // Menggunakan withOpacity agar aman di semua versi Flutter
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(data.icon, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                data.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 100), // Memberi ruang untuk tombol di bawah
          ],
        ),
      ),
    );
  }
}