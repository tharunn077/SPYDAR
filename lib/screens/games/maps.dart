import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'level_one.dart'; 
import '../simulator/widgets/glitters.dart'; // For the CyberGlitters widget

class MapSelectionScreen extends StatelessWidget {
  const MapSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Stack( // ✅ Wrap the whole body in a Stack
        children: [
          
          // --- 1. AMBIENT BACKGROUND LAYER ---
          const Positioned.fill(
            child: CyberGlitters(particleCount: 40), // Adjust this number if you want more/less glitter
          ),

          // --- 2. FOREGROUND UI LAYER ---
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, color: Colors.cyanAccent, size: 18),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text("SELECT CHAPTER", 
                        style: GoogleFonts.orbitron(
                          color: Colors.white, 
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20), // Spacing before the cards

                // --- HORIZONTAL CHAPTER LIST ---
                SizedBox(
                  height: 215, // Height of the horizontal scrolling area
                  child: ListView(
                    scrollDirection: Axis.horizontal, 
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      // CHAPTER 1
                      ChapterCard(
                        chapterNumber: 1,
                        chapterName: "The Beginning",
                        bgImagePath: 'assets/doc_ock_bg.png', 
                        isUnlocked: true,
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => const LevelOneScreen()),
                          );
                        },
                      ),
                      const SizedBox(width: 20), // Spacing BETWEEN cards
                      
                      // CHAPTER 2
                      const ChapterCard(
                        chapterNumber: 2,
                        chapterName: "Coming Soon",
                        bgImagePath: 'assets/maps.jpg', 
                        isUnlocked: false,
                      ),
                      const SizedBox(width: 20),

                      // CHAPTER 3
                      const ChapterCard(
                        chapterNumber: 3,
                        chapterName: "Coming Soon",
                        bgImagePath: 'assets/maps.jpg', 
                        isUnlocked: false,
                      ),
                      const SizedBox(width: 20), // End padding
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- THE TALL POSTER CHAPTER CARD ---
class ChapterCard extends StatelessWidget {
  final int chapterNumber;
  final String chapterName;
  final String bgImagePath;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const ChapterCard({
    super.key,
    required this.chapterNumber,
    required this.chapterName,
    required this.bgImagePath,
    required this.isUnlocked,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Container(
        width: 230, // Fixed width for the card shape
        decoration: BoxDecoration(
          // ✅ FIX: Fully black inside if locked, transparent if unlocked so image shows
          color: isUnlocked ? Colors.transparent : Colors.black, 
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? Colors.cyanAccent : Colors.white10, 
            width: isUnlocked ? 2.0 : 1.0
          ),
          // ✅ FIX: Boosted the cyan glow for the unlocked chapter
          boxShadow: isUnlocked ? [
            BoxShadow(color: Colors.cyanAccent.withOpacity(0.4), blurRadius: 10, spreadRadius: 0.25)
          ] : [],
          // ✅ FIX: Only render the image if the chapter is unlocked
          image: isUnlocked 
            ? DecorationImage(
                image: AssetImage(bgImagePath),
                fit: BoxFit.cover,
              ) 
            : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // GRADIENT OVERLAY (Bottom to Top so text is readable)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(isUnlocked ? 0.8 : 0.95), 
                      Colors.black.withOpacity(isUnlocked ? 0.1 : 0.7),  
                    ],
                  ),
                ),
              ),

              // THE TEXT CONTENT (Pinned to the bottom)
              Positioned(
                bottom: 20,
                left: 15,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("CHAPTER $chapterNumber", 
                      style: GoogleFonts.orbitron(
                        color: isUnlocked ? Colors.cyanAccent : Colors.white38,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(chapterName, 
                      style: TextStyle(
                        color: isUnlocked ? Colors.white : Colors.white54,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ FIX: THE NEON RED LOCK ICON
             // ✅ FIX: THE NEON RED LOCK ICON (Moved up and resized)
              if (!isUnlocked)
                Align(
                  // X = 0 (centered horizontally), Y = -0.3 (shifted slightly up from center)
                  alignment: const Alignment(0, -0.3), 
                  child: Container(
                    padding: const EdgeInsets.all(12), // Made the circle padding tighter
                    decoration: BoxDecoration(
                      color: Colors.black, 
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent.withOpacity(0.6), width: 1.5),
                      boxShadow: [
                        BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 12, spreadRadius: 2)
                      ]
                    ),
                    child: const Icon(Icons.lock_outline, color: Colors.redAccent, size: 38), // Shrunk the icon
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}