import 'dart:ui'; // 🧠 Wajib di-import untuk menghasilkan efek blur kaca (Glassmorphism)

import 'package:flutter/material.dart';

import 'costing/costing.dart';
import 'engineering/engineering.dart';
import 'footer.dart';
import 'header.dart';
import 'lihat_semua/lihat_semua.dart';
import 'main.dart';
import 'monitoring/monitoring.dart';
import 'production/production.dart';
import 'scanner.dart';
import 'system_logs/system_logs.dart';
import 'user_management/user_management.dart';

class DashboardAdminPage extends StatefulWidget {
  final String nik;
  final String? fullName;
  final String? role;
  final String? profilePhotoPath;

  const DashboardAdminPage({
    super.key, 
    required this.nik,
    this.fullName, 
    this.role,     
    this.profilePhotoPath,
  });

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
    // 🎨 PALET WARNA ELEMENT (Disesuaikan agar teks tetap terbaca tajam di atas kaca transparan)
    final Color sectionTitleColor = _isDarkMode ? const Color(0xFFE2E8F0) : const Color(0xFF1E3A8A);
    final Color textPrimary = _isDarkMode ? Colors.white : const Color(0xFF1E3A8A); 
    final Color textSecondary = _isDarkMode ? const Color(0xFFA5B4FC) : const Color(0xFF475569); 
    final Color borderColor = _isDarkMode ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.4); 
    final Color glassColor = _isDarkMode ? Colors.black.withOpacity(0.25) : Colors.white.withOpacity(0.25);

    const Color siixBlue = Color(0xFF1E40AF); 

    final List<Widget> pages = [
      _buildOverviewContent(sectionTitleColor, siixBlue, glassColor, textPrimary, borderColor, textSecondary), 
      ScannerPage(isDarkMode: _isDarkMode), 
      _buildPlaceholderContent(glassColor, borderColor, textSecondary), 
      _buildPlaceholderContent(glassColor, borderColor, textSecondary), 
    ];

    return Scaffold(
      body: Stack(
        children: [
          // 🛑 1. BACKGROUND DYNAMIC GRADIENT (Light: Pelangi Biru | Dark: Neon Purple Indigo)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isDarkMode
                    ? [
                        const Color(0xFF0F172A), // Midnight Dark
                        const Color(0xFF311B92), // Deep Purple
                        const Color(0xFF1E1B4B), // Indigo Tua
                        const Color(0xFF4A148C), // Royal Purple Accent
                      ]
                    : [
                        const Color(0xFF1E40AF), // Biru Tua
                        const Color(0xFF60A5FA), // Biru Muda
                        Colors.white,            // Putih Clean
                        const Color(0xFFE0E7FF), // Indigo Light
                        const Color(0xFFFDE68A), // Pelangi Kuning Soft
                        const Color(0xFFFBCFE8), // Pelangi Pink Soft
                      ],
                stops: _isDarkMode ? [0.0, 0.4, 0.7, 1.0] : [0.0, 0.25, 0.45, 0.65, 0.8, 1.0],
              ),
            ),
          ),

          // 🛑 2. MAIN INTERFACE CONTENT LAYER (GARIS LURUS MENTOK ATAS)
          Column( // 🟢 MODIFIKASI: Mengganti SafeArea terluar dengan Column biasa agar Header menembus batas atas HP
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
                userName: widget.fullName,         
                userRole: widget.role,             
                userNim: widget.nik,               
                profilePhotoPath: widget.profilePhotoPath, 
              ),
              
              // 🟢 MODIFIKASI: Membungkus area isi konten dengan SafeArea khusus (Hanya memproteksi area bawah/samping jika diperlukan)
              Expanded(
                child: SafeArea(
                  top: false, // 🟢 KUNCI UTAMA: Mematikan proteksi atas agar konten menempel pas di bawah header flat
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: pages,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: DashboardFooter(
        selectedIndex: _selectedIndex,
        isDarkMode: _isDarkMode,
        cardColor: _isDarkMode ? const Color(0xFF111827).withOpacity(0.9) : Colors.white.withOpacity(0.9),
        borderColor: borderColor,
        siixBlue: _isDarkMode ? const Color(0xFFA855F7) : siixBlue, 
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  // ==================== MAIN OVERVIEW CONTENT (GLASS STYLE) ====================
  Widget _buildOverviewContent(Color sectionTitleColor, Color siixBlue, Color glassColor, Color textPrimary, Color borderColor, Color textSecondary) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                _buildSlideCard3DFull(Icons.shield_rounded, 'NIK: ${widget.nik}', 'Otorisasi: ${widget.role ?? "Super Admin"} Level', _isDarkMode ? [const Color(0xFF6B21A8), const Color(0xFF1E1B4B)] : [const Color(0xFF1E40AF), const Color(0xFF3B82F6)]),
                _buildSlideCard3DFull(Icons.verified_user_rounded, 'Sistem Koneksi', 'Status: SAP Database Terhubung', _isDarkMode ? [const Color(0xFF03493E), const Color(0xFF0F172A)] : [const Color(0xFF10B981), const Color(0xFF059669)]),
                _buildSlideCard3DFull(Icons.developer_mode_rounded, 'App Environment', 'Mode: Production Verified', _isDarkMode ? [const Color(0xFF701A75), const Color(0xFF1E1B4B)] : [const Color(0xFFF59E0B), const Color(0xFFD97706)]),
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
                color: _currentPage == index ? (_isDarkMode ? const Color(0xFFA855F7) : siixBlue) : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            )),
          ),
          
          const SizedBox(height: 24),
          
          // 📱 MAIN CONTROL GRID
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'MAIN CONTROL SYSTEM',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: sectionTitleColor, letterSpacing: 1.2),
            ),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  decoration: BoxDecoration(
                    color: glassColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: borderColor, width: 1.2),
                  ),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), 
                    crossAxisCount: 4, 
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.85, 
                    children: [
                      _customGridItem(Icons.manage_accounts_rounded, 'User Management', _isDarkMode ? const Color(0xFF9333EA) : const Color(0xFF2563EB), textPrimary, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserManagementPage()));
                      }),
                      _customGridItem(Icons.analytics_rounded, 'Monitoring All', const Color(0xFFF97316), textPrimary, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringAllPage()));
                      }),
                      _customGridItem(Icons.engineering_rounded, 'Engineering', const Color(0xFF0EA5E9), textPrimary, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EngineeringPage()));
                      }),
                      _customGridItem(Icons.precision_manufacturing_rounded, 'Production', const Color(0xFF10B981), textPrimary, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProductionPage()));
                      }),
                      _customGridItem(Icons.monetization_on_rounded, 'Costing', const Color(0xFFEAB308), textPrimary, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CostingPage()));
                      }),
                      _customGridItem(Icons.qr_code_scanner_rounded, 'Scan Matrix', _isDarkMode ? const Color(0xFFC084FC) : const Color(0xFF8B5CF6), textPrimary, () {
                        setState(() { _selectedIndex = 1; }); 
                      }),
                      _customGridItem(Icons.history_toggle_off_rounded, 'System Logs', const Color(0xFFF43F5E), textPrimary, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SystemLogsPage()));
                      }),
                      _customGridItem(Icons.grid_view_rounded, 'Lihat Semua', const Color(0xFF64748B), textPrimary, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LihatSemuaPage()));
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderContent(Color glassColor, Color borderColor, Color textSecondary) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: glassColor, 
                borderRadius: BorderRadius.circular(24), 
                border: Border.all(color: borderColor, width: 1.2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.construction_rounded, size: 44, color: textSecondary),
                  const SizedBox(height: 14),
                  Text(
                    'Modul UI ${_pageTitles[_selectedIndex]}\nsedang disinkronisasikan.', 
                    textAlign: TextAlign.center, 
                    style: TextStyle(fontSize: 13, color: textSecondary, height: 1.4, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isDarkMode ? 0.4 : 0.15), 
              blurRadius: 10, 
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5)),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.2)),
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

  Widget _customGridItem(IconData icon, String title, Color itemColor, Color textPrimary, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48, 
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [itemColor, itemColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14), 
              boxShadow: [
                BoxShadow(
                  color: itemColor.withOpacity(0.25), 
                  blurRadius: 8, 
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(child: Icon(icon, size: 22, color: Colors.white)),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: -0.3, height: 1.1),
            ),
          ),
        ],
      ),
    );
  }
}