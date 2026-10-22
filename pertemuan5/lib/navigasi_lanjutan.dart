import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisata Indonesia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),

        '/pantai': (context) => const MenuPage(
          menuTitle: 'Pantai',
          icon: Icons.beach_access,
          imageUrl:
              'https://images.unsplash.com/photo-1507525428034-b723cf961d3e',
              title: 'Pantai',
          description: 'Pantai merupakan tempat wisata yang menawarkan keindahan laut, pasir putih, dan pemandangan matahari terbenam. Indonesia memiliki banyak pantai indah yang cocok untuk bersantai dan menikmati suasana alam.',
        ),

        '/gunung': (context) => const MenuPage(
          menuTitle: 'Gunung',
          icon: Icons.terrain,
          imageUrl:
              'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b',
              title: 'Gunung',
          description: 'Gunung merupakan destinasi wisata alam yang menawarkan pemandangan yang indah dan udara yang sejuk. Pendakian gunung juga menjadi aktivitas yang populer bagi para pecinta alam.',
        ),

        '/budaya': (context) => const MenuPage(
          menuTitle: 'Budaya',
          icon: Icons.museum,
          imageUrl:
              'https://images.unsplash.com/photo-1539650116574-75c0c6d73f6e',
              title: 'Budaya',
          description: 'Indonesia memiliki kekayaan budaya yang sangat beragam, mulai dari rumah adat, pakaian tradisional, tarian, musik, hingga berbagai upacara adat dari setiap daerah.',
        ),

        '/kuliner': (context) => const MenuPage(
          menuTitle: 'Kuliner',
          icon: Icons.restaurant,
          imageUrl: 'https://images.unsplash.com/photo-1562565652-a0d8f0c59eb4',
          title: 'Kuliner',
          description: 'Kuliner Indonesia terkenal dengan cita rasa yang kaya dan beragam. Setiap daerah memiliki makanan khas dengan bahan, bumbu, dan cara memasak yang berbeda.',
        ),

        // Tambahan Motor
        '/motor': (context) => const MenuPage(
          menuTitle: 'Motor',
          icon: Icons.motorcycle,
          imageUrl:
              'https://images.unsplash.com/photo-1518655048521-f0c5a3e2f7e8',
              title: 'Motor',
          description: 'Motor adalah kendaraan roda dua yang praktis dan populer di Indonesia, digunakan untuk perjalanan sehari-hari maupun wisata keliling kota.',
        ),

        // Tambahan Mobil
        '/mobil': (context) => const MenuPage(
          menuTitle: 'Mobil',
          icon: Icons.directions_car,
          imageUrl:
              'https://images.unsplash.com/photo-1502877338535-766e1452684a',
              title: 'Mobil',
          description: 'Mobil merupakan kendaraan roda empat yang nyaman untuk perjalanan jauh, wisata keluarga, maupun transportasi sehari-hari.',
        ),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _menuButton(
              context,
              title: 'Pantai',
              icon: Icons.beach_access,
              route: '/pantai',
            ),
            _menuButton(
              context,
              title: 'Gunung',
              icon: Icons.terrain,
              route: '/gunung',
            ),
            _menuButton(
              context,
              title: 'Budaya',
              icon: Icons.museum,
              route: '/budaya',
            ),
            _menuButton(
              context,
              title: 'Kuliner',
              icon: Icons.restaurant,
              route: '/kuliner',
            ),
            _menuButton(
              context,
              title: 'Motor',
              icon: Icons.motorcycle,
              route: '/motor',
            ),
            _menuButton(
              context,
              title: 'Mobil',
              icon: Icons.directions_car,
              route: '/mobil',
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class MenuPage extends StatelessWidget {
  final String menuTitle;
  final IconData icon;
  final String imageUrl;
  final String title;
  final String description;

  const MenuPage({super.key, required this.menuTitle, required this.icon, required this.imageUrl, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(menuTitle)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(imageUrl),
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(description), 
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.blue,
            ),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            label: const Text('Kembali',style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        )
      ),
    );
  }
}