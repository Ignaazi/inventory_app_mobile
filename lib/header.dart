import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Untuk mengontrol warna dan kontras Status Bar (Baterai, Jam, Wifi)

class DashboardHeader extends StatefulWidget {
  final String pageTitle;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  final String? userName;          
  final String? userRole;          
  final String? userNim;           
  final String? profilePhotoPath;

  const DashboardHeader({
    super.key,
    required this.pageTitle,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onLogout,
    this.userName,          
    this.userRole,          
    this.userNim,           
    this.profilePhotoPath,  
  });

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> with SingleTickerProviderStateMixin {
  late AnimationController _rainbowController;

  @override
  void initState() {
    super.initState();
    // 🔄 Mengontrol kecepatan putaran animasi pelangi (3 detik untuk satu putaran penuh)
    _rainbowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // Animasi berjalan terus-menerus tanpa henti
  }

  @override
  void dispose() {
    _rainbowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'http://10.0.2.2:8000/storage/';
    
    final String displayNama = widget.userName ?? 'Administrator';
    final String displayRole = widget.userRole ?? 'Staff';

    // 🎨 KONFIGURASI WARNA SOLID PREMIUM (SIIX STYLE)
    final Color textColor = widget.isDarkMode ? Colors.white : const Color(0xFF1E3A8A);
    final Color subtitleColor = widget.isDarkMode ? const Color(0xFFA5B4FC) : const Color(0xFF1E40AF).withOpacity(0.9);
    final Color iconColor = widget.isDarkMode ? Colors.white : const Color(0xFF1E40AF);
    final Color borderColor = widget.isDarkMode ? const Color(0xFF4C1D95).withOpacity(0.4) : const Color(0xFF93C5FD).withOpacity(0.4);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Membuat status bar bening agar gradasi header nembus ke atas
        statusBarIconBrightness: widget.isDarkMode ? Brightness.light : Brightness.dark, 
        statusBarBrightness: widget.isDarkMode ? Brightness.dark : Brightness.light, 
      ),
      child: Container(
        width: double.infinity, 
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 12, 
          bottom: 18, // Ditambah sedikit agar space lengkungan bawah proporsional
          left: 16,
          right: 16, 
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isDarkMode 
                ? [
                    const Color(0xFF1E1B4B), 
                    const Color(0xFF311B92), 
                  ]
                : [
                    const Color(0xFFEFF6FF), 
                    const Color(0xFFDBEAFE), 
                  ],
          ),
          // 📐 KEMBALI MELENGKUNG: Lekukan melengkung bawah diaktifkan kembali secara premium
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          border: Border(
            bottom: BorderSide(color: borderColor, width: 2), 
          ),
          boxShadow: [
            BoxShadow(
              color: widget.isDarkMode ? Colors.black.withOpacity(0.3) : const Color(0xFF1E40AF).withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
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
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: widget.isDarkMode ? const Color(0xFF4A148C).withOpacity(0.3) : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isDarkMode ? const Color(0xFFA855F7) : const Color(0xFF3B82F6), 
                        width: 2.5, 
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: widget.profilePhotoPath != null && widget.profilePhotoPath!.isNotEmpty
                          ? Image.network(
                              '$baseUrl${widget.profilePhotoPath}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.person_rounded, color: iconColor, size: 26);
                              },
                            )
                          : Center(
                              child: Text(
                                displayNama.isNotEmpty ? displayNama[0].toUpperCase() : 'A',
                                style: TextStyle(color: textColor, fontWeight: FontWeight.w900, fontSize: 18),
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
                          widget.pageTitle,
                          style: TextStyle(
                            color: subtitleColor.withOpacity(0.7), 
                            fontSize: 9, 
                            fontWeight: FontWeight.w900, 
                            letterSpacing: 1.5
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          displayNama, 
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor, 
                            fontSize: 16, 
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3
          ),
        ),
                        const SizedBox(height: 1),
                        Text(
                          widget.userNim != null && widget.userNim!.isNotEmpty 
                              ? '$displayRole • NIK: ${widget.userNim}'
                              : displayRole,
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // UTILITY BUTTONS WITH LIVE MOVING RAINBOW BORDER
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeaderButton(
                  child: Badge(
                    label: const Text('3', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)), 
                    backgroundColor: Colors.redAccent,
                    child: Icon(Icons.notifications_none_rounded, color: iconColor, size: 21),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 6),
                _buildHeaderButton(
                  child: Icon(
                    widget.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded, 
                    color: widget.isDarkMode ? const Color(0xFFFBBF24) : const Color(0xFF1E40AF), 
                    size: 19, 
                  ),
                  onPressed: widget.onThemeToggle,
                ),
                const SizedBox(width: 6),
                _buildHeaderButton(
                  child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 19), 
                  onPressed: widget.onLogout,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // REUSABLE HELPER: Custom Moving Rainbow Border Button
  Widget _buildHeaderButton({required Widget child, required VoidCallback onPressed}) {
    return AnimatedBuilder(
      animation: _rainbowController,
      builder: (context, snapshot) {
        return CustomPaint(
          painter: RainbowBorderPainter(
            animationValue: _rainbowController.value,
            strokeWidth: 1.8, // Ketebalan garis pelangi berputar
          ),
          child: Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.all(1.2), // Memberikan ruang nafas bagi garis pelangi
            decoration: BoxDecoration(
              color: widget.isDarkMode ? const Color(0xFF311B92).withOpacity(0.8) : Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                )
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: child,
              onPressed: onPressed,
            ),
          ),
        );
      },
    );
  }
}

// 🌈 CUSTOM PAINTER: Menggambar & memutar gradasi warna pelangi secara realtime
class RainbowBorderPainter extends CustomPainter {
  final double animationValue;
  final double strokeWidth;

  RainbowBorderPainter({required this.animationValue, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    
    // Konfigurasi spektrum warna pelangi melingkar penuh (RGB Spectrum)
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
        transform: GradientRotation(animationValue * 2 * 3.141592653589793), // Rumus rotasi lingkaran penuh (2 * Pi)
        colors: const [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.green,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
          Colors.red, // Ditutup merah lagi agar gradasi putarannya menyambung mulus
        ],
      ).createShader(rect);

    // Menggambar outline berbentuk lingkaran sempurna mengikuti sasis tombol
    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(covariant RainbowBorderPainter oldDelegate) {
    // Dipaksa melukis ulang terus-menerus mengikuti detak nilai animasi controller
    return oldDelegate.animationValue != animationValue;
  }
}