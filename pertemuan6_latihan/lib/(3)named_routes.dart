import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const String beranda = '/';
  static const String profil = '/profil';
  static const String pengaturan = '/pengaturan';
}

void main() {
  runApp(MaterialApp(
    initialRoute: AppRoutes.beranda,
    routes: {
      AppRoutes.beranda: (context) => const Beranda(),
      AppRoutes.profil: (context) => const Halaman(judul: 'Profil'),
      AppRoutes.pengaturan: (context) => const Halaman(judul: 'Pengaturan'),
    },
  ));
}

class Beranda extends StatelessWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.profil),
              child: const Text('Buka Profil'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.pengaturan),
              child: const Text('Buka Pengaturan'),
            ),
          ],
        ),
      ),
    );
  }
}

class Halaman extends StatelessWidget {
  final String judul;
  const Halaman({super.key, required this.judul});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kembali'),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     initialRoute: '/',
//     routes: {
//       '/': (context) => const Beranda(),
//       '/profil': (context) => const Halaman(judul: 'Profil'),
//       '/pengaturan': (context) => const Halaman(judul: 'Pengaturan'),
//     },
//   ));
// }

// class Beranda extends StatelessWidget {
//   const Beranda({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Beranda')),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/profil'),
//               child: const Text('Buka Profil'),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/pengaturan'),
//               child: const Text('Buka Pengaturan'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Halaman extends StatelessWidget {
//   final String judul;
//   const Halaman({super.key, required this.judul});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(judul)),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Kembali'),
//         ),
//       ),
//     );
//   }
// }

