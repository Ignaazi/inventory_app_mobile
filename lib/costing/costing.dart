import 'package:flutter/material.dart';

class CostingPage extends StatelessWidget {
  const CostingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Costing')),
      body: const Center(child: Text('Halaman Costing Production')),
    );
  }
}