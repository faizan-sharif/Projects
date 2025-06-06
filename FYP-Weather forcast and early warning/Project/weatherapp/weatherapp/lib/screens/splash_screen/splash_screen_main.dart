import 'package:flutter/material.dart';
import 'dart:async';

import 'package:weatherapp/screens/splash_screen/starter_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 2 seconds then navigate to Home (replace with your route)
    Timer(const Duration(seconds: 2), () {
      if(!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StarterScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png', // Replace with your logo asset path
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
