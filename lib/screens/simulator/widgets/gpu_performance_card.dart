import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/component_model.dart';

class GpuPerformanceCard extends StatelessWidget {
  final Gpu gpu;
  const GpuPerformanceCard({super.key, required this.gpu});

  final Color neonRed = const Color.fromARGB(255, 255, 82, 82);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111118),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              // --- SECTION 1: THE MAIN SCORE ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("GRAPHICS SCORE", 
                    style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 11, letterSpacing: 1.2)),
                  Text("${gpu.performanceScore}/100", 
                    style: GoogleFonts.orbitron(color: neonRed, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: gpu.performanceScore / 100,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  color: neonRed,
                  minHeight: 8,
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white10, height: 1),
              ),

              // --- SECTION 2: THE BENCHMARK DATA ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("BENCHMARK", style: TextStyle(color: Colors.white38, fontSize: 9)),
                      const SizedBox(height: 2),
                      Text("3DMark Time Spy", style: GoogleFonts.roboto(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("RAW SCORE", style: TextStyle(color: Colors.white38, fontSize: 9)),
                      const SizedBox(height: 2),
                      Text("${gpu.timeSpyScore}", style: GoogleFonts.orbitron( color: const Color.fromARGB(255, 255, 82, 82), fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "Performance is measured by calculating the average frame throughput in DX12 environments.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white24, fontSize: 9, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}