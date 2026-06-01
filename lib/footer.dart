import 'package:flutter/material.dart';

class DashboardFooter extends StatelessWidget {
  final int selectedIndex;
  final bool isDarkMode;
  final Color cardColor;     // Dipertahankan agar dashboard lama tidak error
  final Color borderColor;   // Dipertahankan agar dashboard lama tidak error
  final Color siixBlue;      // Dipertahankan agar dashboard lama tidak error
  final ValueChanged<int> onTap;

  const DashboardFooter({
    super.key,
    required this.selectedIndex,
    required this.isDarkMode,
    required this.cardColor,
    required this.borderColor,
    required this.siixBlue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🎨 KONFIGURASI WARNA SOLID SENADA HEADER
    final Color activeColor = isDarkMode ? const Color(0xFFA855F7) : const Color(0xFF1E40AF);
    final Color inactiveColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color footerBorderColor = isDarkMode ? const Color(0xFF4C1D95).withOpacity(0.6) : const Color(0xFF93C5FD).withOpacity(0.6);

    return Container(
      decoration: BoxDecoration(
        // 🟢 GRADIENT PADAT SENADA DENGAN HEADER
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF1E1B4B), // Ungu Indigo Sangat Tua
                  const Color(0xFF311B92), // Deep Purple
                ]
              : [
                  const Color(0xFFEFF6FF), // Putih Kebiruan Lembut
                  const Color(0xFFDBEAFE), // Biru Muda Soft Premium
                ],
        ),
        // 🟢 ADJUSTMENT: Lekukan dihapus, sekarang murni flat / garis lurus tegas
        borderRadius: BorderRadius.zero,
        border: Border(
          top: BorderSide(color: footerBorderColor, width: 2), // Garis pembatas lurus di atas
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.4) : const Color(0xFF1E40AF).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          )
        ],
      ),
      child: SafeArea(
        top: false, // Aman dari notch/gesture bar bawah HP modern
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0), // Padding vertikal disesuaikan agar proporsional
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFooterItem(
                index: 0,
                icon: Icons.dashboard_rounded,
                activeIcon: Icons.dashboard_rounded,
                label: 'Overview',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildFooterItem(
                index: 1,
                icon: Icons.qr_code_scanner_rounded,
                activeIcon: Icons.qr_code_scanner_rounded,
                label: 'Scanner',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildFooterItem(
                index: 2,
                icon: Icons.history_toggle_off_rounded,
                activeIcon: Icons.history_rounded,
                label: 'Logs',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
              _buildFooterItem(
                index: 3,
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings_rounded,
                label: 'Settings',
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // REUSABLE HELPER: Item Navigasi dengan Efek Pil Mikro 3D
  Widget _buildFooterItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final bool _isSelected = selectedIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _isSelected
              ? (isDarkMode ? activeColor.withOpacity(0.15) : activeColor.withOpacity(0.08))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isSelected ? activeIcon : icon,
              color: _isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: _isSelected ? FontWeight.w900 : FontWeight.w600,
                color: _isSelected ? activeColor : inactiveColor,
                letterSpacing: _isSelected ? 0.2 : 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}