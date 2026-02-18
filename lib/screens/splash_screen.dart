import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'home_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    // 1. Wait for 2 seconds (Simulate "Loading System...")
    await Future.delayed(const Duration(seconds: 2));

    // 2. Check Storage
    final prefs = await SharedPreferences.getInstance();
    final String? username = prefs.getString('username');

    if (mounted) {
      if (username != null && username.isNotEmpty) {
        // User exists -> Go to Home
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeMenu()));
      } else {
        // New User -> Go to Login
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for your Web Logo
            const Icon(Icons.webhook, size: 100, color: Colors.redAccent), 
            const SizedBox(height: 20),
            const Text(
              "SPYDAR",
              style: TextStyle(
                fontSize: 40, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
                letterSpacing: 5,
              ),
            ),
            const SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.cyanAccent.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}