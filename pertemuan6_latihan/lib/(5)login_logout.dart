import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => const HalamanLogin(),
      '/home': (context) => const HalamanHome(),
    },
  ));
}

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final TextEditingController _usernameController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _masuk() {
    if (_usernameController.text.trim().isEmpty) {
      setState(() => _errorText = 'Username tidak boleh kosong');
      return;
    }
    setState(() => _errorText = null);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: const OutlineInputBorder(),
                  errorText: _errorText,
                ),
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _masuk,
                child: const Text('Masuk'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HalamanHome extends StatelessWidget {
  const HalamanHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
          child: const Text('Keluar'),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MaterialApp(
//     initialRoute: '/login',
//     routes: {
//       '/login': (context) => const HalamanLogin(),
//       '/home': (context) => const HalamanHome(),
//     },
//   ));
// }

// class HalamanLogin extends StatelessWidget {
//   const HalamanLogin({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
//           child: const Text('Masuk'),
//         ),
//       ),
//     );
//   }
// }

// class HalamanHome extends StatelessWidget {
//   const HalamanHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         automaticallyImplyLeading: false,
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               '/login',
//               (route) => false,
//             );
//           },
//           child: const Text('Keluar'),
//         ),
//       ),
//     );
//   }
// }
