import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_menu.dart'; // We'll make sure this exists later

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();

  // Function to save name and start the app
  Future<void> _saveAndContinue() async {
    if (_nameController.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _nameController.text);

      if (mounted) {
        // Go to Home and remove back button (can't go back to login)
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const HomeMenu())
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505), // Deep Black
      body: Center(
        child: Container(
          width: 400, // Limit width for landscape look
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.security, size: 60, color: Colors.cyanAccent),
              const SizedBox(height: 20),
              const Text(
                "IDENTIFY YOURSELF",
                style: TextStyle(
                  color: Colors.white, 
                  fontFamily: 'Courier', // Hacker font
                  fontSize: 24, 
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 30),
              
              // The Input Field
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.cyanAccent),
                decoration: InputDecoration(
                  labelText: "CODENAME",
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[800]!),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyanAccent),
                  ),
                  prefixIcon: const Icon(Icons.person_outline, color: Colors.cyanAccent),
                ),
              ),
              const SizedBox(height: 30),

              // The Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent.withOpacity(0.1),
                    side: const BorderSide(color: Colors.cyanAccent),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: const Text(
                    "INITIALIZE SYSTEM >",
                    style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}