import 'package:flutter/material.dart';

import '../costing/costing.dart';
import '../engineering/engineering.dart';
import '../footer.dart';
// 📁 JALUR IMPORT GLOBAL (Menggunakan '../' karena file ini berada di dalam sub-folder)
import '../header.dart';
import '../main.dart'; // Untuk navigasi balik ke LoginPage saat logout
import '../monitoring/monitoring.dart';
import '../production/production.dart';
import '../system_logs/system_logs.dart';
// Import sub-page lainnya jika user mengklik menu dari sini
import '../user_management/user_management.dart';

class LihatSemuaPage extends StatefulWidget {
  const LihatSemuaPage({super.key});

  @override
  State<LihatSemuaPage> createState() => _LihatSemuaPageState();
}

class _LihatSemuaPageState extends State<LihatSemuaPage> {
  int _selectedIndex = 0; // State index internal footer (Default ke Overview/Home jika pop)
  bool _isDarkMode = false; // ⚡ DEFAULT: Light Mode (Kontrol penuh dari header)

  @override
  Widget build(BuildContext context) {
    // 🎨 PALET WARNA ADAPTIF SINKRON SANGAT TIPIS SEPERTI USER MANAGEMENT
    final Color cardColor = _isDarkMode ? const Color(0xFF1E1B4B).withOpacity(0.7) : Colors.white.withOpacity(0.85);
    final Color textPrimary = _isDarkMode ? Colors.white : const Color(0xFF1E3A8A);
    final Color textSecondary = _isDarkMode ? const Color(0xFFA5B4FC) : const Color(0xFF475569);
    final Color borderColor = _isDarkMode ? const Color(0xFF4C1D95).withOpacity(0.4) : const Color(0xFFDBEAFE);
    final Color dividerColor = _isDarkMode ? const Color(0xFF334155).withOpacity(0.6) : const Color(0xFFE2E8F0);
    const Color siixBlue = Color(0xFF1E40AF);

    return Scaffold(
      body: Stack(
        children: [
          // 🛑 1. BACKGROUND GRADIENT TIPIS (Match Sempurna dengan Tema Utama)
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
                        const Color(0xFFDBEAFE), // Biru Tua Pastel
                        Colors.white,            // Putih Clean Dominan
                        const Color(0xFFEFF6FF), // Biru Muda Soft
                        const Color(0xFFE0E7FF), // Sentuhan Pelangi Indigo Light
                      ],
                stops: _isDarkMode ? const [0.0, 0.6, 1.0] : const [0.0, 0.35, 0.7, 1.0],
              ),
            ),
          ),

          // 🛑 2. MAIN INTERFACE LAYER (MENTOK ATAS MENEMBUS STATUS BAR)
          Column(
            children: [
              // STICKY HEADER (Full ke atas melewati jam/baterai)
              DashboardHeader(
                pageTitle: 'SEMUA FITUR SYSTEM',
                isDarkMode: _isDarkMode,
                onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
                onLogout: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),

              // 📜 SCROLLABLE AREA (Desain Menu Vertikal Tetap Sesuai Konsep Bawaan Lu)
              Expanded(
                child: SafeArea(
                  top: false, // Mematikan padding atas agar menempel pas di bawah lengkungan header
                  child: SingleChildScrollView(
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
                              Text('Dashboard Kembali', style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ==================== CATEGORY 1: TRANSAKSI & OPERASIONAL ====================
                        _buildCategorySection(
                          title: 'Transaksi & Operasional',
                          textPrimary: textPrimary,
                          dividerColor: dividerColor,
                          children: [
                            _buildMenuGridItem(Icons.qr_code_scanner_rounded, 'Scan Matrix', const Color(0xFF0EA5E9), cardColor, textPrimary, borderColor, () {
                              Navigator.pop(context, 1); // Melempar index 1 untuk langsung buka tab Scanner di Dashboard
                            }),
                            _buildMenuGridItem(Icons.precision_manufacturing_rounded, 'Production', const Color(0xFF10B981), cardColor, textPrimary, borderColor, () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductionPage()));
                            }),
                            _buildMenuGridItem(Icons.engineering_rounded, 'Engineering', const Color(0xFF6366F1), cardColor, textPrimary, borderColor, () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const EngineeringPage()));
                            }),
                            _buildMenuGridItem(Icons.analytics_rounded, 'Monitoring All', const Color(0xFFF97316), cardColor, textPrimary, borderColor, () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringAllPage()));
                            }),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ==================== CATEGORY 2: FINANCE & COSTING ====================
                        _buildCategorySection(
                          title: 'Finance & Costing',
                          textPrimary: textPrimary,
                          dividerColor: dividerColor,
                          children: [
                            _buildMenuGridItem(Icons.monetization_on_rounded, 'Costing Rate', const Color(0xFFEAB308), cardColor, textPrimary, borderColor, () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CostingPage()));
                            }),
                            _buildMenuGridItem(Icons.receipt_long_rounded, 'Invoice Check', const Color(0xFFEC4899), cardColor, textPrimary, borderColor, () {
                              _showFeatureSnackbar(context, 'Modul UI Invoice Check sedang disinkronisasikan.');
                            }),
                            _buildMenuGridItem(Icons.calculate_rounded, 'Budgeting Plan', const Color(0xFF14B8A6), cardColor, textPrimary, borderColor, () {
                              _showFeatureSnackbar(context, 'Modul UI Budgeting Plan sedang disinkronisasikan.');
                            }),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ==================== CATEGORY 3: KELOLA ACCOUNT ====================
                        _buildCategorySection(
                          title: 'Kelola Akun',
                          textPrimary: textPrimary,
                          dividerColor: dividerColor,
                          children: [
                            _buildMenuGridItem(Icons.manage_accounts_rounded, 'User Management', const Color(0xFF2563EB), cardColor, textPrimary, borderColor, () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementPage()));
                            }),
                            _buildMenuGridItem(Icons.admin_panel_settings_rounded, 'Hak Akses', const Color(0xFF64748B), cardColor, textPrimary, borderColor, () {
                              _showFeatureSnackbar(context, 'Modul UI Otorisasi Hak Akses sedang disinkronisasikan.');
                            }),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // ==================== CATEGORY 4: LOGS & SECURITY ====================
                        _buildCategorySection(
                          title: 'Logs & Security',
                          textPrimary: textPrimary,
                          dividerColor: dividerColor,
                          children: [
                            _buildMenuGridItem(Icons.history_toggle_off_rounded, 'System Logs', const Color(0xFFF43F5E), cardColor, textPrimary, borderColor, () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SystemLogsPage()));
                            }),
                            _buildMenuGridItem(Icons.security_rounded, 'Database Security', const Color(0xFF8B5CF6), cardColor, textPrimary, borderColor, () {
                              _showFeatureSnackbar(context, 'Modul UI Database Security sedang disinkronisasikan.');
                            }),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      // 🛑 3. STICKY FOOTER FIXED (Komunikasi dua arah balik ke dashboard)
      bottomNavigationBar: DashboardFooter(
        selectedIndex: _selectedIndex,
        isDarkMode: _isDarkMode,
        cardColor: _isDarkMode ? const Color(0xFF1E1B4B) : Colors.white,
        borderColor: borderColor,
        siixBlue: siixBlue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          if (index == 0) {
            Navigator.pop(context); // Balik ke Home Dashboard utama
          } else {
            Navigator.pop(context, index); // Tutup page sambil oper index tab (Scan/Logs/Settings) ke dashboard utama
          }
        },
      ),
    );
  }

  // 🧱 WIDGET KATEGORI GRUP (Bikin garis pembatas horizontal adaptif tema)
  Widget _buildCategorySection({required String title, required Color textPrimary, required Color dividerColor, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 0.5),
          ),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4, // 4 kotak sejajar ke samping tetap dipertahankan
          crossAxisSpacing: 10,
          mainAxisSpacing: 16,
          childAspectRatio: 0.82,
          children: children,
        ),
        const SizedBox(height: 12),
        Divider(color: dividerColor, thickness: 1), // Garis pembatas berubah adaptif sesuai tema light/dark
      ],
    );
  }

  // 📱 GENERATOR GRID ITEM MENU UTAMA (Bulat Luwes Modern)
  Widget _buildMenuGridItem(IconData icon, String title, Color itemColor, Color cardColor, Color textPrimary, Color borderColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _isDarkMode ? itemColor.withOpacity(0.85) : itemColor,
              shape: BoxShape.circle, // Tetap lingkaran bulat penuh super estetik
              boxShadow: [
                BoxShadow(
                  color: itemColor.withOpacity(_isDarkMode ? 0.25 : 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Center(child: Icon(icon, size: 24, color: Colors.white)),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textPrimary, letterSpacing: -0.2, height: 1.1),
          ),
        ],
      ),
    );
  }

  void _showFeatureSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}