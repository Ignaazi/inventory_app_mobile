import 'package:flutter/material.dart';

class EngineeringPage extends StatelessWidget {
  const EngineeringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Engineering')),
      body: const Center(child: Text('Halaman Dept Engineering')),
    );
  }
}