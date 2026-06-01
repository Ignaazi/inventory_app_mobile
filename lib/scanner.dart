import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // 🟢 Tetap pakai library asli

class ScannerPage extends StatefulWidget {
  final bool isDarkMode;

  const ScannerPage({super.key, required this.isDarkMode});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with TickerProviderStateMixin {
  // Gunakan nullable atau inisialisasi aman untuk menghindari LateInitializationError saat Hot Reload
  AnimationController? _laserController;
  Animation<double>? _laserAnimation;
  AnimationController? _rainbowController; 

  bool _isCameraActive = false; 
  String _scannedResult = ''; 

  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    // Setup Animasi Laser Naik-Turun
    _laserController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _laserController!, curve: Curves.easeInOut),
    );

    // Setup Animasi Pelangi Berputar Transisi Kontinu
    _rainbowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _laserController?.dispose();
    _rainbowController?.dispose();
    _scannerController.dispose(); 
    super.dispose();
  }

  // 🛠️ MOCK UPLOAD FILE (Solusi alternatif jika kamera device user rusak/bermasalah)
  void _handleUploadBarcode() {
    setState(() {
      _scannedResult = "SIIX-MATRIX-MOCK-UPLOAD-2026-VALID";
    });
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'Barcode berhasil diekstrak dari dokumen', 
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold, 
                color: widget.isDarkMode ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Cek proteksi jika controller belum siap sewaktu Hot Reload awal
    if (_rainbowController == null || _laserAnimation == null) {
      return const Scaffold(backgroundColor: Colors.transparent, body: Center(child: CircularProgressIndicator()));
    }

    // 🎨 KONFIGURASI WARNA GLASSMORPHISM TRANSPARAN SESUAI USER MANAGEMENT
    final Color cardBackgroundColor = widget.isDarkMode 
        ? const Color(0xFF1E1B4B).withOpacity(0.35) 
        : Colors.white.withOpacity(0.45);
    final Color textPrimary = widget.isDarkMode ? Colors.white : const Color(0xFF1E3A8A); 
    final Color textSecondary = widget.isDarkMode ? const Color(0xFFA5B4FC) : const Color(0xFF475569); 
    final Color borderColor = widget.isDarkMode ? const Color(0xFF4C1D95).withOpacity(0.25) : const Color(0xFFDBEAFE).withOpacity(0.7);
    final Color innerFieldColor = widget.isDarkMode ? const Color(0xFF11101E).withOpacity(0.5) : const Color(0xFFF8FAFC).withOpacity(0.6);

    return Scaffold(
      backgroundColor: Colors.transparent, // Mengikuti background gradien utama dashboard lu
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // 🔙 TOMBOL KEMBALI KE DASHBOARD (Gaya Minimalis Elegan)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, bottom: 16.0, top: 4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: textPrimary),
                    const SizedBox(width: 6),
                    Text(
                      'Kembali ke Dashboard', 
                      style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            // 🟥 BOX UTAMA KOTAK SCANNER TRANSPARAN
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Column(
                children: [
                  // Sub-Header Menu Internal Atas Kotak
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.qr_code_scanner_rounded, color: textPrimary, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'LIVE CAMERA VIEW',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 0.8),
                            ),
                          ],
                        ),
                        // Action Button Upload Gambar File Barcode
                        TextButton.icon(
                          onPressed: _handleUploadBarcode,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF10B981),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            backgroundColor: const Color(0xFF10B981).withOpacity(0.12),
                          ),
                          icon: const Icon(Icons.cloud_upload_rounded, size: 14),
                          label: const Text('Upload File', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),

                  // Area Penempatan Kamera & Siku Detektor
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.isDarkMode ? const Color(0xFF0F172A).withOpacity(0.5) : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        clipBehavior: Clip.antiAlias, 
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Trigger Kamera ON / OFF
                            if (!_isCameraActive)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_enhance_rounded, size: 40, color: textSecondary.withOpacity(0.4)),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2563EB),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        elevation: 1,
                                      ),
                                      onPressed: () => setState(() => _isCameraActive = true),
                                      icon: const Icon(Icons.videocam_rounded, size: 16),
                                      label: const Text('Aktifkan Sensor Kamera', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                                    ),
                                  ],
                                ),
                              )
                            else
                              MobileScanner(
                                controller: _scannerController,
                                onDetect: (capture) {
                                  final List<Barcode> barcodes = capture.barcodes;
                                  for (final barcode in barcodes) {
                                    if (barcode.rawValue != null) {
                                      setState(() {
                                        _scannedResult = barcode.rawValue!;
                                      });
                                    }
                                  }
                                },
                              ),

                            // 🎯 BINGKAI HOLLOW PEMBIDIK DENGAN UJUNG RAINBOW BERGERAK BERPUTAR
                            AnimatedBuilder(
                              animation: _rainbowController!,
                              builder: (context, _) {
                                return SizedBox(
                                  width: 210,
                                  height: 210,
                                  child: Stack(
                                    children: [
                                      // Kerangka Pembatas Utama Tipis Tengah transparan
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      // Render Siku-Siku Pelangi Animasi Berputar
                                      _buildRainbowCorner(Alignment.topLeft, top: true, left: true),
                                      _buildRainbowCorner(Alignment.topRight, top: true, left: false),
                                      _buildRainbowCorner(Alignment.bottomLeft, top: false, left: true),
                                      _buildRainbowCorner(Alignment.bottomRight, top: false, left: false),
                                    ],
                                  ),
                                );
                              },
                            ),

                            // 🚨 LINE LASER GLOWING NEON (Muncul saat kamera menyala)
                            if (_isCameraActive)
                              AnimatedBuilder(
                                animation: _laserAnimation!,
                                builder: (context, child) {
                                  return Positioned(
                                    top: 15 + (_laserAnimation!.value * 180),
                                    left: 24,
                                    right: 24,
                                    child: Container(
                                      height: 2.5,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Colors.transparent, Color(0xFF10B981), Colors.transparent],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF10B981).withOpacity(0.5),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Informasi Status Aktivasi Kamera Baris Bawah
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: innerFieldColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 6, height: 6,
                            decoration: BoxDecoration(
                              color: _isCameraActive ? const Color(0xFF10B981) : Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isCameraActive ? 'Dekoder Matrix Aktif & Memindai' : 'Perangkat Kamera Status: Standby',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),

            // 🟩 BOX PANEL FIELD HASIL PEMINDAIAN DATA (Transparan & Sinkron Tema)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderColor, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RESULT MATRIX LOG DATA',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 12),
                  
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: _scannedResult),
                    style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      labelText: 'Kode Unik Terdeteksi',
                      labelStyle: TextStyle(color: textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                      hintText: 'Belum ada data matrix masuk',
                      hintStyle: TextStyle(color: textSecondary.withOpacity(0.4), fontSize: 12),
                      prefixIcon: const Icon(Icons.qr_code_2_rounded, color: Color(0xFF2563EB), size: 18),
                      filled: true,
                      fillColor: innerFieldColor,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: borderColor, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧱 LOGIKA SUB-WIDGET SUDUT SEGI-EMPAT RAINBOW BERGERAK
  Widget _buildRainbowCorner(Alignment alignment, {required bool top, required bool left}) {
    const double size = 22;
    const double thickness = 3.5;

    // Ambil value aman dari controller pelangi
    double sweepAngle = (_rainbowController?.value ?? 0.0) * 2 * math.pi;

    return Align(
      alignment: alignment,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return SweepGradient(
            transform: GradientRotation(sweepAngle),
            colors: const [
              Colors.red,
              Colors.amber,
              Colors.green,
              Colors.cyan,
              Colors.blue,
              Colors.purple,
              Colors.red,
            ],
          ).createShader(bounds);
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border(
              top: top ? const BorderSide(color: Colors.white, width: thickness) : BorderSide.none,
              bottom: !top ? const BorderSide(color: Colors.white, width: thickness) : BorderSide.none,
              left: left ? const BorderSide(color: Colors.white, width: thickness) : BorderSide.none,
              right: !left ? const BorderSide(color: Colors.white, width: thickness) : BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}