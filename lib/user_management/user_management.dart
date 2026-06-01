import 'dart:convert'; // 📊 Untuk decode data JSON dari Laravel

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 📊 Untuk ambil data via API HTTP

import '../footer.dart';
// 📁 JALUR IMPORT GLOBAL (Menyesuaikan letak file karena berada di dalam sub-folder)
import '../header.dart';
import '../main.dart'; // Menghubungkan balik ke LoginPage jika user logout

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  int _selectedIndex = 0;
  bool _isDarkMode = false; 
  Future<List<dynamic>> _fetchUsers() async {
    const String url = 'http://10.0.2.2:8000/api/users';
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data is List ? data : (data['users'] ?? []);
      } else {
        throw Exception('Gagal memuat data dari server (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke jaringan: $e');
    }
  }

  // 🟢 FUNGSI BARU: Bikin inisial otomatis dari nama table DB (misal: Muhammad Ignazi -> MI)
  String _getInitial(String name) {
    if (name.isEmpty) return 'U';
    List<String> words = name.trim().split(' ');
    if (words.length > 1) {
      return (words[0][0] + words[1][0]).toUpperCase();
    }
    return words[0][0].toUpperCase();
  }

  // 🟢 FUNGSI BARU: Ambil warna acak/tetap untuk avatar berdasarkan role karyawan
  Color _getRoleColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'administrator':
      case 'admin':
        return const Color(0xFF1E40AF); // Deep Blue
      case 'engineering':
        return const Color(0xFF0EA5E9); // Sky Blue
      case 'production':
        return const Color(0xFF10B981); // Emerald Green
      case 'costing':
        return const Color(0xFFEAB308); // Amber Yellow
      default:
        return const Color(0xFF64748B); // Slate Grey
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 PALET WARNA ADAPTIF (Terikat penuh dengan state _isDarkMode di Header)
    final Color backgroundColor = _isDarkMode ? const Color(0xFF0B0F19) : const Color(0xFFF1F5F9); 
    final Color cardColor = _isDarkMode ? const Color(0xFF1E293B) : Colors.white; 
    final Color textPrimary = _isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A); 
    final Color textSecondary = _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B); 
    final Color borderColor = _isDarkMode ? const Color(0xFF334155).withOpacity(0.5) : const Color(0xFFE2E8F0); 
    const Color siixBlue = Color(0xFF1E40AF);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // 🛑 1. STICKY HEADER FIXED
          DashboardHeader(
            pageTitle: 'USER MANAGEMENT',
            isDarkMode: _isDarkMode,
            onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
            onLogout: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),

          // 📜 2. AREA DATA DENGAN ASYNC FUTUREBUILDER
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _fetchUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: siixBlue),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_off_rounded, size: 48, color: Colors.red.shade400),
                          const SizedBox(height: 12),
                          Text(
                            'Gagal Memuat Database\n${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textSecondary, fontSize: 13, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => setState(() {}),
                            icon: const Icon(Icons.refresh_rounded, size: 16),
                            label: const Text('Coba Lagi'),
                          )
                        ],
                      ),
                    ),
                  );
                }

                final usersList = snapshot.data ?? [];

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Link Minimalis ke Dashboard
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: siixBlue),
                            SizedBox(width: 6),
                            Text('Dashboard', style: TextStyle(color: siixBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Header List Title & Tombol Tambah Bulat (+) Minimalis
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DATABASE ACCOUNT',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 1.1),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total: ${usersList.length} Hak Akses Terdaftar',
                                style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          
                          // ➕ TOMBOL TAMBAH BULAT ICON
                          Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              color: siixBlue,
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: () => _showActionSnackbar('Mengarahkan ke halaman form Create User baru...'),
                              customBorder: const CircleBorder(),
                              child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Jika data di table kosong
                      if (usersList.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Text('Tidak ada user terdaftar di database.', style: TextStyle(color: textSecondary)),
                          ),
                        ),

                      // 📜 BUILDER LOOPING DATA ASLI KARYAWAN FROM API
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: usersList.length,
                        itemBuilder: (context, index) {
                          final user = usersList[index];
                          
                          // Mapping field DB XAMPP lu (ganti string key-nya sesuai column table mysql lu)
                          final String userNama = user['name'] ?? 'No Name';
                          final String userNik = user['nim'] ?? user['nik'] ?? '---';
                          final String userRole = user['role'] ?? 'Staff';
                          final String userInitial = _getInitial(userNama);
                          final Color userColor = _getRoleColor(userRole);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                              boxShadow: [
                                if (!_isDarkMode)
                                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))
                              ],
                            ),
                            child: Row(
                              children: [
                                // 👤 AVATAR IDENTITAS USER OTOMATIS
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: userColor.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      userInitial,
                                      style: TextStyle(color: userColor, fontWeight: FontWeight.w900, fontSize: 14),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                // 📝 INFORMASI REAL AKUN
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userNama,
                                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '$userRole  •  NIK: $userNik',
                                        style: TextStyle(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),

                                // 🛠️ TOMBOL AKSI CRUD BERBENTUK BULAT
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildRoundActionButton(
                                      icon: Icons.visibility_outlined,
                                      color: Colors.blue.shade600,
                                      onTap: () => _showActionSnackbar('Preview akun $userNama'),
                                    ),
                                    const SizedBox(width: 6),
                                    _buildRoundActionButton(
                                      icon: Icons.edit_outlined,
                                      color: Colors.amber.shade700,
                                      onTap: () => _showActionSnackbar('Membuka edit form untuk $userNama'),
                                    ),
                                    const SizedBox(width: 6),
                                    _buildRoundActionButton(
                                      icon: Icons.delete_outline_rounded,
                                      color: Colors.red.shade600,
                                      onTap: () => _showDeleteConfirmation(userNik, userNama),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // 🛑 3. STICKY FOOTER FIXED
      bottomNavigationBar: DashboardFooter(
        selectedIndex: _selectedIndex,
        isDarkMode: _isDarkMode,
        cardColor: cardColor,
        borderColor: borderColor,
        siixBlue: siixBlue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.pop(context);
          } else {
            Navigator.pop(context, index);
          }
        },
      ),
    );
  }

  // 🎴 HELPER WIDGET: Generator Tombol Bulat Aksi CRUD
  Widget _buildRoundActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  void _showActionSnackbar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Dialog Konfirmasi Hapus Data Akun (Dipetakan berdasarkan NIK/ID dari backend)
  void _showDeleteConfirmation(String nik, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        title: Text('Hapus Akun?', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
        content: Text('Yakin ingin menghapus data $nama dari database?', style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black87, fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal', style: TextStyle(color: Colors.grey))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showActionSnackbar('Fungsi backend delete untuk NIK $nik dipicu.');
              // Nanti lu bisa taruh fungsi http.post / http.delete di sini ke endpoint hapus user.
            }, 
            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent))
          ),
        ],
      ),
    );
  }
}