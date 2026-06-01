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
  int _selectedIndex = 0; 
  bool _isDarkMode = false; 
  String _searchQuery = "";

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
    final Color cardColor = _isDarkMode ? const Color(0xFF1E1B4B).withOpacity(0.7) : Colors.white.withOpacity(0.85);
    final Color textPrimary = _isDarkMode ? Colors.white : const Color(0xFF1E3A8A);
    final Color textSecondary = _isDarkMode ? const Color(0xFFA5B4FC) : const Color(0xFF475569);
    final Color borderColor = _isDarkMode ? const Color(0xFF4C1D95).withOpacity(0.4) : const Color(0xFFDBEAFE);
    const Color siixBlue = Color(0xFF1E40AF);

    final filteredList = _allTransactions.where((item) {
      return item['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             item['category']!.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isDarkMode
                    ? [
                        const Color(0xFF0F172A), 
                        const Color(0xFF1E1B4B), 
                        const Color(0xFF11101E), 
                      ]
                    : [
                        const Color(0xFFDBEAFE), 
                        Colors.white,            
                        const Color(0xFFEFF6FF), 
                        const Color(0xFFE0E7FF), 
                      ],
                stops: _isDarkMode ? const [0.0, 0.6, 1.0] : const [0.0, 0.35, 0.7, 1.0],
              ),
            ),
          ),

          Column(
            children: [
              DashboardHeader(
                pageTitle: 'SYSTEM MONITORING',
                isDarkMode: _isDarkMode,
                onThemeToggle: () => setState(() => _isDarkMode = !_isDarkMode),
                onLogout: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                },
              ),

              Expanded(
                child: SafeArea(
                  top: false, 
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: textPrimary),
                              const SizedBox(width: 6),
                              Text('Dashboard', style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

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

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('TRACEABILITY TREND', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: textPrimary)),
                                  Row(
                                    children: [
                                      _buildChartIndicator('IN', const Color(0xFF2563EB)),
                                      const SizedBox(width: 8),
                                      _buildChartIndicator('OUT', const Color(0xFF10B981)),
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
                                        color: borderColor.withOpacity(0.5), 
                                        strokeWidth: 1, 
                                        dashArray: const [5, 5],
                                      )
                                    ),
                                    titlesData: FlTitlesData(
                                      show: true,
                                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (val, meta) {
                                        List<String> days = ['16 Feb', '17 Feb', '18 Feb', '19 Feb', '20 Feb', '21 Feb', '22 Feb'];
                                        if (val.toInt() >= 0 && val.toInt() < days.length) {
                                          // 🛠️ FIX TOTAL: Menggunakan EdgeInsets.only() & fontSize untuk standardisasi fl_chart terbaru
                                          return Padding(
                                            padding: const EdgeInsets.only(top: 6.0),
                                            child: Text(days[val.toInt()], style: TextStyle(color: textSecondary, fontSize: 9, fontWeight: FontWeight.bold)),
                                          );
                                        }
                                        return const Text('');
                                      })),
                                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28, getTitlesWidget: (val, meta) => Text(val.toInt().toString(), style: TextStyle(color: textSecondary, fontSize: 9, fontWeight: FontWeight.bold)))),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: const [FlSpot(0, 120), FlSpot(1, 150), FlSpot(2, 100), FlSpot(3, 180), FlSpot(4, 140), FlSpot(5, 210), FlSpot(6, 190)],
                                        isCurved: true, 
                                        curveSmoothness: 0.35,
                                        color: const Color(0xFF2563EB), 
                                        barWidth: 3.5, 
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true, 
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color(0xFF2563EB).withOpacity(0.2),
                                              const Color(0xFF2563EB).withOpacity(0.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                      LineChartBarData(
                                        spots: const [FlSpot(0, 80), FlSpot(1, 130), FlSpot(2, 110), FlSpot(3, 140), FlSpot(4, 120), FlSpot(5, 190), FlSpot(6, 170)],
                                        isCurved: true, 
                                        curveSmoothness: 0.35,
                                        color: const Color(0xFF10B981), 
                                        barWidth: 3.5, 
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color(0xFF10B981).withOpacity(0.2),
                                              const Color(0xFF10B981).withOpacity(0.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(milliseconds: 450),
                                  curve: Curves.easeInOutCubic,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        Text('LIVE ALERT BENCHMARKS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 1.1)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor, width: 1.2)),
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('LATEST MUTATION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textPrimary, letterSpacing: 1.1)),
                            Container(
                              width: 160,
                              height: 34,
                              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: borderColor, width: 1.2)),
                              child: TextField(
                                onChanged: (val) => setState(() => _searchQuery = val),
                                style: TextStyle(color: textPrimary, fontSize: 11),
                                decoration: InputDecoration(
                                  hintText: 'Search mutations...',
                                  hintStyle: TextStyle(color: textSecondary.withOpacity(0.6), fontSize: 11),
                                  prefixIcon: Icon(Icons.search, size: 14, color: textSecondary),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(bottom: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

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
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: borderColor, width: 1.2)),
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
                                        Text('${item['category']}  •  ${item['date']}', style: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w600)),
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
                                        child: Text(item['status']!.toUpperCase(), style: TextStyle(color: statusColor, fontSize: 8, fontWeight: FontWeight.w900)),
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
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: DashboardFooter(
        selectedIndex: _selectedIndex,
        isDarkMode: _isDarkMode,
        cardColor: _isDarkMode ? const Color(0xFF1E1B4B) : Colors.white,
        borderColor: borderColor,
        siixBlue: siixBlue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          
          if (index == 0) {
            Navigator.pop(context);
          } else {
            Navigator.pop(context, index);
          }
        },
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, String trend, Color baseColor, Color cardBg, Color textP, Color textS, {bool isUp = true}) {
    return Container(
      width: 105,
      margin: const EdgeInsets.only(right: 8, bottom: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: textS.withOpacity(0.15), width: 1.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _buildSparklineCard(String title, String mainValue, List<double> values, Color chartColor, Color cardBg, Color textP, Color textS) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: textS.withOpacity(0.15), width: 1.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: textS)),
          Text(mainValue, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textP)),
          const SizedBox(height: 4),
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
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
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
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900)),
      ],
    );
  }
}