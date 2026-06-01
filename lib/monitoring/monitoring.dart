import 'package:fl_chart/fl_chart.dart'; // 📊 Library Grafik Khusus Mobile
import 'package:flutter/material.dart';

import '../footer.dart';
// 📁 JALUR IMPORT GLOBAL COMPONENTS (Naik 1 folder ke atas)
import '../header.dart';
import '../main.dart'; // Untuk navigasi balik ke LoginPage jika user logout

class MonitoringAllPage extends StatefulWidget {
  const MonitoringAllPage({super.key});

  @override
  State<MonitoringAllPage> createState() => _MonitoringAllPageState();
}

class _MonitoringAllPageState extends State<MonitoringAllPage> {
  int _selectedIndex = 0; // ⚡ State internal untuk melacak klik footer
  bool _isDarkMode = false; // ⚡ DEFAULT: Light Mode (Kontrol penuh sinkron dari Header)
  String _searchQuery = "";

  // 📦 DATA SEEDER UTAMA (Konversi dari array Alpine.js web lu)
  final List<Map<String, String>> _allTransactions = [
    { 'name': 'Bought PYPL', 'date': 'Nov 23, 2025', 'price': '\$2,567.88', 'category': 'Finance', 'status': 'Success', 'initial': 'P', 'color': '0xFF1E40AF' },
    { 'name': 'Bought AAPL', 'date': 'Nov 22, 2025', 'price': '\$2,567.88', 'category': 'Technology', 'status': 'Pending', 'initial': 'A', 'color': '0xFF334155' },
    { 'name': 'Sell KKST', 'date': 'Oct 12, 2025', 'price': '\$6,754.99', 'category': 'Finance', 'status': 'Success', 'initial': 'K', 'color': '0xFF10B981' },
    { 'name': 'Bought FB', 'date': 'Sep 09, 2025', 'price': '\$1,445.41', 'category': 'Social media', 'status': 'Success', 'initial': 'F', 'color': '0xFF3B82F6' },
    { 'name': 'Sell AMZN', 'date': 'Feb 15, 2026', 'price': '\$5,698.55', 'category': 'E-commerce', 'status': 'Failed', 'initial': 'A', 'color': '0xFFF97316' },
    { 'name': 'Nozzle Type A', 'date': 'Feb 20, 2026', 'price': '\$120.00', 'category': 'Engineering', 'status': 'Success', 'initial': 'N', 'color': '0xFF8B5CF6' },
    { 'name': 'Sparepart B2', 'date': 'Feb 21, 2026', 'price': '\$45.00', 'category': 'Production', 'status': 'Pending', 'initial': 'S', 'color': '0xFFEAB308' },
  ];

  @override
  Widget build(BuildContext context) {
    // 🎨 PALET WARNA ADAPTIF MOBILE UI
    final Color backgroundColor = _isDarkMode ? const Color(0xFF0B0F19) : const Color(0xFFF1F5F9);
    final Color cardColor = _isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final Color textPrimary = _isDarkMode ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final Color textSecondary = _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final Color borderColor = _isDarkMode ? const Color(0xFF334155).withOpacity(0.5) : const Color(0xFFE2E8F0);
    const Color siixBlue = Color(0xFF1E40AF);

    // Filter transaksi berdasarkan query pencarian di mobile
    final filteredList = _allTransactions.where((item) {
      return item['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             item['category']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // 🛑 1. STICKY HEADER (Mengambil dari header.dart bawaan proyek lu)
          DashboardHeader(
            pageTitle: 'SYSTEM MONITORING',
            isDarkMode: _isDarkMode,
            onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
            onLogout: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          ),

          // 📜 2. SCROLL CONTENT CONTAINER
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Link Minimalis ke Dashboard Utama
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: siixBlue),
                        SizedBox(width: 6),
                        Text('Dashboard', style: TextStyle(color: siixBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // HORIZONTAL SCROLL FOR KPI CARDS
                  Text('STOCK OVERVIEW STATISTICS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 1.1)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildKpiCard('ALL', '2,140', '+11.01%', Colors.blue, cardColor, textPrimary, textSecondary),
                        _buildKpiCard('READY', '1,840', '+11.01%', Colors.green, cardColor, textPrimary, textSecondary),
                        _buildKpiCard('USED', '256', '+11.01%', Colors.lightBlue, cardColor, textPrimary, textSecondary),
                        _buildKpiCard('DAMAGED', '14', '-9.05%', Colors.red, cardColor, textPrimary, textSecondary, isUp: false),
                        _buildKpiCard('LOST', '3', '-2.10%', Colors.amber, cardColor, textPrimary, textSecondary, isUp: false),
                        _buildKpiCard('TRASH', '42', '+5.02%', Colors.grey, cardColor, textPrimary, textSecondary),
                        _buildKpiCard('HEALTH', '86%', '+11.01%', Colors.indigo, cardColor, textPrimary, textSecondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // MINI SPARKLINE CARDS (Operational, Risk, Costing)
                  Text('DEPARTMENT MINI INSIGHTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 1.1)),
                  const SizedBox(height: 10),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                    children: [
                      _buildSparklineCard('Operational', '17/20', [30, 45, 35, 60, 50, 70], Colors.blue, cardColor, textPrimary, textSecondary),
                      _buildSparklineCard('Risk Control', '5 Pcs', [80, 60, 70, 40, 50, 30], Colors.red, cardColor, textPrimary, textSecondary),
                      _buildSparklineCard('Costing', '\$4,250', [40, 50, 45, 70, 80, 95], Colors.green, cardColor, textPrimary, textSecondary),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // INVENTORY TRACEABILITY TREND (MAIN CHART INTERAKTIF MOBILE)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // ⚡ FIXED: Sesuai aturan penulisan resmi Flutter
                          children: [
                            Text('TRACEABILITY TREND', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimary)),
                            Row(
                              children: [
                                _buildChartIndicator('IN', Colors.blue),
                                const SizedBox(width: 8),
                                _buildChartIndicator('OUT', Colors.green),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 180,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true, 
                                drawVerticalLine: false, 
                                getDrawingHorizontalLine: (val) => FlLine(
                                  color: borderColor, 
                                  strokeWidth: 1, 
                                  dashArray: [5, 5], // ⚡ FIXED: Menggunakan dashArray sesuai library fl_chart terbaru
                                )
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (val, meta) {
                                  List<String> days = ['16 Feb', '17 Feb', '18 Feb', '19 Feb', '20 Feb', '21 Feb', '22 Feb'];
                                  if (val.toInt() >= 0 && val.toInt() < days.length) {
                                    return Text(days[val.toInt()], style: TextStyle(color: textSecondary, fontSize: 9, fontWeight: FontWeight.bold));
                                  }
                                  return const Text('');
                                })),
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: TextStyle(color: textSecondary, fontSize: 9)))),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                
                                LineChartBarData(
                                  spots: const [FlSpot(0, 120), FlSpot(1, 150), FlSpot(2, 100), FlSpot(3, 180), FlSpot(4, 140), FlSpot(5, 210), FlSpot(6, 190)],
                                  isCurved: true, 
                                  curveSmoothness: 0.35,
                                  color: Colors.blue, 
                                  barWidth: 3.5, 
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  shadow: Shadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 5),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true, 
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.blue.withOpacity(0.25),
                                        Colors.blue.withOpacity(0.08),
                                        Colors.blue.withOpacity(0.00),
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                  ),
                                ),
                                // 📊 LINE GRADIENT 2: OUT (GREEN 3D SHADOW VOLUME)
                                LineChartBarData(
                                  spots: const [FlSpot(0, 80), FlSpot(1, 130), FlSpot(2, 110), FlSpot(3, 140), FlSpot(4, 120), FlSpot(5, 190), FlSpot(6, 170)],
                                  isCurved: true, 
                                  curveSmoothness: 0.35,
                                  color: Colors.green, 
                                  barWidth: 3.5, 
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: false),
                                  shadow: Shadow(
                                    color: Colors.green.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 5),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.green.withOpacity(0.25),
                                        Colors.green.withOpacity(0.08),
                                        Colors.green.withOpacity(0.00),
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // LIVE ALERTS MOBILE SYSTEM
                  Text('LIVE ALERT BENCHMARKS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 1.1)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (context, index) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(backgroundColor: Colors.red.withOpacity(0.1), child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20)),
                        title: Text('Stock Critical Alert', style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                        subtitle: Text('Line 05 needs immediate nozzle replacement.', style: TextStyle(color: textSecondary, fontSize: 11)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SEARCH BAR & DATA LOG LIST
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // ⚡ FIXED: Menggunakan spaceBetween resmi Flutter
                    children: [
                      Text('LATEST MUTATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 1.1)),
                      Container(
                        width: 160,
                        height: 34,
                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor)),
                        child: TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          style: TextStyle(color: textPrimary, fontSize: 11),
                          decoration: InputDecoration(
                            hintText: 'Search mutations...',
                            hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 11),
                            prefixIcon: Icon(Icons.search, size: 14, color: textSecondary),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(bottom: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // LIST MUTASI TRANSAKSI ADAPTIF
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      Color statusColor = Colors.orange;
                      Color statusBg = Colors.orange.withOpacity(0.1);
                      if (item['status'] == 'Success') { statusColor = Colors.green; statusBg = Colors.green.withOpacity(0.1); }
                      if (item['status'] == 'Failed') { statusColor = Colors.red; statusBg = Colors.red.withOpacity(0.1); }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
                        child: Row(
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(color: Color(int.parse(item['color']!)), borderRadius: BorderRadius.circular(8)),
                              child: Center(child: Text(item['initial']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['name']!, style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text('${item['category']}  •  ${item['date']}', style: TextStyle(color: textSecondary, fontSize: 10)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(item['price']!, style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6)),
                                  child: Text(item['status']!.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.w900)), // ⚡ FIXED: Menggunakan FontWeight.w900 resmi
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 🛑 3. STICKY FOOTER FIXED (Sekarang Aktif, Indah, & Sinkron Berbagi Data)
      bottomNavigationBar: DashboardFooter(
        selectedIndex: _selectedIndex,
        isDarkMode: _isDarkMode,
        cardColor: cardColor,
        borderColor: borderColor,
        siixBlue: siixBlue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          if (index == 0) {
            Navigator.pop(context); // Jika diklik Home, langsung kembali ke Dashboard utama
          } else {
            Navigator.pop(context, index); // Oper data index ke dashboard utama
          }
        },
      ),
    );
  }

  // 🧱 COMPONENT 1: KARTU KPI HORIZONTAL
  Widget _buildKpiCard(String label, String value, String trend, Color baseColor, Color cardBg, Color textP, Color textS, {bool isUp = true}) {
    return Container(
      width: 105,
      margin: const EdgeInsets.only(right: 8, bottom: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: textS.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // ⚡ FIXED: Menggunakan spaceBetween resmi Flutter
            children: [
              Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: baseColor)),
              Icon(isUp ? Icons.trending_up_rounded : Icons.trending_down_rounded, size: 12, color: isUp ? Colors.green : Colors.red),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textP)),
              Text(trend, style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: isUp ? Colors.green : Colors.red)),
            ],
          )
        ],
      ),
    );
  }

  // 🧱 COMPONENT 2: MINI SPARKLINE CHART CARD WITH GLOW & SHADOW GRADIENT
  Widget _buildSparklineCard(String title, String mainValue, List<double> values, Color chartColor, Color cardBg, Color textP, Color textS) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: textS.withOpacity(0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // ⚡ FIXED: Menggunakan spaceBetween resmi Flutter
        children: [
          Text(title.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: textS)),
          Text(mainValue, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textP)),
          
          SizedBox(
            height: 25,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                    isCurved: true, 
                    curveSmoothness: 0.4,
                    color: chartColor, 
                    barWidth: 2.5, 
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    // 🌟 EFEK BAYANGAN PADA GARIS SPARKLINE MINI (Otomatis Aktif untuk Operational, Risk, dan Costing)
                    shadow: Shadow(
                      color: chartColor.withOpacity(0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                    // 🌟 EFEK GRADASI 3D DI BAWAH GARIS SPARKLINE MINI (Otomatis Aktif untuk Operational, Risk, dan Costing)
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          chartColor.withOpacity(0.20),
                          chartColor.withOpacity(0.00),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartIndicator(String label, Color color) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }
}