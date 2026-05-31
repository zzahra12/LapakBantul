import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'main_navigation.dart'; // Navigasi footer kamu
import 'config/env.dart'; // Import brankas konfigurasi
import 'models/user_model.dart'; // Import cetakan model data

class ApiDemoPage extends StatefulWidget {
  const ApiDemoPage({super.key});

  @override
  State<ApiDemoPage> createState() => _ApiDemoPageState();
}

class _ApiDemoPageState extends State<ApiDemoPage> {
  
  // Fungsi mengambil data yang mengembalikan List berisi objek UserModel resmi
  Future<List<UserModel>> fetchUsers() async {
    try {
      // Menggabungkan URL secara rapi menggunakan data dari Env
      // Gunakan endpoint Reqres untuk daftar pengguna
      final response = await http.get(
        Uri.parse('${Env.baseUrl}/users?page=1'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': Env.apiKey,
        },
      ).timeout(const Duration(seconds: 10));

      // Debug: print status dan body agar bisa dilihat di konsol saat troubleshooting
      // ignore: avoid_print
      print('API GET ${response.request?.url} -> ${response.statusCode}');
      // ignore: avoid_print
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // Jika respons adalah Map berisi kunci 'data'
        if (decoded is Map<String, dynamic>) {
          List<dynamic> rawRecords = decoded['data'] ?? decoded['records'] ?? decoded['items'] ?? [];
          return rawRecords.map((json) => UserModel.fromJson(json)).toList();
        }

        // Jika respons langsung berupa List
        if (decoded is List) {
          return decoded.map((json) => UserModel.fromJson(json)).toList();
        }

        // Jika struktur tidak diketahui, tampilkan error yang jelas
        throw Exception('Struktur JSON tidak dikenali: ${response.body}');
      } else {
        // Cetak body untuk debugging (lihat terminal saat running)
        // ignore: avoid_print
        print('API ${response.request?.url} responded ${response.statusCode}: ${response.body}');
        throw Exception('Server merespon dengan kode HTTP: ${response.statusCode}\n${response.body}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const MainNavigation(currentIndex: 5), // Tetap di indeks 5
      
      appBar: AppBar(
        title: const Text("Data Pengguna API"),
        centerTitle: true,
        backgroundColor: const Color(0xFF003566),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: FutureBuilder<List<UserModel>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF003566)),
            );
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Terjadi Kesalahan:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 14, height: 1.4),
                ),
              ),
            );
          }

          final items = snapshot.data ?? [];
          
          if (items.isEmpty) {
            return const Center(child: Text("Data kosong atau struktur JSON berubah"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final user = items[index];

              return Card(
                elevation: 1.5,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: user.avatar.startsWith('http') ? NetworkImage(user.avatar) : null,
                      child: !user.avatar.startsWith('http')
                          ? const Icon(Icons.person_outline, color: Colors.grey)
                          : null,
                    ),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        user.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B3F99),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4, offset: const Offset(0,2)),
                        ],
                      ),
                      child: Text(
                        'ID ${user.id}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}