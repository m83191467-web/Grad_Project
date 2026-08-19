import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const GoogleLogo({super.key, this.size = 20, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red.shade400, Colors.blue.shade600],
        ),
      ),
      child: Center(
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
