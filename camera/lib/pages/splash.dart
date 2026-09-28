import 'dart:async';
import 'package:foto/pages/login.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF283747),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0xFF5D6D7E),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(
                Icons.flutter_dash,
                size: 80,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Meu Aplicativo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Bem-vindo!',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFD5D8DC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}