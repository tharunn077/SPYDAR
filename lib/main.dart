import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Needed for orientation lock
import 'screens/splash_screen.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Required for the next line
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp()); // Only run the app AFTER locking orientation
  });
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SPYDAR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050505),
      ),
      home: const SplashScreen(), // Start at Splash
    );
  }
}