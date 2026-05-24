import 'package:flutter/material.dart';

class DetailSpptPage extends StatelessWidget {
  final String tahun;
  final String njop;
  final String status;

  const DetailSpptPage({
    super.key,
    required this.tahun,
    required this.njop,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isLunas = status == "Lunas";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton( // 🔥 BUTTON RESMI
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              "No. NOP $tahun",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),

            const Text(
              "AHMAD NABIL BAHROIN\nROGER SUMATRA",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Alamat Lengkap WP : Kab Bantul, Kec. Sewon, DS. Ngireng-ireng, RT01/RW01",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            buildItem("Lokasi", "DS. Ngireng-ireng, RT01/RW01"),

            // 🔥 STATUS DINAMIS
            buildStatus(isLunas),

            buildItem("Denda", isLunas ? "Rp. 0" : "Rp. 50.000"),

            buildItem("NJOP Bumi", njop),

            buildItem("NJOP Bangunan", "Rp. 0"),

            buildItem("Luas Bumi", "227m"),

            buildItem("Luas Bangunan", ""),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
        const Divider(),
      ],
    );
  }

  Widget buildStatus(bool isLunas) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          "Status",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isLunas ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isLunas ? "Sudah Lunas" : "Belum Lunas",
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const Divider(),
      ],
    );
  }
}