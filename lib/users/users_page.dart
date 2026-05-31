import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../main_navigation.dart';       // Naik satu folder ke lib/main_navigation.dart
import '../config/env.dart';             // Naik satu folder ke lib/config/env.dart
import '../models/user_model.dart';      // Diubah ke user_model.dart sesuai gambar gurumu

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // Mengambil data menggunakan cetakan resmi UserModel
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('${Env.baseUrl}/collections/users/records?project_id=${Env.projectId}'),
        headers: {
          'x-api-key': Env.apiKey,
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        Map<String, dynamic> dataJSON = json.decode(response.body);
        List<dynamic> rawRecords = dataJSON['records'] ?? dataJSON['items'] ?? dataJSON['data'] ?? []; 
        return rawRecords.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Server merespon dengan kode HTTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Menghubungkan menu footer (API Demo ada di indeks nomor 5)
      bottomNavigationBar: const MainNavigation(currentIndex: 5),
      
      appBar: AppBar(
        title: const Text("REST API - Reqres Users"),
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
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF003566).withOpacity(0.1),
                    backgroundImage: user.avatar.startsWith('http') ? NetworkImage(user.avatar) : null,
                    child: !user.avatar.startsWith('http') 
                        ? const Icon(Icons.shopping_bag_outlined, color: Color(0xFF003566)) 
                        : null,
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      user.subtitle, 
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
              );
            },
          );
        },
      ),
    );
  }
}