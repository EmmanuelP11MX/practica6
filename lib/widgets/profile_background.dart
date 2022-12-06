import 'dart:math';
import 'package:flutter/material.dart';

class ProfileBackground extends StatelessWidget {
  final Widget child;

  const ProfileBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [const _Background(), child],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
        0.2,
        0.8
      ],
          colors: [
        // Color.fromARGB(255, 46, 48, 95),
        Color.fromARGB(255, 12, 51, 228),
        Color.fromARGB(255, 1, 252, 252),
      ]));

  const _Background({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blue);
  }
}
