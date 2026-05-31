import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String pageTitle;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const DashboardHeader({
    super.key,
    required this.pageTitle,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12, 
        bottom: 16,
        left: 20,
        right: 16, 
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode 
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
            color: isDarkMode ? Colors.black.withOpacity(0.4) : const Color(0xFF1E40AF).withOpacity(0.12),
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
                        pageTitle,
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
              // 🔔 ICON LONCENG NOTIFIKASI JAYA M-BANKING WITH CHECKBOX/BADGE STATUS
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Badge(
                    label: const Text('3', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)), // Notif angka m-banking
                    backgroundColor: Colors.redAccent,
                    child: Icon(
                      Icons.notifications_none_rounded, 
                      color: Colors.white.withOpacity(0.9),
                      size: 20, 
                    ),
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
                    isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded, 
                    color: Colors.white.withOpacity(0.9),
                    size: 18, 
                  ),
                  onPressed: onThemeToggle,
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
                  onPressed: onLogout,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}