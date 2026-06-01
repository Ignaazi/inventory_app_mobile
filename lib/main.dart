import 'dart:convert'; // Untuk decode-encode data JSON
import 'dart:ui'; // Wajib untuk efek Glassmorphism (Blur)

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Library HTTP koneksi DB

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
  bool _isLoading = false;

  // FUNGSI LOGIN API LARAVEL
  Future<void> _handleLogin() async {
    if (_nikController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('NIK dan Password wajib diisi!', Colors.redAccent);
      return;
    }

    setState(() => _isLoading = true);
    final String url = 'http://10.0.2.2:8000/api/login'; 

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nim': _nikController.text,
          'password': _passwordController.text,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _showSnackBar(data['message'] ?? 'Login Berhasil!', Colors.greenAccent);
        final userData = data['user'];

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardAdminPage(
                nik: _nikController.text,
                fullName: userData != null ? userData['name'] : null, 
                role: userData != null ? userData['role'] : null, 
                profilePhotoPath: userData != null ? userData['profile_photo_path'] : null,
              ),
            ),
          );
        }
      } else {
        _showSnackBar(data['message'] ?? 'NIK atau Password salah!', Colors.redAccent);
      }
    } catch (e) {
      _showSnackBar('Gagal terhubung ke server!', Colors.orangeAccent);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: color.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND GRADIENT (Biru, Putih, Pelangi Magic)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E40AF), // Biru Tua
                  Color(0xFF60A5FA), // Biru Muda
                  Colors.white,      // Putih
                  Color(0xFFE0E7FF), // Biru Pastel
                  Color(0xFFFDE68A), // Sentuhan Pelangi (Kuning Soft)
                  Color(0xFFFBCFE8), // Sentuhan Pelangi (Pink Soft)
                ],
                stops: [0.0, 0.3, 0.5, 0.7, 0.85, 1.0],
              ),
            ),
          ),

          // 2. MAIN CONTENT
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Gambar Isometrik SIIX
                    Image.asset(
                      'assets/loginpage.png',
                      height: 210, // Dikecilkan sedikit agar layout card punya ruang lebih luas
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),

                    // 3. GLASSMORPHISM CARD (Efek Transparan Kaca)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 🟢 ADJUSTMENT: Tulisan Login Dikecilkan Sedikit Sesuai Request
                              const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 24, // Dari 28 diturunkan ke 24 agar lebih proporsional
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF1E3A8A),
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 2),

                              // 🟢 TAMBAHAN BARU: Judul Panjang Dipaksa Tetap 1 Line Pakai FittedBox
                              const SizedBox(
                                width: double.infinity,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown, // Otomatis nge-scale mengecil kalau layar HP sempit
                                  child: Text(
                                    'SPAREPART MANAGEMENT SYSTEM',
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF1E40AF),
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ),
                              
                              const Text(
                                'Please sign in to continue',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 26),

                              // INPUT NIK (Integrated Linear Design)
                              _buildGlassInput(
                                controller: _nikController,
                                label: 'NIK Karyawan',
                                icon: Icons.person_outline,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 18),

                              // INPUT PASSWORD (Integrated Linear Design)
                              _buildGlassInput(
                                controller: _passwordController,
                                label: 'Password',
                                icon: Icons.lock_outline,
                                isPassword: true,
                                obscureText: _obscureText,
                                onToggle: () => setState(() => _obscureText = !_obscureText),
                              ),
                              const SizedBox(height: 28),

                              // 4. LOGIN BUTTON (3D Gradient Style)
                              Container(
                                width: double.infinity,
                                height: 52,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1E40AF).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    )
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // FOOTER
                    const Text(
                      'PT SIIX EMS INDONESIA',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const Text(
                      'Process Engineering Dept • Version 1.0.0',
                      style: TextStyle(color: Colors.black45, fontSize: 10),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET HELPER UNTUK INPUT GLASS STYLE
  Widget _buildGlassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggle,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black45, fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFF1E40AF), size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Colors.black38,
                    size: 18,
                  ),
                  onPressed: onToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}