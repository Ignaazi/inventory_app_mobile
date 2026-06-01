import 'dart:convert'; // 📊 Untuk decode data JSON dari Laravel

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 📊 Untuk ambil data via API HTTP

import '../footer.dart';
// 📁 JALUR IMPORT GLOBAL 
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

  // Inisial otomatis dari nama table DB
  String _getInitial(String name) {
    if (name.isEmpty) return 'U';
    List<String> words = name.trim().split(' ');
    if (words.length > 1) {
      return (words[0][0] + words[1][0]).toUpperCase();
    }
    return words[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 PALET WARNA BERSIH: PUTIH, BIRU TUA, BIRU MUDA (LIGHT) & UNGU INDIGO (DARK)
    final Color cardBackgroundColor = _isDarkMode ? const Color(0xFF1E1B4B).withOpacity(0.7) : Colors.white.withOpacity(0.85);
    final Color textPrimary = _isDarkMode ? Colors.white : const Color(0xFF1E3A8A); // Biru Tua Premium
    final Color textSecondary = _isDarkMode ? const Color(0xFFA5B4FC) : const Color(0xFF475569); // Abu-abu gelap / Biru muda kontras
    final Color customAccentBlue = const Color(0xFF2563EB); // Aksentuasi Utama (SIIX Blue Style)
    final Color borderColor = _isDarkMode ? const Color(0xFF4C1D95).withOpacity(0.4) : const Color(0xFFDBEAFE);

    return Scaffold(
      body: Stack(
        children: [
          // 🛑 1. BACKGROUND GRADIENT TIPIS (Pastel Rainbow Blue-White & Deep Indigo Purple)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isDarkMode
                    ? [
                        const Color(0xFF0F172A), // Midnight Slate
                        const Color(0xFF1E1B4B), // Deep Dark Purple Tipis
                        const Color(0xFF11101E), // Solid Dark Base
                      ]
                    : [
                        const Color(0xFFDBEAFE), // Biru Tua Pastel (Awal)
                        Colors.white,            // Putih Clean Dominan
                        const Color(0xFFEFF6FF), // Biru Muda Soft
                        const Color(0xFFE0E7FF), // Sentuhan Pelangi Indigo Light
                      ],
                stops: _isDarkMode ? [0.0, 0.6, 1.0] : [0.0, 0.35, 0.7, 1.0],
              ),
            ),
          ),

          // 🛑 2. MAIN INTERFACE CONTENT LAYER (MENTOK ATAS MENEMBUS STATUS BAR)
          Column(
            children: [
              // STICKY HEADER FIXED (Naik full melewati jam, baterai, wifi)
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

              // AREA DATA LIST KARYAWAN (Diproteksi dengan SafeArea top: false)
              Expanded(
                child: SafeArea(
                  top: false, // Menghilangkan margin kosong di antara header dan list konten
                  child: FutureBuilder<List<dynamic>>(
                    future: _fetchUsers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: _isDarkMode ? const Color(0xFFA855F7) : customAccentBlue,
                          ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Back Link Minimalis ke Dashboard
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: textPrimary),
                                  const SizedBox(width: 6),
                                  Text('Dashboard', style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Header List Title & Tombol Tambah
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'DATABASE ACCOUNT',
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 1.2),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Total: ${usersList.length} Hak Akses Terdaftar',
                                      style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                
                                // ➕ TOMBOL TAMBAH GRADIENT
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _isDarkMode ? const Color(0xFF311B92) : customAccentBlue,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: borderColor, width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      )
                                    ]
                                  ),
                                  child: InkWell(
                                    onTap: () => _showActionSnackbar('Mengarahkan ke halaman form Create User baru...'),
                                    customBorder: const CircleBorder(),
                                    child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            if (usersList.isEmpty)
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 40),
                                  child: Text('Tidak ada user terdaftar di database.', style: TextStyle(color: textSecondary)),
                                ),
                              ),

                            // 📜 ITEM CARD LIST 
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: usersList.length,
                              itemBuilder: (context, index) {
                                final user = usersList[index];
                                
                                final String userNama = user['name'] ?? 'No Name';
                                final String userNik = user['nim'] ?? user['nik'] ?? '---';
                                final String userRole = user['role'] ?? 'Staff';
                                final String userInitial = _getInitial(userNama);

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: cardBackgroundColor,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: borderColor, width: 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(_isDarkMode ? 0.2 : 0.03),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // 👤 AVATAR IDENTITAS
                                      Container(
                                        width: 46,
                                        height: 46,
                                        decoration: BoxDecoration(
                                          color: _isDarkMode ? const Color(0xFF11101E) : const Color(0xFFEFF6FF),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _isDarkMode ? const Color(0xFFA855F7) : customAccentBlue,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            userInitial,
                                            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w900, fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      
                                      // 📝 INFORMASI REAL AKUN
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userNama,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w900),
                                            ),
                                            const SizedBox(height: 3),
                                            Text(
                                              '$userRole  •  NIK: $userNik',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 4),

                                      // 🛠️ TOMBOL AKSI CRUD BERWARNA SENADA
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _buildRoundActionButton(
                                            icon: Icons.visibility_outlined,
                                            color: _isDarkMode ? const Color(0xFFA5B4FC) : textPrimary,
                                            onTap: () => _showActionSnackbar('Preview akun $userNama'),
                                          ),
                                          const SizedBox(width: 6),
                                          _buildRoundActionButton(
                                            icon: Icons.edit_outlined,
                                            color: _isDarkMode ? const Color(0xFFA855F7) : customAccentBlue,
                                            onTap: () => _showActionSnackbar('Membuka edit form untuk $userNama'),
                                          ),
                                          const SizedBox(width: 6),
                                          _buildRoundActionButton(
                                            icon: Icons.delete_outline_rounded,
                                            color: Colors.redAccent,
                                            onTap: () => _showDeleteConfirmation(userNik, userNama, borderColor, textPrimary),
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
              ),
            ],
          ),
        ],
      ),

      // 🛑 3. STICKY FOOTER FIXED (Garis Lurus Solid)
      bottomNavigationBar: DashboardFooter(
        selectedIndex: _selectedIndex,
        isDarkMode: _isDarkMode,
        cardColor: _isDarkMode ? const Color(0xFF1E1B4B) : Colors.white,
        borderColor: borderColor,
        siixBlue: customAccentBlue,
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

  // 🎴 HELPER WIDGET: Custom Pad Bulat untuk Tombol CRUD Aksi
  Widget _buildRoundActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: _isDarkMode ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
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
        content: Text(message, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDeleteConfirmation(String nik, String nama, Color currentBorder, Color currentText) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1E1B4B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: currentBorder)),
        title: Text('Hapus Akun?', style: TextStyle(color: currentText, fontSize: 16, fontWeight: FontWeight.w900)),
        content: Text('Yakin ingin menghapus data $nama dari database?', style: TextStyle(color: currentText.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w600)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showActionSnackbar('Fungsi backend delete untuk NIK $nik dipicu.');
            }, 
            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );
  }
}