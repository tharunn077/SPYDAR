import 'package:flutter/material.dart';
import 'simulator/simulator_screen.dart'; // Links to your Simulator
import 'catalog/catalog_screen.dart'; // Links to your Catalog (if created)

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505), // Deep Black
      body: Container(
        decoration: const BoxDecoration(
          // Subtle Red/Blue background glow
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A1128), // Dark Blue
              Colors.black,
              Colors.black,
              Color(0xFF280A0A), // Dark Red
            ],
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. LEFT: Main Action (Start Simulator)
              _buildLargeCard(
                context, 
                "NEW SIMULATION", 
                Icons.add_circle_outline, 
                Colors.cyanAccent,
                () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SimulatorScreen())),
              ),

              const SizedBox(width: 30),

              // 2. RIGHT: Secondary Options
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSmallCard(
                    context, 
                    "SAVED RIGS", 
                    Icons.save, 
                    Colors.purpleAccent,
                    () { /* TODO: Link to SavedListScreen */ },
                  ),
                  const SizedBox(height: 20),
                  _buildSmallCard(
                    context, 
                    "PARTS WIKI", 
                    Icons.manage_search, 
                    Colors.orangeAccent,
                    // If you haven't created CatalogScreen yet, this might error. 
                    // If so, comment out the navigation line below.
                    () => Navigator.push(context, MaterialPageRoute(builder: (c) => const CatalogScreen())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildLargeCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 20)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: color),
            const SizedBox(height: 20),
            Text(title, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 250,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}