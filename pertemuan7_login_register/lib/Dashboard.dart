import 'dart:convert'; // jsonEncode / jsonDecode untuk mengubah data <-> teks JSON

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // penyimpanan lokal

import 'Login.dart';

/// ===============================================================
/// MODEL DATA + PENYIMPANAN LOKAL
/// Class ini mewakili satu mahasiswa, sekaligus berisi fungsi untuk
/// menyimpan (registrasi) dan mencari (login) data di perangkat.
/// ===============================================================
class Mahasiswa {
  final String nama;
  final String nim;
  final String kampus;
  final String jurusan;
  final String email;
  final String sandi;

  const Mahasiswa({
    required this.nama,
    required this.nim,
    required this.kampus,
    required this.jurusan,
    required this.email,
    required this.sandi,
  });

  /// Mengubah objek Mahasiswa menjadi Map agar bisa disimpan sebagai JSON.
  Map<String, dynamic> toJson() => {
        'nama': nama,
        'nim': nim,
        'kampus': kampus,
        'jurusan': jurusan,
        'email': email,
        'sandi': sandi,
      };

  /// Kebalikannya: membuat objek Mahasiswa dari Map hasil membaca JSON.
  /// Data lama yang belum punya 'kampus' diberi nilai '-' agar tidak error.
  factory Mahasiswa.fromJson(Map<String, dynamic> json) => Mahasiswa(
        nama: json['nama'] as String,
        nim: json['nim'] as String,
        kampus: (json['kampus'] as String?) ?? '-',
        jurusan: json['jurusan'] as String,
        email: json['email'] as String,
        sandi: json['sandi'] as String,
      );

  // Nama kunci tempat daftar mahasiswa disimpan di shared_preferences.
  static const _kunci = 'daftar_mahasiswa';

  /// Membaca seluruh mahasiswa yang pernah mendaftar.
  /// Mengembalikan daftar kosong bila belum ada data.
  static Future<List<Mahasiswa>> semua() async {
    final prefs = await SharedPreferences.getInstance();
    final mentah = prefs.getString(_kunci); // teks JSON, atau null
    if (mentah == null) return [];
    return (jsonDecode(mentah) as List<dynamic>)
        .map((e) => Mahasiswa.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Dipakai saat REGISTRASI: menyimpan mahasiswa baru.
  /// Mengembalikan pesan error bila gagal, atau null bila berhasil.
  static Future<String?> simpan(Mahasiswa baru) async {
    final data = await semua();

    // Tolak bila email atau NIM sudah dipakai mahasiswa lain.
    if (data.any((m) => m.email.toLowerCase() == baru.email.toLowerCase())) {
      return 'Email sudah terdaftar!';
    }
    if (data.any((m) => m.nim == baru.nim)) {
      return 'NIM sudah terdaftar!';
    }

    // Tambahkan ke daftar, lalu simpan ulang seluruh daftar sebagai JSON.
    data.add(baru);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kunci,
      jsonEncode(data.map((m) => m.toJson()).toList()),
    );
    return null; // null = berhasil
  }

  /// Dipakai saat LOGIN: mencari mahasiswa berdasarkan email atau NIM
  /// beserta kata sandi. Mengembalikan null bila tidak ada yang cocok.
  static Future<Mahasiswa?> cari(String identitas, String sandi) async {
    final id = identitas.trim().toLowerCase();
    for (final m in await semua()) {
      final cocokId = m.email.toLowerCase() == id || m.nim == id;
      if (cocokId && m.sandi == sandi) return m;
    }
    return null;
  }
}

/// ===============================================================
/// HALAMAN DASHBOARD
/// Muncul setelah login berhasil dan menampilkan data mahasiswa
/// yang sedang login.
/// ===============================================================
class HalamanDashboard extends StatelessWidget {
  // Data mahasiswa yang dikirim dari halaman login.
  final Mahasiswa mahasiswa;

  const HalamanDashboard({super.key, required this.mahasiswa});

  /// Logout: kembali ke halaman login. pushReplacement menggantikan
  /// dashboard sehingga tombol Back tidak kembali ke dashboard.
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HalamanLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false, // sembunyikan tombol panah kembali
        actions: [
          // Tombol logout di pojok kanan atas.
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      // Center + ConstrainedBox: isi di tengah layar dengan lebar maks 500.
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true, // tinggi list sesuai isi agar tetap di tengah
            children: [
              // Avatar bulat berisi huruf pertama nama.
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    mahasiswa.nama.isNotEmpty
                        ? mahasiswa.nama[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Teks sambutan dengan nama mahasiswa.
              Text(
                'Selamat datang, ${mahasiswa.nama}!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),

              // Kartu data mahasiswa: tiap baris satu data, dipisah garis.
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge),
                      title: const Text('Nama Lengkap'),
                      subtitle: Text(mahasiswa.nama),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.numbers),
                      title: const Text('NIM'),
                      subtitle: Text(mahasiswa.nim),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.account_balance),
                      title: const Text('Kampus'),
                      subtitle: Text(mahasiswa.kampus),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.school),
                      title: const Text('Jurusan'),
                      subtitle: Text(mahasiswa.jurusan),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email Kampus'),
                      subtitle: Text(mahasiswa.email),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}