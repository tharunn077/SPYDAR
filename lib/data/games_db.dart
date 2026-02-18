// games_db.dart
class BenchmarkApp {
  final String name;
  final String category; // "Esports", "AAA", "Productivity"
  final String icon;     // Use Material Icons for now (or asset paths)
  
  // Normalized Scores (0-100) based on recommended specs
  final int recCpuScore; 
  final int recGpuScore;
  final int recRamGB;
  final bool needsSSD;
  final String? imagePath;

  BenchmarkApp({
    required this.name,
    required this.category,
    required this.icon,
    required this.recCpuScore,
    this.imagePath,
    required this.recGpuScore,
    required this.recRamGB,
    this.needsSSD = false,
  });
}

// THE LIST OF 12 APPS (Updated with Spiderman 2 & Wukong)
final List<BenchmarkApp> benchmarkGames = [
  // --- TIER 1: ESPORTS (High FPS) ---
  BenchmarkApp(name: "Valorant", category: "Esports", icon: "V",imagePath: "assets/valorant.jpg", recCpuScore: 15, recGpuScore: 12, recRamGB: 4),
  BenchmarkApp(name: "CS:GO 2", category: "Esports", icon: "CS",imagePath: "assets/csgo.png", recCpuScore: 25, recGpuScore: 20, recRamGB: 8),
  BenchmarkApp(name: "League of Legends", category: "Esports", icon: "L",imagePath: "assets/lol.jpg", recCpuScore: 12, recGpuScore: 10, recRamGB: 4),

  // --- TIER 2: MID-RANGE ---
  BenchmarkApp(name: "GTA V", category: "Mid-Range", icon: "GTA",imagePath: "assets/gta.jpg", recCpuScore: 30, recGpuScore: 25, recRamGB: 8),
  BenchmarkApp(name: "Fortnite", category: "Mid-Range", icon: "FN",imagePath: "assets/fortnite.jpg", recCpuScore: 35, recGpuScore: 28, recRamGB: 8),
  BenchmarkApp(name: "Forza Horizon 5", category: "Mid-Range", icon: "FH",imagePath: "assets/forza.jpg", recCpuScore: 45, recGpuScore: 40, recRamGB: 16),

  // --- TIER 3: SYSTEM KILLERS (New Games Included) ---
  BenchmarkApp(name: "Cyberpunk 2077", category: "AAA", icon: "CP",imagePath: "assets/cyberpunk.jpg", recCpuScore: 55, recGpuScore: 60, recRamGB: 16, needsSSD: true),
  
  // NEW: Marvel's Spider-Man 2 (High Streaming/CPU load)
  BenchmarkApp(name: "Spider-Man 2", category: "AAA", icon: "SM",imagePath: "assets/spiderman2.jpeg", recCpuScore: 65, recGpuScore: 55, recRamGB: 16, needsSSD: true),
  
 BenchmarkApp(
      name: "Black Myth: Wukong", 
      category: "AAA", 
      icon: "BW",
      imagePath: "assets/blackmyth.jpg", 
      recCpuScore: 70, 
      recGpuScore: 85, // INCREASED from 75. Only top-tier GPUs should ace this.
      recRamGB: 32, 
      needsSSD: true
  ),

  // --- TIER 4: WORKSTATION ---
  BenchmarkApp(name: "Blender 4.0", category: "Workstation",imagePath: "assets/blender.jpg", icon: "BL", recCpuScore: 70, recGpuScore: 50, recRamGB: 16),
  BenchmarkApp(name: "Adobe Premiere", category: "Workstation",imagePath: "assets/premierepro.jpg", icon: "PR", recCpuScore: 60, recGpuScore: 40, recRamGB: 32),
  BenchmarkApp(
      name: "Cinebench 2024", 
      category: "Workstation", 
      imagePath: "assets/cinebench.png",
      icon: "CB", 
      recCpuScore: 90, // INCREASED from 85. Only i9/Ryzen 9 should ace this.
      recGpuScore: 10, 
      recRamGB: 8
  ),
];