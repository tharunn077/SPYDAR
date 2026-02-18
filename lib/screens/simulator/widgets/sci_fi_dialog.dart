import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SciFiDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onAcknowledge;

  const SciFiDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onAcknowledge,
  });

  static void show(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Force them to click acknowledge
      builder: (context) => SciFiDialog(
        title: title,
        message: message,
        onAcknowledge: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ INTEGRATED RAM LOGIC: Now strips both CPU and RAM headers for a clean look
    final cleanMessage = message
        .replaceAll("HARDWARE INCOMPATIBILITY DETECTED\n\n", "")
        .replaceAll("SOCKET TYPE MISMATCH\n\n", "")
        .replaceAll("MEMORY TYPE MISMATCH\n\n", "");

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        height: 360, // ✅ Fixed height (Perfect UI)
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0505),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.redAccent, width: 2),
          boxShadow: [
            BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 20, spreadRadius: 2)
          ],
        ),
        child: Column(
          children: [
            // 1. COMPACT HEADER
            const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
            const SizedBox(height: 5),
            Text(
              "SYSTEM ERROR",
              style: GoogleFonts.orbitron(
                color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2
              ),
            ),
            const Divider(color: Colors.redAccent, height: 17),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 2. TEXT AREA (Now clean for both RAM and CPU)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Text(
                  cleanMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 3. PINNED BUTTON
            GestureDetector(
              onTap: onAcknowledge,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.15),
                  border: Border.all(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "ACKNOWLEDGE",
                  style: GoogleFonts.orbitron(color: Colors.white, fontSize: 12, letterSpacing: 1.5),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}