import 'package:flutter/material.dart';

import 'costing/costing.dart';
import 'engineering/engineering.dart';
// Import komponen dasar bawaan proyek lu
import 'footer.dart';
import 'header.dart';
import 'lihat_semua/lihat_semua.dart';
import 'main.dart';
import 'monitoring/monitoring.dart';
import 'production/production.dart';
import 'scanner.dart'; // Tetap di folder luar bersama dashboard
import 'system_logs/system_logs.dart';
// 📁 JALUR IMPORT BARU SESUAI FOLDER MASING-MASING
import 'user_management/user_management.dart';

class DashboardAdminPage extends StatefulWidget {
  final String nik;

  const DashboardAdminPage({super.key, required this.nik});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _selectedIndex = 0;
  bool _isDarkMode = false; 
  final PageController _pageController = PageController(viewportFraction: 1.0); 
  int _currentPage = 0; 

  final List<String> _pageTitles = [
    'OVERVIEW SYSTEM',
    'SCANNER MATRIX',
    'LOG HISTORY',
    'SYSTEM SETTINGS',
  ];

  @override
  void dispose() {
    _pageController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _isDarkMode ? const Color(0xFF0B0F19) : const Color(0xFFF4F7FA); 
    final Color cardColor = _isDarkMode ? const Color(0xFF1E293B) : Colors.white; 
    final Color sectionTitleColor = _isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final Color textPrimary = _isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B); 
    final Color textSecondary = _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B); 
    final Color borderColor = _isDarkMode ? const Color(0xFF334155).withOpacity(0.5) : const Color(0xFFE2E8F0); 

    const Color siixBlue = Color(0xFF1E40AF); 

    final List<Widget> pages = [
      _buildOverviewContent(sectionTitleColor, siixBlue, cardColor, textPrimary, borderColor), 
      ScannerPage(isDarkMode: _isDarkMode), 
      _buildPlaceholderContent(cardColor, borderColor, textSecondary), 
      _buildPlaceholderContent(cardColor, borderColor, textSecondary), 
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          DashboardHeader(
            pageTitle: _pageTitles[_selectedIndex],
            isDarkMode: _isDarkMode,
            onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
            onLogout: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: DashboardFooter(
        selectedIndex: _selectedIndex,
        isDarkMode: _isDarkMode,
        cardColor: cardColor,
        borderColor: borderColor,
        siixBlue: siixBlue,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  // ==================== MAIN OVERVIEW CONTENT ====================
  Widget _buildOverviewContent(Color sectionTitleColor, Color siixBlue, Color cardColor, Color textPrimary, Color borderColor) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 💳 SLIDE CARD INFORMASI OTORISASI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'INFORMASI OTORISASI',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: sectionTitleColor, letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 12),
          
          SizedBox(
            height: 125,
            child: PageView(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (int page) => setState(() => _currentPage = page),
              children: [
                _buildSlideCard3DFull(Icons.shield_rounded, 'NIK: ${widget.nik}', 'Otorisasi: Super Admin Level', _isDarkMode ? [const Color(0xFF1E40AF), const Color(0xFF0F172A)] : [const Color(0xFF1E40AF), const Color(0xFF3B82F6)]),
                _buildSlideCard3DFull(Icons.verified_user_rounded, 'Sistem Koneksi', 'Status: SAP Database Terhubung', _isDarkMode ? [const Color(0xFF065F46), const Color(0xFF0F172A)] : [const Color(0xFF10B981), const Color(0xFF059669)]),
                _buildSlideCard3DFull(Icons.developer_mode_rounded, 'App Environment', 'Mode: Production Verified', _isDarkMode ? [const Color(0xFF7C2D12), const Color(0xFF0F172A)] : [const Color(0xFFF59E0B), const Color(0xFFD97706)]),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3.0),
              height: 5,
              width: _currentPage == index ? 14 : 5, 
              decoration: BoxDecoration(
                color: _currentPage == index ? (_isDarkMode ? Colors.blue.shade400 : siixBlue) : (_isDarkMode ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(10),
              ),
            )),
          ),
          
          const SizedBox(height: 28),
          
          // 📱 MAIN CONTROL GRID (8 KOTAK REQUEST LU)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'MAIN CONTROL SYSTEM',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: sectionTitleColor, letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), 
              crossAxisCount: 4, // Pas 4 kotak ke samping, jadi 2 baris kebawah kebuka semua
              crossAxisSpacing: 8,
              mainAxisSpacing: 20,
              childAspectRatio: 0.82, 
              children: [
                // 1. User Management
                _customGridItem(Icons.manage_accounts_rounded, 'User Management', const Color(0xFF2563EB), cardColor, textPrimary, borderColor, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementPage()));
                }),
                // 2. Monitoring All
                _customGridItem(Icons.analytics_rounded, 'Monitoring All', const Color(0xFFF97316), cardColor, textPrimary, borderColor, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringAllPage()));
                }),
                // 3. Engineering
                _customGridItem(Icons.engineering_rounded, 'Engineering', const Color(0xFF0EA5E9), cardColor, textPrimary, borderColor, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EngineeringPage()));
                }),
                // 4. Production
                _customGridItem(Icons.precision_manufacturing_rounded, 'Production', const Color(0xFF10B981), cardColor, textPrimary, borderColor, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductionPage()));
                }),
                // 5. Costing
                _customGridItem(Icons.monetization_on_rounded, 'Costing', const Color(0xFFEAB308), cardColor, textPrimary, borderColor, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CostingPage()));
                }),
                // 6. Scan (Pindah Tab Scanner Utama)
                _customGridItem(Icons.qr_code_scanner_rounded, 'Scan', const Color(0xFF8B5CF6), cardColor, textPrimary, borderColor, () {
                  setState(() { _selectedIndex = 1; }); // Langsung ganti tab bawah ke scanner
                }),
                // 7. System Logs
                _customGridItem(Icons.history_toggle_off_rounded, 'System Logs', const Color(0xFFF43F5E), cardColor, textPrimary, borderColor, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SystemLogsPage()));
                }),
                // 8. Lihat Semua
                _customGridItem(Icons.grid_view_rounded, 'Lihat Semua', const Color(0xFF64748B), cardColor, textPrimary, borderColor, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LihatSemuaPage()));
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent(Color cardColor, Color borderColor, Color textSecondary) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.6, 
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction_rounded, size: 48, color: textSecondary.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text('Modul UI ${_pageTitles[_selectedIndex]}\nsedang disinkronisasikan.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: textSecondary, height: 1.4, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideCard3DFull(IconData icon, String title, String subtitle, List<Color> gradientColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), 
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, top: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [_isDarkMode ? BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 6)) : BoxShadow(color: gradientColors[0].withOpacity(0.3), blurRadius: 14, offset: const Offset(0, 6))],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5)),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.2)),
                    const SizedBox(height: 4),
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customGridItem(IconData icon, String title, Color itemColor, Color cardColor, Color textPrimary, Color borderColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52, 
            height: 52,
            decoration: BoxDecoration(
              color: _isDarkMode ? itemColor.withOpacity(0.85) : itemColor,
              borderRadius: BorderRadius.circular(16), 
              boxShadow: [BoxShadow(color: itemColor.withOpacity(_isDarkMode ? 0.3 : 0.18), blurRadius: 10, offset: const Offset(0, 4))]
            ),
            child: Center(child: Icon(icon, size: 24, color: Colors.white)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textPrimary, letterSpacing: -0.2, height: 1.1),
            ),
          ),
        ],
      ),
    );
  }
}