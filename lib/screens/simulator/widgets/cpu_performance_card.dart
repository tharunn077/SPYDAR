import 'package:flutter/material.dart';
import '../../../models/component_model.dart';

class CpuPerformanceCard extends StatelessWidget {
  final Cpu cpu;

  const CpuPerformanceCard({super.key, required this.cpu});

  // --- NEON COLOR PALETTE ---
  // Using bright accent colors for that "Cyberpunk" glow
  final Color neonBlue = Colors.cyanAccent;
  final Color neonRed = const Color.fromARGB(255, 255, 82, 82);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A), // Slightly darker bg for neon contrast
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          // Optional: Subtle glow effect behind the card
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          // --- 1. WORKSTATION BAR (Neon Blue) ---
          _buildScoreRow(
            label: "Workstation",
            score: cpu.workstationScore,
            icon: Icons.computer,
            color: neonBlue,
            description: "Video Editing, 3D Rendering",
          ),
          
          const SizedBox(height: 10), // Slightly more breathing room

          // --- 2. GAMING BAR (Neon Red) ---
          _buildScoreRow(
            label: "Gaming",
            score: cpu.gamingScore,
            icon: Icons.videogame_asset,
            color: neonRed,
            description: "FPS, 1% Lows, Smoothness",
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Divider(color: Colors.white12, height: 1),
          ),

          // --- 3. NEON FOOTER ---
          Row(
            children: [
              // Left Side (Single Core) -> Pushed to the RIGHT (End)
              Expanded(
                child: _buildStatBadge(
                  label: "Single Core", 
                  value: "${cpu.singleCoreScore}", 
                  color: neonRed,
                  alignEnd: true, // Custom alignment logic
                ),
              ),
              
              // The Center Divider
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                width: 1, 
                height: 14, 
                color: Colors.white24
              ),

              // Right Side (Multi Core) -> Pushed to the LEFT (Start)
              Expanded(
                child: _buildStatBadge(
                  label: "Multi Core", 
                  value: "${cpu.multiCoreScore}", 
                  color: neonBlue,
                  alignEnd: false, // Custom alignment logic
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Updated Helper: Handles alignment to center the stats around the divider
  Widget _buildStatBadge({
    required String label, 
    required String value, 
    required Color color,
    required bool alignEnd,
  }) {
    return Row(
      // This is the magic: Align towards the center divider
      mainAxisAlignment: alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            color: Colors.grey[400], // Softer white for label
            fontSize: 10,
            fontFamily: "Roboto",
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color, // Neon color for the value
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            shadows: [
              // Tiny neon glow behind the text
              Shadow(color: color.withOpacity(0.6), blurRadius: 4),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRow({
    required String label,
    required int score,
    required IconData icon,
    required Color color,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon with Glow
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.2), blurRadius: 6, spreadRadius: 1),
                ],
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white, // Brighter white for headers
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              "$score/100",
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(color: color.withOpacity(0.5), blurRadius: 5),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        
        // Neon Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey[850], // Darker track
            color: color, // Pure Neon
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(color: Colors.grey[500], fontSize: 10),
        ),
      ],
    );
  }
}