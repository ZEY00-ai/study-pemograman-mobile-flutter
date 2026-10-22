import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TextField Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const UserInputExample(),
    );
  }
}

class UserInputExample extends StatefulWidget {
  const UserInputExample({super.key});

  @override
  State<UserInputExample> createState() => _UserInputExampleState();
}

class _UserInputExampleState extends State<UserInputExample> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isSuccess = false;
  bool _hasSubmitted = false;

  String? _selectedGender; // null = belum dipilih
  final List<String> _genderList = ['Laki-laki', 'Perempuan'];

  String _resultMessage = "";
  String _currentUsername = "-";
  String _currentEmail = "-";
  String _currentGender = "-";

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _hasSubmitted = true;

      if (username.isEmpty) {
        _isSuccess = false;
        _resultMessage = "Peringatan: username tidak boleh kosong";
      } else if (password.length < 6) {
        _isSuccess = false;
        _resultMessage = "Peringatan: password minimal 6 karakter!";
      } else {
        _isSuccess = true;
        _resultMessage = "Selamat datang, $username";
        _currentUsername = username;
        _currentEmail = email.isEmpty ? "-" : email;
        _currentGender = _selectedGender ?? "-";
      }
    });
  }

  void _handleReset() {
    _usernameController.clear();
    _emailController.clear();
    _passwordController.clear();

    setState(() {
      _selectedGender = null;
      _isObscure = true;
      _isSuccess = false;
      _hasSubmitted = false;
      _resultMessage = "";
      _currentUsername = "-";
      _currentEmail = "-";
      _currentGender = "-";
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Formulir berhasil dibersihkan'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('user input example'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 350,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F8),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey.shade400, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Login Form',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),
                    const SizedBox(height: 20),

                    // textfield username
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'username',
                        hintText: 'masukan nama pengguna',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // textfield email
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'email',
                        hintText: 'masukan email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // pilihan jenis kelamin (radio)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade600),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'jenis kelamin',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          ..._genderList.map(
                            (g) => RadioListTile<String>(
                              title: Text(g),
                              value: g,
                              groupValue: _selectedGender,
                              dense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // textfield password
                    TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: 'password',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey.shade700,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // tombol login
                    ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2C4378),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('login', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // card hasil (animasi warna)
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: 350,
                padding: const EdgeInsets.all(16.8),
                decoration: BoxDecoration(
                  color: !_hasSubmitted
                      ? Colors.white
                      : (_isSuccess
                          ? Colors.green.shade100
                          : Colors.red.shade100),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: !_hasSubmitted
                        ? Colors.grey.shade400
                        : (_isSuccess ? Colors.green : Colors.red),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_hasSubmitted) ...[
                      Text(
                        _resultMessage,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isSuccess
                              ? Colors.green.shade900
                              : Colors.red.shade900,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (!_hasSubmitted || _isSuccess) ...[
                      _buildInfoRow('Username', _currentUsername),
                      _buildInfoRow('Email', _currentEmail),
                      _buildInfoRow('Jenis Kelamin', _currentGender),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleReset,
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}