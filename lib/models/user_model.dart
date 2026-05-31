class UserModel {
  final String id;
  final String name;
  final String subtitle;
  final String avatar;

  UserModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.avatar,
  });

  // Fungsi factory untuk mengubah data JSON mentah menjadi objek Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Beberapa API mengirim id sebagai angka, beberapa mengirim sebagai GUID/text
      id: json['id']?.toString() ?? json['product_id']?.toString() ?? '0',

      // Mendeteksi kolom nama dari server kamu; gabungkan first+last jika tersedia
      name: () {
        if (json['name'] != null) return json['name'];
        if (json['title'] != null) return json['title'];
        if (json['first_name'] != null) {
          final last = json['last_name'] ?? '';
          return ('${json['first_name']} $last').trim();
        }
        return 'Data Tanpa Judul';
      }(),

      // Mendeteksi kolom deskripsi atau email (Pastikan bertuliskan subtitle dengan satu 't')
      subtitle:
          json['description'] ??
          json['email'] ??
          json['price']?.toString() ??
          'Tidak ada deskripsi',

      // 2. Jika kolom avatar kosong (null), otomatis pakai link foto cadangan dari Reqres
      avatar:
          json['avatar'] ??
          json['image'] ??
          json['imageUrl'] ??
          'https://reqres.in/img/faces/1-image.jpg',
    );
  }
}
