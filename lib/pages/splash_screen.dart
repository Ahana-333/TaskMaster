import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart'; // replace with your actual home page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/app_background.png'), // same as other pages
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset(
            'lib/assets/logo.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
