import 'package:flutter/material.dart';

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
  int _selectedIndex = 0; // State index internal footer
  bool _isDarkMode = false; // ⚡ DEFAULT: Light Mode (Sesuai request lu, kontrol di header)

  // 📦 SEEDER DATA DUMMY: 4 Role Utama Sesuai Kebutuhan Internal PT Lu
  final List<Map<String, String>> _usersList = [
    {
      'nama': 'Muhammad Ignazi',
      'nik': 'SX-202601',
      'role': 'Administrator',
      'pass': 'admin123#',
      'initial': 'MI',
      'color': '0xFF1E40AF' // Deep Blue
    },
    {
      'nama': 'Eko Prasetyo',
      'nik': 'SX-202605',
      'role': 'Engineering',
      'pass': 'engpass2026',
      'initial': 'EP',
      'color': '0xFF0EA5E9' // Sky Blue
    },
    {
      'nama': 'Siti Rahmawati',
      'nik': 'SX-202609',
      'role': 'Production',
      'pass': 'prodliner77',
      'initial': 'SR',
      'color': '0xFF10B981' // Emerald Green
    },
    {
      'nama': 'Ahmad Fauzi',
      'nik': 'SX-202612',
      'role': 'Costing',
      'pass': 'costingsecured',
      'initial': 'AF',
      'color': '0xFFEAB308' // Amber Yellow
    },
  ];

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
          // 🛑 1. STICKY HEADER FIXED (Mengontrol saklar tema global/lokal)
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

          // 📜 2. SCROLLABLE AREA DATA
          Expanded(
            child: SingleChildScrollView(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // ⚡ FIXED: Sudah memakai spaceBetween resmi Flutter
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
                            'Total: ${_usersList.length} Hak Akses Terdaftar',
                            style: TextStyle(fontSize: 11, color: textSecondary, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      
                      // ➕ TOMBOL TAMBAH BULAT ICON (Untuk dialihkan ke page pendaftaran baru nanti)
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

                  // 📜 BUILDER LOOPING DATA KARYAWAN
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _usersList.length,
                    itemBuilder: (context, index) {
                      final user = _usersList[index];
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
                            // 👤 AVATAR IDENTITAS USER (BULAT)
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Color(int.parse(user['color']!)).withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  user['initial']!,
                                  style: TextStyle(color: Color(int.parse(user['color']!)), fontWeight: FontWeight.w900, fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            // 📝 KUMPULAN INFORMASI DETAIL AKUN
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['nama']!,
                                    style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${user['role']}  •  NIK: ${user['nik']}',
                                    style: TextStyle(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Pass: ${user['pass']}',
                                    style: TextStyle(color: textSecondary.withOpacity(0.7), fontSize: 11, fontFamily: 'monospace'),
                                  ),
                                ],
                              ),
                            ),

                            // 🛠️ TOMBOL AKSI CRUD BERBENTUK BULAT (Preview, Edit, Delete)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 👁️ 1. PREVIEW DATA
                                _buildRoundActionButton(
                                  icon: Icons.visibility_outlined,
                                  color: Colors.blue.shade600,
                                  onTap: () => _showActionSnackbar('Preview akun ${user['nama']}'),
                                ),
                                const SizedBox(width: 6),
                                
                                // ✏️ 2. EDIT DATA
                                _buildRoundActionButton(
                                  icon: Icons.edit_outlined,
                                  color: Colors.amber.shade700,
                                  onTap: () => _showActionSnackbar('Membuka edit form untuk ${user['nama']}'),
                                ),
                                const SizedBox(width: 6),
                                
                                // 🗑️ 3. DELETE DATA
                                _buildRoundActionButton(
                                  icon: Icons.delete_outline_rounded,
                                  color: Colors.red.shade600,
                                  onTap: () => _showDeleteConfirmation(index, user['nama']!),
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
            ),
          ),
        ],
      ),

      // 🛑 3. STICKY FOOTER FIXED (Komunikasi dua arah balik ke dashboard)
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
            // Jika diklik Home (Overview), langsung tutup page dan kembali ke dashboard
            Navigator.pop(context);
          } else {
            // ⚡ TRICK BACKWARD INDEX: Tutup page user_management sambil mengirim perintah pindah index tab ke dashboard
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
        color: color.withOpacity(0.1), // Efek background pudar sewarna ikon
        shape: BoxShape.circle,
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }

  // Snack Bar Notifikasi Trigger Aksi
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

  // Dialog Konfirmasi Hapus Data Akun
  void _showDeleteConfirmation(int index, String nama) {
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
              setState(() { _usersList.removeAt(index); });
              Navigator.pop(context);
              _showActionSnackbar('Akun $nama sukses dihapus!');
            }, 
            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent))
          ),
        ],
      ),
    );
  }
}