import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // 🟢 Tetap pakai library asli

class ScannerPage extends StatefulWidget {
  final bool isDarkMode;

  const ScannerPage({super.key, required this.isDarkMode});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _laserAnimation;
  
  // 1. Tambahkan state untuk mengontrol kapan kamera boleh menyala
  bool _isCameraActive = false; 

  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  String _scannedResult = ''; 

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _laserAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scannerController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color cardColor = widget.isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color textPrimary = widget.isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B);
    final Color textSecondary = widget.isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color borderColor = widget.isDarkMode ? const Color(0xFF334155).withOpacity(0.5) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: widget.isDarkMode ? const Color(0xFF0B0F19) : const Color(0xFFF4F7FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(widget.isDarkMode ? 0.3 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias, 
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            
                            // 2. KONDISI: Jika kamera belum aktif, tampilkan tombol pemicu
                            if (!_isCameraActive)
                              Center(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF10B981),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isCameraActive = true; // 🎥 Nyalakan kamera dan picu perizinan HANYA saat diklik
                                    });
                                  },
                                  icon: const Icon(Icons.camera_alt_rounded),
                                  label: const Text('Aktifkan Kamera', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              )
                            else
                              // 📷 KAMERA BARU AKTIF DI SINI JIKA DIKLIK
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

                            // 🎯 BINGKAI KOTAK TARGET SCANNER
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFF10B981).withOpacity(_isCameraActive ? 1.0 : 0.3), width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),

                            // 🚨 ANIMASI LASER SCANNING HIJAU
                            if (_isCameraActive)
                              AnimatedBuilder(
                                animation: _laserAnimation,
                                builder: (context, child) {
                                  double targetAreaHeight = 200;
                                  return Positioned(
                                    top: (MediaQuery.of(context).size.width / 2 - 116) + (_laserAnimation.value * targetAreaHeight),
                                    child: Container(
                                      width: 190,
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF10B981).withOpacity(0.8),
                                            blurRadius: 8,
                                            spreadRadius: 2,
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

                  // STATUS INDIKATOR BAWAH KAMERA
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, left: 16, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _isCameraActive ? const Color(0xFF10B981) : Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _isCameraActive ? 'Kamera aktif mendeteksi barcode' : 'Kamera standby (belum diberi izin)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),

            // KOTAK CONTAINER HASIL DATA CODE ASLI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HASIL PEMINDAIAN MATRIX',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: textPrimary,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: _scannedResult),
                    style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      labelText: 'Data Code Terdeteksi',
                      labelStyle: TextStyle(color: textSecondary, fontSize: 12),
                      hintText: 'Belum ada data dipindai',
                      hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 13),
                      prefixIcon: const Icon(Icons.pin_rounded, color: Color(0xFF10B981), size: 18),
                      filled: true,
                      fillColor: widget.isDarkMode ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF10B981)),
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
}