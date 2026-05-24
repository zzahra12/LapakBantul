import 'package:flutter/material.dart';
import 'pbb_page2.dart';
import 'main_navigation.dart';

class PBBPage extends StatelessWidget {
  PBBPage({super.key});

  final TextEditingController nopController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: const MainNavigation(currentIndex: 1),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton( // 🔥 UBAH INI JUGA
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "PBB",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // 🔍 SEARCH BOX
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  
                  // 🔥 GANTI JADI BUTTON RESMI
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.grey),
                    onPressed: () {
                      print("DIKLIK");
                      print(nopController.text);

                      if (nopController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("NOP belum diisi"),
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PBBPage2(nop: nopController.text),
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      controller: nopController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        if (value.isEmpty) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PBBPage2(nop: value),
                          ),
                        );
                      },
                      decoration: const InputDecoration(
                        hintText: "Masukan NOP...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.description,
                      size: 80,
                      color: Colors.blueGrey,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Masukan NOP untuk melihat",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "rincian pajak.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}