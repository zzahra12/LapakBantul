import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../../config/env.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    GoogleSignIn.instance.initialize(
      serverClientId: Env.googleServerClientId,
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // Fungsi Login Manual Email & Password
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text.trim(),
        );

        await _saveLoginToApi(_emailCtrl.text.trim());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selamat Datang Kembali!'),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Terjadi kesalahan saat masuk';
        if (e.code == 'user-not-found') {
          message = 'Email belum terdaftar. Silakan daftar terlebih dahulu.';
        } else if (e.code == 'wrong-password') {
          message = 'Kata sandi yang Anda masukkan salah.';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _saveLoginToApi(String? email) async {
    if (email == null || email.isEmpty) {
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Env.baseUrl}/logins'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Env.apiKey,
        },
        body: jsonEncode({
          'email': email,
          'login_at': DateTime.now().toUtc().toIso8601String(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200 && response.statusCode != 201) {
        // ignore: avoid_print
        print('Gagal menyimpan login ke API Demo: ${response.statusCode} ${response.body}');
      } else {
        // ignore: avoid_print
        print('Login tersimpan di API Demo untuk user: $email');
      }
    } catch (e) {
      // Jangan hentikan proses login jika penyimpanan API gagal.
      // ignore: avoid_print
      print('Error menyimpan login ke API Demo: $e');
    }
  }

  // 🚀 FUNGSI LOGIN GOOGLE MENGGUNAKAN google_sign_in + firebase_auth
  Future<void> _loginGoogleReal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance.authenticate();
      print('✅ Google user authenticated: ${googleUser.email}');
      
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      print('📱 Google authentication obtained');
      
      if (googleAuth.idToken == null) {
        print('❌ ID Token is null!');
        throw Exception('ID Token tidak tersedia dari Google');
      }
      
      print('🔐 ID Token: ${googleAuth.idToken?.substring(0, 20)}...');
      
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      
      print('🔗 Creating Firebase credential...');

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      
      print('🎉 Firebase authentication successful: ${userCredential.user?.email}');

      if (mounted && userCredential.user != null) {
        await _saveLoginToApi(userCredential.user?.email);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selamat Datang, ${userCredential.user?.displayName ?? "User Google"}!'),
            backgroundColor: Colors.blue,
            behavior: SnackBarBehavior.floating,
          ),
        );

        print('🚀 Navigating to HomePage...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      String message = 'Terjadi kesalahan saat login dengan Google.';
      if (e.code == 'account-exists-with-different-credential') {
        message = 'Akun Google ini sudah digunakan dengan metode masuk lain.';
      } else if (e.code == 'operation-not-allowed') {
        message = 'Fitur Google Sign-In belum diaktifkan di Firebase Auth.';
      } else if (e.code == 'invalid-credential') {
        message = 'Kredensial Google tidak valid. Coba lagi.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$message\nDetail: ${e.message ?? e.code}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 6),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Jika user cancel/batalkan proses login Google, tidak perlu tampil error
      if (e.toString().contains('canceled') || e.toString().contains('activity is cancelled')) {
        return;
      }
      
      print('❌ General Error: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal masuk dengan Google.\nDetail: $e'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 6),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: const BoxDecoration(
              color: Color(0xFF003566),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_rounded,
                        size: 45,
                        color: Color(0xFF003566),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'LaPak Bantul',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Selamat Datang",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Silakan masuk ke akun Anda",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 30),

                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _customInputStyle('Alamat Email', Icons.mail_outline_rounded),
                            validator: (v) => (v == null || !v.contains('@')) ? 'Email tidak valid' : null,
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            decoration: _customInputStyle('Kata Sandi', Icons.lock_open_rounded).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(_obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: Colors.grey, size: 20),
                                onPressed: () => setState(() => _obscure = !_obscure),
                              ),
                            ),
                            validator: (v) => (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
                          ),

                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                                );
                              },
                              child: const Text(
                                'Lupa Sandi?',
                                style: TextStyle(color: Color(0xFF003566), fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003566),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                    )
                                  : const Text('MASUK SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
                            ),
                          ),

                          const SizedBox(height: 16),
                          const Center(child: Text("atau", style: TextStyle(color: Colors.grey, fontSize: 13))),
                          const SizedBox(height: 16),

                          // 🚀 TOMBOL GOOGLE AKTIF 100% TANPA PACKAGE LUAR YANG RUSAK
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton.icon(
                              icon: Image.asset('assets/google_logo.png', height: 24),
                              label: const Text(
                                'MASUK DENGAN GOOGLE',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), letterSpacing: 0.5),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: _isLoading ? null : _loginGoogleReal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum punya akun? ', style: TextStyle(color: Colors.blueGrey)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text(
                            'Daftar Disini',
                            style: TextStyle(color: Color(0xFF003566), fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _customInputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.blueGrey, fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF003566), size: 22),
      filled: true,
      fillColor: const Color(0xFFF1F5F9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF003566), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    );
  }
}