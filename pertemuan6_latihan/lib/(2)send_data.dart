import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const DaftarWisata(),
        '/detail': (context) => const HalamanDetail(),
      },
    );
  }
}

class Wisata {
  final String nama;
  final String deskripsi;
  const Wisata(this.nama, this.deskripsi);
}

const data = [
  Wisata('Pantai Padang', 'Pantai di tengah Kota Padang.'),
  Wisata('Jam Gadang', 'Menara jam ikonik di Bukittinggi.'),
  Wisata('Ngarai Sianok', 'Lembah curam dengan pemandangan hijau.'),
];

class DaftarWisata extends StatelessWidget {
  const DaftarWisata({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Wisata')),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            leading: const Icon(Icons.place),
            title: Text(item.nama),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: item,
              );
            },
          );
        },
      ),
    );
  }
}

class HalamanDetail extends StatelessWidget {
  const HalamanDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final wisata = ModalRoute.of(context)!.settings.arguments as Wisata;

    return Scaffold(
      appBar: AppBar(title: Text(wisata.nama)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(wisata.deskripsi, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MaterialApp(home: DaftarWisata()));
// }

// class Wisata {
//   final String nama;
//   final String deskripsi;
//   const Wisata(this.nama, this.deskripsi);
// }

// const data = [
//   Wisata('Pantai Padang', 'Pantai di tengah Kota Padang.'),
//   Wisata('Jam Gadang', 'Menara jam ikonik di Bukittinggi.'),
//   Wisata('Ngarai Sianok', 'Lembah curam dengan pemandangan hijau.'),
// ];

// class DaftarWisata extends StatelessWidget {
//   const DaftarWisata({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Daftar Wisata')),
//       body: ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           final item = data[index];
//           return ListTile(
//             leading: const Icon(Icons.place),
//             title: Text(item.nama),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => HalamanDetail(wisata: item),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class HalamanDetail extends StatelessWidget {
//   final Wisata wisata;
//   const HalamanDetail({super.key, required this.wisata});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(wisata.nama)),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Text(wisata.deskripsi, style: const TextStyle(fontSize: 18)),
//       ),
//     );
//   }
// }
