import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  final String pageTitle;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  // 🟢 Dipertahankan opsional agar halaman lain aman tidak ikut error
  final String? userName;          // Sekarang diplot khusus untuk NAMA LENGKAP user
  final String? userRole;          // 🟢 BARU: Menampung data role (Admin/Costing/Production/Engineering)
  final String? userNim;           // Menampung data NIK/NIM
  final String? profilePhotoPath;

  const DashboardHeader({
    super.key,
    required this.pageTitle,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onLogout,
    this.userName,          
    this.userRole,          // 👈 Ditambahkan ke constructor
    this.userNim,           
    this.profilePhotoPath,  
  });

  @override
  Widget build(BuildContext context) {
    // Jalur asset storage Laravel lu
    const String baseUrl = 'http://10.0.2.2:8000/storage/';
    
    // Fallback data jika null (misal dari halaman monitoring yang panggil tanpa parameter)
    final String displayNama = userName ?? 'Administrator';
    final String displayRole = userRole ?? 'Staff';

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
                // 👤 AVATAR FOTO PROFIL
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: profilePhotoPath != null && profilePhotoPath!.isNotEmpty
                        ? Image.network(
                            '$baseUrl$profilePhotoPath',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.person_rounded, color: Colors.white.withOpacity(0.9), size: 26);
                            },
                          )
                        : Center(
                            child: Text(
                              displayNama.isNotEmpty ? displayNama[0].toUpperCase() : 'A',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // INFO TEXT USER
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
                      // 🟢 Memunculkan NAMA LENGKAP USER secara Dinamis
                      Text(
                        displayNama, 
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white, 
                          fontSize: 16, 
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5
                        ),
                      ),
                      const SizedBox(height: 1),
                      // 🟢 Memunculkan gabungan text ROLE dan NIK biar informatif & hemat ruang
                      Text(
                        userNim != null && userNim!.isNotEmpty 
                            ? '$displayRole • NIK: $userNim'
                            : displayRole,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // UTILITY BUTTONS
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Badge(
                    label: const Text('3', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)), 
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.notifications_none_rounded, color: Colors.white.withOpacity(0.9), size: 20),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 4),
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
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.logout_rounded, color: Colors.white.withOpacity(0.9), size: 18),
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