import 'dart:convert'; // 📊 2. Untuk decode-encode data JSON

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 📊 1. Suntik library HTTP untuk koneksi DB

import 'dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sparepart Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: const Color(0xFF2563EB),
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false; // 📊 3. State untuk indikator loading muter-muter

  // 📊 4. FUNGSI UTAMA KONEKSI KE LARAVEL XAMPP LU
  Future<void> _handleLogin() async {
    if (_nikController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('NIK dan Password wajib diisi!', Colors.red);
      return;
    }

    setState(() => _isLoading = true); // Mulai loading animasi

    // Menggunakan IP 10.0.2.2 karena emulator Android membaca localhost laptop lewat IP ini
    final String url = 'http://10.0.2.2:8000/api/login'; 

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nim': _nikController.text, // 👈 Dioper sebagai 'nim' agar dibaca oleh DB XAMPP lu
          'password': _passwordController.text,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _showSnackBar(data['message'] ?? 'Login Berhasil!', Colors.green);
        
        // 🟢 AUTOMATED UPDATE: Ambil data object 'user' yang dikirim oleh API Laravel lu
        final userData = data['user'];

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardAdminPage(
                nik: _nikController.text,
                // 🟢 FIX ERROR FIXED: Dioper ke 'fullName' dan 'role' sesuai isi dashboard.dart terbaru lu
                fullName: userData != null ? userData['name'] : null, 
                role: userData != null ? userData['role'] : null, 
                profilePhotoPath: userData != null ? userData['profile_photo_path'] : null,
              ),
            ),
          );
        }
      } else {
        // 🔴 GAGAL: Akun salah / tidak terdaftar di DB XAMPP
        _showSnackBar(data['message'] ?? 'NIK atau Password salah, Bro!', Colors.red);
      }
    } catch (e) {
      // 🔴 ERROR SERVER: Laravel belum dijalankan / salah IP port
      _showSnackBar('Gagal terhubung ke server Laravel: $e', Colors.orange);
    } finally {
      if (mounted) setState(() => _isLoading = false); // Matikan loading animasi
    }
  }

  // Fungsi pembantu memunculkan snackbar adaptif warna
  void _showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color siixBlue = Color(0xFF1E40AF);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Stack(
        children: [
          // Background Lengkungan Biru Atas yang Presisi
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [siixBlue, Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 32),
                            // Header Logo & Judul Aplikasi
                            const Icon(Icons.blur_on, size: 72, color: Colors.white),
                            const SizedBox(height: 8),
                            const Text(
                              'SPAREPART MANAGEMENT SYSTEM',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'PT SIIX EMS KARAWANG',
                              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1),
                            ),
                            const SizedBox(height: 32),
                            
                            // Card Box Putih untuk Input Form
                            Card(
                              elevation: 6,
                              shadowColor: Colors.black12,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Welcome Back',
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: siixBlue),
                                    ),
                                    const Text(
                                      'SIGN IN TO YOUR ACCOUNT', 
                                      style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)
                                    ),
                                    const SizedBox(height: 24),
                                    
                                    // Label NIK
                                    const Text(
                                      'NIK',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: siixBlue.withOpacity(0.08),
                                            border: Border.all(color: Colors.black12),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12),
                                            ),
                                          ),
                                          child: const Icon(Icons.person_outline, color: siixBlue, size: 22),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 48,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFF9FAFB),
                                              border: Border(
                                                top: BorderSide(color: Colors.black12),
                                                right: BorderSide(color: Colors.black12),
                                                bottom: BorderSide(color: Colors.black12),
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                bottomRight: Radius.circular(12),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _nikController,
                                              keyboardType: TextInputType.number,
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                border: InputBorder.none,
                                                hintText: 'Masukkan NIK Anda',
                                                hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 18),
                                    
                                    // Label Password
                                    const Text(
                                      'PASSWORD',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: siixBlue.withOpacity(0.08),
                                            border: Border.all(color: Colors.black12),
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              bottomLeft: Radius.circular(12),
                                            ),
                                          ),
                                          child: const Icon(Icons.lock_outline, color: siixBlue, size: 22),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 48,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFF9FAFB),
                                              border: Border(
                                                top: BorderSide(color: Colors.black12),
                                                right: BorderSide(color: Colors.black12),
                                                bottom: BorderSide(color: Colors.black12),
                                              ),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                bottomRight: Radius.circular(12),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _passwordController,
                                              obscureText: _obscureText,
                                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
                                              decoration: InputDecoration(
                                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                border: InputBorder.none,
                                                hintText: 'Masukkan Password',
                                                hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                                    color: Colors.black38,
                                                    size: 20,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      _obscureText = !_obscureText;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 28),
                                    
                                    // Tombol Login Hijau Emerald Premium + Loading Adaptif
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF10B981),
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                          shadowColor: const Color(0xFF10B981).withOpacity(0.3),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: _isLoading 
                                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                                            : const Text(
                                                'LOGIN TO SYSTEM', 
                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const Spacer(), 
                            
                            // FOOTER LOGIN
                            const Column(
                              children: [
                                Text(
                                  '© 2026 PT SIIX EMS INDONESIA',
                                  style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.3),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Process Engineering Dept • Version 1.0.0',
                                  style: TextStyle(color: Colors.black38, fontSize: 10, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16), 
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}