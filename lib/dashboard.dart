import 'package:flutter/material.dart';

import 'main.dart'; // Menghubungkan balik ke LoginPage saat logout

class DashboardAdminPage extends StatefulWidget {
  final String nik;

  const DashboardAdminPage({super.key, required this.nik});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _selectedIndex = 0;
  bool _isDarkMode = false; // State untuk melacak mode aktif (Light / Dark)
  final PageController _pageController = PageController(viewportFraction: 1.0); // LOCKED 1.0: Full lebar tanpa intipan slide lain
  int _currentPage = 0; // State untuk melacak posisi slide yang aktif

  final List<String> _pageTitles = [
    'OVERVIEW SYSTEM',
    'SCANNER MATRIX',
    'LOG HISTORY',
    'SYSTEM SETTINGS',
  ];

  @override
  void dispose() {
    _pageController.dispose(); // Membersihkan controller saat widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 💡 SYSTEM THEME: Palet Warna Kedalaman Tinggi yang Dioptimalkan
    final Color backgroundColor = _isDarkMode ? const Color(0xFF0B0F19) : const Color(0xFFF4F7FA); 
    final Color cardColor = _isDarkMode ? const Color(0xFF1E293B) : Colors.white; 
    
    // Warna teks section disesuaikan agar menjadi hitam pekat di light mode, dan putih di dark mode
    final Color sectionTitleColor = _isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final Color textPrimary = _isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B); 
    final Color textSecondary = _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B); 
    final Color borderColor = _isDarkMode ? const Color(0xFF334155).withOpacity(0.5) : const Color(0xFFE2E8F0); 

    const Color siixBlue = Color(0xFF1E40AF); 

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // 🛑 1. STICKY HEADER GRADIENT WITH USER AVATAR & NOTIFICATION
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12, 
              bottom: 16,
              left: 20,
              right: 16, 
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isDarkMode 
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFF1E40AF), const Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: _isDarkMode ? Colors.black.withOpacity(0.4) : const Color(0xFF1E40AF).withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // 👤 ICON MUKA USER (KOSONGAN BERGAYA MODERN)
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
                        ),
                        child: Icon(
                          Icons.person_rounded, 
                          color: Colors.white.withOpacity(0.9), 
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Bagian Teks Admin Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _pageTitles[_selectedIndex],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.65), 
                                fontSize: 9, 
                                fontWeight: FontWeight.w900, 
                                letterSpacing: 1.2
                              ),
                            ),
                            const SizedBox(height: 1),
                            const Text(
                              'Administrator', // 🟢 SEKARANG SUDAH UPDATE JADI ADMINISTRATOR SAJA
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 18, 
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // ICON UTILITY POJOK KANAN (NOTIFIKASI, LIGHT/DARK & LOGOUT)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔔 ICON LONCENG NOTIFIKASI JAYA M-BANKING
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.notifications_none_rounded, 
                          color: Colors.white.withOpacity(0.9),
                          size: 20, 
                        ),
                        onPressed: () {
                          // Aksi Klik Notifikasi di sini nanti, Bro
                        },
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Toggle Dark Mode
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          _isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded, 
                          color: Colors.white.withOpacity(0.9),
                          size: 18, 
                        ),
                        onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Tombol Logout
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.logout_rounded, 
                          color: Colors.white.withOpacity(0.9), 
                          size: 18, 
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // 📜 2. SCROLLABLE CONTENT AREA
          Expanded(
            child: _selectedIndex == 0
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        // 💳 SLIDE CARD UTAMA (PANJANG KETINGGIAN DINAIKKAN, FULL WIDTH BANNER)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'INFORMASI OTORISASI',
                            style: TextStyle(
                              fontSize: 11, 
                              fontWeight: FontWeight.w900, 
                              color: sectionTitleColor, // Menggunakan warna adaptif (Hitam pekat di light mode)
                              letterSpacing: 1.2
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Area Slide Card NIK (Tinggi dipanjangkan dari 115 ke 125)
                        SizedBox(
                          height: 125,
                          child: PageView(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page; 
                              });
                            },
                            children: [
                              _buildSlideCard3DFull(
                                Icons.shield_rounded, 
                                'NIK: ${widget.nik}', 
                                'Otorisasi: Super Admin Level', 
                                _isDarkMode 
                                    ? [const Color(0xFF1E40AF), const Color(0xFF0F172A)] 
                                    : [const Color(0xFF1E40AF), const Color(0xFF3B82F6)], 
                              ),
                              _buildSlideCard3DFull(
                                Icons.verified_user_rounded, 
                                'Sistem Koneksi', 
                                'Status: SAP Database Terhubung', 
                                _isDarkMode 
                                    ? [const Color(0xFF065F46), const Color(0xFF0F172A)] 
                                    : [const Color(0xFF10B981), const Color(0xFF059669)], 
                              ),
                              _buildSlideCard3DFull(
                                Icons.developer_mode_rounded, 
                                'App Environment', 
                                'Mode: Production Verified', 
                                _isDarkMode 
                                    ? [const Color(0xFF7C2D12), const Color(0xFF0F172A)] 
                                    : [const Color(0xFFF59E0B), const Color(0xFFD97706)], 
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // 🟢 ANIMATED DOT INDICATOR DI BAWAH SLIDE CARD
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            height: 5,
                            width: _currentPage == index ? 14 : 5, 
                            decoration: BoxDecoration(
                              color: _currentPage == index 
                                  ? (_isDarkMode ? Colors.blue.shade400 : siixBlue)
                                  : (_isDarkMode ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                        ),
                        
                        const SizedBox(height: 28),
                        
                        // Judul Section Menu Control
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'MAIN CONTROL SYSTEM',
                            style: TextStyle(
                              fontSize: 11, 
                              fontWeight: FontWeight.w900, 
                              color: sectionTitleColor, // Menggunakan warna adaptif (Hitam pekat di light mode)
                              letterSpacing: 1.2
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 📱 MAIN CONTROL GRID (FULL ICON SOLID BACKGROUND, ICON PUTIH MURNI)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), 
                            crossAxisCount: 4, 
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.82, 
                            children: [
                              _customGridItem(Icons.people_outline_rounded, 'User Access', const Color(0xFF2563EB), cardColor, textPrimary, borderColor, () {}),
                              _customGridItem(Icons.layers_outlined, 'CRUD Part', const Color(0xFFF97316), cardColor, textPrimary, borderColor, () {}),
                              _customGridItem(Icons.crop_free_rounded, 'Scanner', const Color(0xFF10B981), cardColor, textPrimary, borderColor, () {
                                setState(() { _selectedIndex = 1; });
                              }),
                              _customGridItem(Icons.hub_outlined, 'Line Model', const Color(0xFF8B5CF6), cardColor, textPrimary, borderColor, () {}),
                              _customGridItem(Icons.assessment_outlined, 'Sys Logs', const Color(0xFFF43F5E), cardColor, textPrimary, borderColor, () {
                                setState(() { _selectedIndex = 2; });
                              }),
                              _customGridItem(Icons.settings_input_component_outlined, 'Config', const Color(0xFF64748B), cardColor, textPrimary, borderColor, () {
                                setState(() { _selectedIndex = 3; });
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.6, 
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.construction_rounded, size: 48, color: textSecondary.withOpacity(0.4)),
                          const SizedBox(height: 12),
                          Text(
                            'Modul UI ${_pageTitles[_selectedIndex]}\nsedang disinkronisasikan.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: textSecondary, height: 1.4, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),

      // 🛑 3. STICKY FOOTER NAVIGATION BAR LUXURY WITH DYNAMIC STYLE
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border(
            top: BorderSide(color: borderColor, width: 1), // Garis pembatas tipis elegan atas footer
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isDarkMode ? 0.4 : 0.04),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 0 ? Icons.grid_view_rounded : Icons.grid_view_outlined), 
                  label: 'Overview'
                ),
                BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 1 ? Icons.qr_code_scanner_rounded : Icons.qr_code_scanner_outlined), 
                  label: 'Scanner'
                ),
                BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 2 ? Icons.history_rounded : Icons.history_outlined), 
                  label: 'Logs'
                ),
                BottomNavigationBarItem(
                  icon: Icon(_selectedIndex == 3 ? Icons.tune_rounded : Icons.tune_outlined), 
                  label: 'Settings'
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: _isDarkMode ? const Color(0xFF60A5FA) : siixBlue,
              unselectedItemColor: _isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              backgroundColor: cardColor,
              elevation: 0,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.1),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: -0.1),
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
          ),
        ),
      ),
    );
  }

  // 🎴 HELPER WIDGET: Full Width 3D Card (Ketinggian diperpanjang + Shadow disempurnakan berdasarkan tema)
  Widget _buildSlideCard3DFull(IconData icon, String title, String subtitle, List<Color> gradientColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), 
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, top: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            // Kontrol Bayangan Dinamis anti kaku
            _isDarkMode 
                ? BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  )
                : BoxShadow(
                    color: gradientColors[0].withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle, 
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12, fontWeight: FontWeight.w600)
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🟩 HELPER WIDGET: Grid Item Premium (Full Solid Container Warna + Ikon Putih Bersih adaptif)
  Widget _customGridItem(IconData icon, String title, Color itemColor, Color cardColor, Color textPrimary, Color borderColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Kotak Icon: Full Solid Background & White Icons
          Container(
            width: 52, 
            height: 52,
            decoration: BoxDecoration(
              // Background Blok Solid Penuh dengan penyesuaian kecerahan di Dark Mode
              color: _isDarkMode ? itemColor.withOpacity(0.85) : itemColor,
              borderRadius: BorderRadius.circular(16), 
              boxShadow: [
                BoxShadow(
                  color: itemColor.withOpacity(_isDarkMode ? 0.3 : 0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            ),
            child: Center(
              child: Icon(
                icon, 
                size: 24, 
                color: Colors.white, // FIX: Icon diubah menjadi Putih Bersih Solid
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11, 
                fontWeight: FontWeight.bold, 
                color: textPrimary, 
                letterSpacing: -0.2,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}