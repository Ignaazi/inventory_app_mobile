import 'package:flutter/material.dart';

class DashboardFooter extends StatelessWidget {
  final int selectedIndex;
  final bool isDarkMode;
  final Color cardColor;
  final Color borderColor;
  final Color siixBlue;
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
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 1), // Garis pembatas tipis elegan atas footer
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.04),
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
                icon: Icon(selectedIndex == 0 ? Icons.grid_view_rounded : Icons.grid_view_outlined), 
                label: 'Overview'
              ),
              BottomNavigationBarItem(
                icon: Icon(selectedIndex == 1 ? Icons.qr_code_scanner_rounded : Icons.qr_code_scanner_outlined), 
                label: 'Scanner'
              ),
              BottomNavigationBarItem(
                icon: Icon(selectedIndex == 2 ? Icons.history_rounded : Icons.history_outlined), 
                label: 'Logs'
              ),
              BottomNavigationBarItem(
                icon: Icon(selectedIndex == 3 ? Icons.tune_rounded : Icons.tune_outlined), 
                label: 'Settings'
              ),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: isDarkMode ? const Color(0xFF60A5FA) : siixBlue,
            unselectedItemColor: isDarkMode ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            backgroundColor: cardColor,
            elevation: 0,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.1),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, letterSpacing: -0.1),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}