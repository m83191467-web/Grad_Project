import 'package:flutter/material.dart';

class SpaceBackground extends StatelessWidget {
  const SpaceBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/images/space/stars.png', fit: BoxFit.cover),
        child,
      ],
    );
  }
}
