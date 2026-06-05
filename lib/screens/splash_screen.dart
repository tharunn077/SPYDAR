import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// Your screens
import 'login_screen.dart';
import 'home_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _trackingAnimation;

  @override
  void initState() {
    super.initState();

    // 1. SETUP THE CINEMATIC ANIMATION
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Fades in from 0 to 1 over the first 60% of the timeline
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Cinches the letters together from 30px to 12px
    _trackingAnimation = Tween<double>(begin: 30.0, end: 12.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start the visual animation
    _controller.forward();

    // Start the background data check
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    // Wait exactly 3.5 seconds (lets the 2.5s animation finish and hold on screen for 1 second)
    await Future.delayed(const Duration(milliseconds: 3500));

    // Check Storage
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');

    if (mounted) {
      if (username != null && username.isNotEmpty) {
        // User exists -> Smooth Fade to Home
        Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000), // Smooth 1-second crossfade
            pageBuilder: (_, __, ___) => const HomeMenu(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
          )
        );
      } else {
        // New User -> Smooth Fade to Login
        Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000), // Smooth 1-second crossfade
            pageBuilder: (_, __, ___) => const LoginScreen(),
            transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
          )
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Pitch black for the cinematic feel
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Text(
                "SPYDAR",
                style: GoogleFonts.orbitron(
                  color: const Color(0xFFE0E0E0), // Clean, professional grey/white
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: _trackingAnimation.value, // Applies the cinching animation
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}