import 'package:flutter/material.dart';

import 'Dashboard.dart'; // berisi HalamanDashboard dan class Mahasiswa
import 'Register.dart'; // berisi HalamanRegister

/// Halaman login mahasiswa.
/// StatefulWidget karena ada data yang berubah: status loading dan
/// status tampil/sembunyi kata sandi.
class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  // Kunci Form: dipakai untuk memanggil validate() pada form.
  final _formKey = GlobalKey<FormState>();

  // Controller: untuk membaca teks yang diketik pengguna.
  final _idController = TextEditingController(); // isian Email / NIM
  final _passController = TextEditingController(); // isian kata sandi

  bool _sembunyikanSandi = true; // true = kata sandi disamarkan (titik-titik)
  bool _loading = false; // true = sedang proses login (tombol nonaktif)

  // Melepas controller saat halaman ditutup agar memori tidak bocor.
  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  /// Dijalankan saat tombol MASUK ditekan.
  Future<void> _submitLogin() async {
    // 1. Cek validasi form. Jika ada kolom kosong/salah, berhenti di sini
    //    (pesan error muncul otomatis di bawah kolom).
    if (!_formKey.currentState!.validate()) return;

    // 2. Tampilkan loading dan nonaktifkan tombol.
    setState(() => _loading = true);

    // 3. Simulasi proses login selama 2 detik.
    await Future.delayed(const Duration(seconds: 2));

    // 4. Cocokkan input dengan data yang tersimpan saat registrasi.
    //    Hasilnya data Mahasiswa bila cocok, atau null bila tidak cocok.
    final mahasiswa = await Mahasiswa.cari(
      _idController.text,
      _passController.text,
    );

    // 5. Pastikan halaman masih aktif setelah proses async selesai.
    if (!mounted) return;

    // 6. Matikan loading.
    setState(() => _loading = false);

    // 7. Data tidak cocok: tampilkan SnackBar merah, tetap di halaman login.
    if (mahasiswa == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login gagal: akun belum terdaftar atau data salah'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 8. Data cocok: pindah ke dashboard sambil membawa data mahasiswa.
    //    pushReplacement menggantikan halaman login, sehingga tombol Back
    //    tidak kembali ke login.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HalamanDashboard(mahasiswa: mahasiswa),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      // Center + ConstrainedBox: form berada di tengah dengan lebar maks 420.
      // SingleChildScrollView: halaman bisa di-scroll agar tidak overflow.
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Kolom Email / NIM: tidak boleh kosong.
                  TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'Email / NIM',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email / NIM tidak boleh kosong!';
                      }
                      return null; // null = input valid
                    },
                  ),
                  const SizedBox(height: 16),

                  // Kolom kata sandi: tidak boleh kosong, minimal 6 karakter.
                  TextFormField(
                    controller: _passController,
                    obscureText: _sembunyikanSandi, // menyamarkan karakter
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      // Ikon mata: tampil/sembunyikan kata sandi.
                      suffixIcon: IconButton(
                        icon: Icon(_sembunyikanSandi
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(
                            () => _sembunyikanSandi = !_sembunyikanSandi),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kata sandi tidak boleh kosong!';
                      }
                      if (value.length < 6) {
                        return 'Kata sandi minimal 6 karakter!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Tombol MASUK. Saat loading: onPressed null (nonaktif) dan
                  // isi tombol diganti lingkaran berputar.
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submitLogin,
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : const Text('MASUK'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Pindah ke halaman registrasi bila belum punya akun.
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HalamanRegister()),
                    ),
                    child: const Text('Belum punya akun? Daftar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}