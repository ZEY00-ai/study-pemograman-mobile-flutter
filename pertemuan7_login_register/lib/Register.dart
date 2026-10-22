import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Dashboard.dart';
import 'Login.dart';

/// Halaman registrasi mahasiswa.
/// Urutan isian: Nama, NIM, Kampus, Jurusan, Email Kampus, Kata Sandi,
/// Konfirmasi Kata Sandi.
class HalamanRegister extends StatefulWidget {
  const HalamanRegister({super.key});

  @override
  State<HalamanRegister> createState() => _HalamanRegisterState();
}

class _HalamanRegisterState extends State<HalamanRegister> {
  // Kunci Form: dipakai untuk memanggil validate() dan reset() pada form.
  final _formKey = GlobalKey<FormState>();

  // Controller: untuk membaca/mengubah isi tiap kolom teks.
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _kampusController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _konfirmasiController = TextEditingController();

  // Daftar pilihan untuk dropdown jurusan.
  final List<String> _daftarJurusan = const [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Teknik Mesin',
    'Akuntansi',
  ];
  String? _jurusanPilihan; // null = belum memilih

  bool _sembunyikanSandi = true; // true = kata sandi disamarkan (titik-titik)
  bool _sembunyikanKonfirmasi = true; // sama, untuk kolom konfirmasi
  bool _setuju = false; // status checkbox Syarat & Ketentuan

  // Melepas semua controller saat halaman ditutup agar memori tidak bocor.
  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _kampusController.dispose();
    _emailController.dispose();
    _passController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------
  // INDIKATOR KEKUATAN KATA SANDI
  // ---------------------------------------------------------------

  /// Mengecek 4 syarat kata sandi yang kuat.
  /// Hasilnya berupa daftar: nama syarat -> terpenuhi (true) atau belum (false).
  /// Daftar ini dipakai untuk menghitung skor sekaligus menampilkan checklist.
  Map<String, bool> _cekSyarat(String sandi) {
    return {
      'Minimal 8 karakter': sandi.length >= 8,
      'Ada huruf besar (A-Z)': RegExp(r'[A-Z]').hasMatch(sandi),
      'Ada angka (0-9)': RegExp(r'[0-9]').hasMatch(sandi),
      'Ada simbol (contoh: ! @ # \$ %)':
          RegExp(r'[^A-Za-z0-9]').hasMatch(sandi),
    };
  }

  /// Mengubah jumlah syarat terpenuhi menjadi nilai 0.0 - 1.0
  /// untuk panjang bar LinearProgressIndicator.
  /// Kolom kosong = 0. Sudah mengetik tapi belum ada syarat terpenuhi = 0.25.
  double _hitungKekuatan(String sandi) {
    if (sandi.isEmpty) return 0;
    final terpenuhi = _cekSyarat(sandi).values.where((ok) => ok).length;
    return (terpenuhi == 0 ? 1 : terpenuhi) / 4;
  }

  /// Warna bar sesuai kekuatan: merah (lemah), oranye (sedang), hijau (kuat).
  Color _warnaKekuatan(double kekuatan) {
    if (kekuatan <= 0.25) return Colors.red;
    if (kekuatan <= 0.75) return Colors.orange;
    return Colors.green;
  }

  /// Teks label di samping bar: Lemah / Sedang / Kuat.
  String _labelKekuatan(double kekuatan) {
    if (kekuatan == 0) return '';
    if (kekuatan <= 0.25) return 'Lemah';
    if (kekuatan <= 0.75) return 'Sedang';
    return 'Kuat';
  }

  /// Satu baris checklist syarat: ikon centang hijau jika terpenuhi,
  /// ikon silang merah jika belum, abu-abu jika kolom masih kosong.
  Widget _barisSyarat(String teks, bool terpenuhi, bool kosong) {
    final Color warna = terpenuhi
        ? Colors.green
        : (kosong ? Colors.grey : Colors.red);
    final IconData ikon = terpenuhi
        ? Icons.check_circle
        : (kosong ? Icons.radio_button_unchecked : Icons.cancel);
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(ikon, size: 16, color: warna),
          const SizedBox(width: 8),
          Text(teks, style: TextStyle(fontSize: 12, color: warna)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // AKSI TOMBOL
  // ---------------------------------------------------------------

  /// Tombol RESET: mengosongkan semua isian dan menghapus pesan error.
  void _resetForm() {
    _formKey.currentState!.reset();
    _namaController.clear();
    _nimController.clear();
    _kampusController.clear();
    _emailController.clear();
    _passController.clear();
    _konfirmasiController.clear();
    setState(() {
      _jurusanPilihan = null;
      _setuju = false;
    });
  }

  /// Tombol DAFTAR: cek validasi, simpan data, lalu pindah ke halaman login.
  Future<void> _submitRegistrasi() async {
    // Jika ada kolom yang belum valid, berhenti (pesan error tampil otomatis).
    if (!_formKey.currentState!.validate()) return;

    final nama = _namaController.text.trim();

    // Simpan ke penyimpanan lokal; hasilnya pesan error (null = berhasil).
    final error = await Mahasiswa.simpan(Mahasiswa(
      nama: nama,
      nim: _nimController.text.trim(),
      kampus: _kampusController.text.trim(),
      jurusan: _jurusanPilihan!,
      email: _emailController.text.trim(),
      sandi: _passController.text,
    ));

    // Pastikan halaman masih aktif setelah proses async selesai.
    if (!mounted) return;

    // Gagal (mis. email/NIM sudah terdaftar): tampilkan SnackBar merah.
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    // Berhasil: SnackBar hijau lalu pindah ke halaman login.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registrasi berhasil untuk $nama, silakan login'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HalamanLogin()),
    );
  }

  // ---------------------------------------------------------------
  // TAMPILAN
  // ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Dihitung ulang setiap build, sehingga ikut berubah saat mengetik sandi.
    final sandi = _passController.text;
    final syarat = _cekSyarat(sandi);
    final kekuatan = _hitungKekuatan(sandi);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi')),
      // Center + ConstrainedBox: form berada di tengah dengan lebar maks 420.
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // 1. Nama: tidak boleh kosong / hanya spasi.
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama tidak boleh kosong!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2. NIM: hanya angka, tepat 10 digit.
                  // inputFormatters mencegah huruf diketik & membatasi 10 karakter.
                  TextFormField(
                    controller: _nimController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'NIM (10 digit)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'NIM tidak boleh kosong!';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'NIM harus tepat 10 digit angka!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3. Kampus: tidak boleh kosong.
                  TextFormField(
                    controller: _kampusController,
                    decoration: const InputDecoration(
                      labelText: 'Kampus',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_balance),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kampus tidak boleh kosong!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 4. Jurusan: dropdown, wajib dipilih.
                  DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: _jurusanPilihan,
                    decoration: const InputDecoration(
                      labelText: 'Jurusan',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    // Ubah daftar teks menjadi daftar item dropdown.
                    items: _daftarJurusan.map((String jurusan) {
                      return DropdownMenuItem<String>(
                        value: jurusan,
                        child: Text(jurusan),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _jurusanPilihan = value),
                    validator: (value) =>
                        value == null ? 'Silakan pilih jurusan!' : null,
                  ),
                  const SizedBox(height: 16),

                  // 5. Email kampus: hanya menerima format nama@domain.ac.id.
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Kampus',
                      hintText: 'nama@kampus.ac.id',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email tidak boleh kosong!';
                      }
                      final email = value.trim().toLowerCase();
                      // Domain harus diakhiri .ac.id (email kampus).
                      final regex = RegExp(
                          r'^[\w.+-]+@[a-z0-9-]+(\.[a-z0-9-]+)*\.ac\.id$');
                      if (!regex.hasMatch(email)) {
                        return 'Gunakan email kampus berformat nama@domain.ac.id';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 6. Kata sandi. onChanged memanggil setState agar indikator
                  // kekuatan dan checklist di bawahnya diperbarui saat mengetik.
                  TextFormField(
                    controller: _passController,
                    obscureText: _sembunyikanSandi,
                    onChanged: (_) => setState(() {}),
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
                  const SizedBox(height: 8),

                  // Bar kekuatan + label (Lemah/Sedang/Kuat).
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: kekuatan,
                            minHeight: 8,
                            color: _warnaKekuatan(kekuatan),
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 60,
                        child: Text(
                          _labelKekuatan(kekuatan),
                          style: TextStyle(
                            color: _warnaKekuatan(kekuatan),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Checklist syarat: menunjukkan mana yang sudah dan belum.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: syarat.entries
                          .map((e) =>
                              _barisSyarat(e.key, e.value, sandi.isEmpty))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 7. Konfirmasi kata sandi: harus sama dengan kata sandi.
                  TextFormField(
                    controller: _konfirmasiController,
                    obscureText: _sembunyikanKonfirmasi,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Kata Sandi',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_sembunyikanKonfirmasi
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setState(() =>
                            _sembunyikanKonfirmasi = !_sembunyikanKonfirmasi),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi kata sandi wajib diisi!';
                      }
                      if (value != _passController.text) {
                        return 'Kata sandi tidak cocok!';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),

                  // Checkbox Syarat & Ketentuan. Memakai FormField agar bisa
                  // ikut divalidasi dan menampilkan pesan error bila belum dicentang.
                  FormField<bool>(
                    initialValue: false,
                    validator: (_) => _setuju
                        ? null
                        : 'Anda harus menyetujui Syarat & Ketentuan!',
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            title: const Text(
                                'Saya setuju dengan Syarat & Ketentuan'),
                            value: _setuju,
                            onChanged: (v) {
                              setState(() => _setuju = v ?? false);
                              state.didChange(v);
                            },
                          ),
                          // Pesan error hanya muncul jika validasi gagal.
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Tombol DAFTAR (mengisi sisa lebar) dan RESET.
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _submitRegistrasi,
                            child: const Text('DAFTAR'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: _resetForm,
                          child: const Text('RESET'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Pindah ke halaman login bila sudah punya akun.
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HalamanLogin()),
                    ),
                    child: const Text('Sudah punya akun? Login'),
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