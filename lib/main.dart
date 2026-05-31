import 'package:flutter/material.dart';

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

  void _handleLogin() {
    if (_nikController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('NIK dan Password wajib diisi!'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardAdminPage(
          nik: _nikController.text,
        ),
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
                      minHeight: constraints.maxHeight, // Mengunci tinggi layar minimal seukuran layar asli
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
                                    
                                    // Tombol Login Hijau Emerald Premium
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: ElevatedButton(
                                        onPressed: _handleLogin,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF10B981),
                                          foregroundColor: Colors.white,
                                          elevation: 2,
                                          shadowColor: const Color(0xFF10B981).withOpacity(0.3),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: const Text(
                                          'LOGIN TO SYSTEM', 
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Mendorong footer secara dinamis agar selalu di dasar layar bawah
                            const Spacer(), 
                            
                            // FIX: FOOTER LOGIN SEWAJARNYA & PREMIUM
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
                            const SizedBox(height: 16), // Jarak aman dari pinggiran bawah layar
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