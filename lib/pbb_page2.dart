import 'package:flutter/material.dart';
import 'detail_sppt.dart';
import 'main_navigation.dart';

class PBBPage2 extends StatelessWidget {
  final String nop;

  const PBBPage2({super.key, required this.nop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      bottomNavigationBar: const MainNavigation(currentIndex: 1),
      appBar: AppBar(
        title: const Text("PBB"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton( // 🔥 BACK BUTTON RESMI
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🔥 HASIL NOP
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      nop,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CARD 1
            buildCard(
              context: context,
              tahun: "SPPT 2021",
              status: "Belum lunas",
              statusColor: Colors.red,
              njop: "200.000",
            ),

            const SizedBox(height: 16),

            // CARD 2
            buildCard(
              context: context,
              tahun: "SPPT 2020",
              status: "Lunas",
              statusColor: Colors.green,
              njop: "376.000",
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard({
    required BuildContext context,
    required String tahun,
    required String status,
    required Color statusColor,
    required String njop,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tahun,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          // ALAMAT
          Row(
            children: const [
              Icon(Icons.location_on, size: 16),
              SizedBox(width: 5),
              Text("DS. Ngireng-ireng RT01/RW01"),
            ],
          ),

          const SizedBox(height: 10),

          // NJOP
          Row(
            children: [
              const Icon(Icons.attach_money, size: 16),
              const SizedBox(width: 5),
              const Text("NJOP Bumi dan Bangunan"),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  njop,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          // 🔥 DETAIL (PAKAI BUTTON RESMI)
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailSpptPage(
                      tahun: tahun,
                      njop: njop,
                      status: status,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Lihat Detail"),
                  SizedBox(width: 5),
                  Icon(Icons.arrow_forward_ios, size: 14),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}