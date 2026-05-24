import 'package:flutter/material.dart';
import 'pbb_page.dart'; // 🔥 TAMBAH INI

class LayananKelilingPage extends StatelessWidget {
  LayananKelilingPage({super.key});

  final List<Map<String, String>> mobilList = [
    {
      "nama": "Mobil 01",
      "jam": "08:00 - 16:00",
      "desc": "Mangir lor & Manager tengah, sendang"
    },
    {
      "nama": "Mobil 02",
      "jam": "08:00 - 16:00",
      "desc": "Mangir lor & Manager tengah, sendang"
    },
    {
      "nama": "Mobil Alphard",
      "jam": "08:00 - 16:00",
      "desc": "Mangir lor & Manager tengah, sendang"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.black),
    onPressed: () {
      Navigator.pop(context); // 🔥 kembali ke halaman sebelumnya
    },
  ),
  centerTitle: true,
  title: const Text(
    "Layanan Keliling",
    style: TextStyle(color: Colors.black),
  ),
),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 TANGGAL
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  dateItem("21/01/2024", true),
                  dateItem("25/01/2024", false),
                  dateItem("28/01/2024", false),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Text(
              "Hari ini, 21 Januari 2024",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),

            const SizedBox(height: 16),

            // 🔥 LIST MOBIL
            Expanded(
              child: ListView.builder(
                itemCount: mobilList.length,
                itemBuilder: (context, index) {
                  final mobil = mobilList[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        if (mobil["nama"] == "Mobil Alphard") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PBBPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${mobil["nama"]} belum tersedia"),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mobil["nama"]!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          mobil["desc"]!,
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                mobil["jam"]!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 BUTTON TANGGAL
  Widget dateItem(String text, bool active) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(
          Icons.calendar_today,
          size: 16,
          color: active ? Colors.white : Colors.black54,
        ),
        label: Text(
          text,
          style: TextStyle(
            color: active ? Colors.white : Colors.black,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: active ? Colors.blue[900] : Colors.grey[200],
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}