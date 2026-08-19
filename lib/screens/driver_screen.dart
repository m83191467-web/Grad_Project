import 'package:flutter/material.dart';

class DriverScreen extends StatelessWidget {
  const DriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("واجهة السائق"),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text("مرحباً بالسائق 🚍", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
