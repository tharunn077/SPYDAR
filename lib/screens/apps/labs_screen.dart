import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors_plus/sensors_plus.dart'; 
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../saved_builds/saved_list_screen.dart'; 
import '../../data/components_db.dart'; 
import '../../models/component_model.dart'; 

class LabsScreen extends StatefulWidget {
  const LabsScreen({super.key});

  @override
  State<LabsScreen> createState() => _LabsScreenState();
}

class _LabsScreenState extends State<LabsScreen> with TickerProviderStateMixin {
  // HIGH CONTRAST NEON
  static const Color neonCyan = Color(0xFF00FFFF); 
  static const Color neonRed = Color(0xFFFF003C); 
  static const Color bgDark = Color(0xFF050505);

  Map<String, dynamic>? _buildLeft; 
  Map<String, dynamic>? _buildRight; 

  late AnimationController _liquidController;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  double _tiltAngle = 0.0;
  double _targetRatio = 0.5; 
  double _currentRatio = 0.5;
  List<MicroDot> _dots = []; 

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 50; i++) {
      _dots.add(MicroDot());
    }

    _liquidController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), 
    )..repeat();

    _accelSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      if (!mounted) return;

      // ✅ FIX: Use 'y' for steering motion when held horizontally.
      // 0.3 sensitivity for the liquid
      double newAngle = (event.y * 0.3).clamp(-1.0, 1.0); 
      
      setState(() {
        _tiltAngle = _tiltAngle + (newAngle - _tiltAngle) * 0.2;
      });
    });
  }

  @override
  void dispose() {
    _liquidController.dispose();
    _accelSubscription?.cancel();
    super.dispose();
  }

  void _calculateBalance() {
    if (_buildLeft == null || _buildRight == null) {
      setState(() => _targetRatio = 0.5);
      return;
    }

    double scoreL = double.tryParse(_buildLeft!['cost']?.toString() ?? "0") ?? 0;
    double scoreR = double.tryParse(_buildRight!['cost']?.toString() ?? "0") ?? 0;

    if ((_buildLeft!['gpu'] ?? "").toString().contains("4090")) scoreL += 20000;
    if ((_buildRight!['gpu'] ?? "").toString().contains("4090")) scoreR += 20000;

    double total = scoreL + scoreR;
    double ratio = (total == 0) ? 0.5 : (scoreL / total); 

    setState(() => _targetRatio = ratio);
  }
Future<void> _selectBuild(bool isLeft) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SavedBuildsScreen(
          isSelectionMode: true,
          // ✅ PASS THE COLOR HERE
          themeColor: isLeft ? neonCyan : neonRed, 
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        if (isLeft) _buildLeft = result;
        else _buildRight = result;
        _calculateBalance();
      });
    }
  }

  // ✅ HELPER: Find Motherboard Logic
  Motherboard? _findMobo(String? name) {
    if (name == null) return null;
    try {
      return ComponentsDB.motherboards.firstWhere((m) => m.name == name);
    } catch (e) {
      try {
        return ComponentsDB.motherboards.firstWhere(
          (m) => m.name.toLowerCase().trim() == name.toLowerCase().trim()
        );
      } catch (e) {
        return null; 
      }
    }
  }

  Cpu? _findCpu(String? name) {
    if (name == null) return null;
    try { return ComponentsDB.cpus.firstWhere((c) => c.name == name); } catch (e) { return null; }
  }
  Gpu? _findGpu(String? name) {
    if (name == null) return null;
    try { return ComponentsDB.gpus.firstWhere((g) => g.name == name); } catch (e) { return null; }
  }
@override
  Widget build(BuildContext context) {
    _currentRatio = _currentRatio + (_targetRatio - _currentRatio) * 0.05;

    // Feature: Only animate bubbles if comparison is active
    bool showBubbles = _buildLeft != null || _buildRight != null;
    if (showBubbles) {
      for (var dot in _dots) dot.update();
    }

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. BACKGROUND
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset('assets/grid.png', fit: BoxFit.cover, errorBuilder: (c,e,s)=>Container()),
            )
          ),

          // 2. MAIN LAYOUT
          Column(
            children: [
              // --- HEADER ---
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text("SPYDAR LABS", 
                  style: GoogleFonts.orbitron(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 4,
                    shadows: [const Shadow(color: neonCyan, blurRadius: 15)]
                  ),
                ),
              ),

              // --- BATTLE AREA (Boxes) ---
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      // LEFT BOX (Flat & Stable)
                      Expanded(
                        child: _buildHoloBox(neonCyan, _buildLeft, true),
                      ),
                      
                      // GAP FOR LOGO 
                      const SizedBox(width: 60), 

                      // RIGHT BOX (Flat & Stable)
                      Expanded(
                        child: _buildHoloBox(neonRed, _buildRight, false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. THE FLOATING LOGO
          Positioned(
            top: 70, 
            bottom: 40,
            child: Center(
              child: _buildNeonLiquidLogo(showBubbles),
            ),
          ),

          // 4. BACK BUTTON
          Positioned(
            top: 15, left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white54, size: 24),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildHoloBox(Color color, Map<String, dynamic>? build, bool isLeft) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.02),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.05), blurRadius: 20, spreadRadius: 0)
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: _buildPlayerContent(color, build, isLeft),
      ),
    );
  }

  Widget _buildPlayerContent(Color color, Map<String, dynamic>? build, bool isLeft) {
    if (build == null) {
      return GestureDetector(
        onTap: () => _selectBuild(isLeft),
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 1),
                boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 15)]
              ),
              child: Icon(Icons.add, color: color, size: 24),
            ),
            const SizedBox(height: 15),
            Text(isLeft ? "SYSTEM A" : "SYSTEM B", 
              style: GoogleFonts.orbitron(color: color.withOpacity(0.7), fontSize: 12, letterSpacing: 1)
            ),
          ],
        ),
      );
    }

    // --- 1. LOOKUP DATA ---
    Cpu? realCpu = _findCpu(build['cpu']);
    Gpu? realGpu = _findGpu(build['gpu']);
    Motherboard? realMobo = _findMobo(build['mobo']);

    // --- 2. WI-FI LOGIC ---
    bool hasWifi = false;
    String wifiText = "ETHERNET";

    if (realMobo != null) {
      hasWifi = realMobo.hasWifi;
      if (hasWifi) {
        wifiText = (realMobo.wifiVersion ?? "WI-FI READY").toUpperCase();
      }
    } else {
      String moboName = (build['mobo'] ?? "").toUpperCase();
      if (moboName.contains("WIFI") || moboName.contains("AX") || moboName.contains("AC")) {
        hasWifi = true;
        wifiText = "WI-FI DETECTED";
      }
    }

    // --- 3. OTHER STATS ---
    String ramString = build['ram'] ?? "Unknown RAM";
    String storageString = build['storage'] ?? "Unknown Storage";
    
    int cpuGameScore = realCpu?.gamingScore ?? 0;
    int cpuWorkScore = realCpu?.workstationScore ?? 0;
    int gpuScore = realGpu?.performanceScore ?? 0;
    int coreCount = realCpu?.coreCount ?? 0;
    double clockSpeed = realCpu?.baseClock ?? 0.0;
    String gpuUpscaling = realGpu?.upscaling ?? "N/A"; 

    // --- 4. OPPONENT DATA ---
    Map<String, dynamic>? opponent = isLeft ? _buildRight : _buildLeft;
    int oppCpuGameScore = 0;
    int oppCpuWorkScore = 0;
    int oppGpuScore = 0;
    String oppUpscaling = "N/A";
    String oppRamString = "Unknown";
    String oppStorageString = "Unknown";

    if (opponent != null) {
      Cpu? oppCpu = _findCpu(opponent['cpu']);
      Gpu? oppGpu = _findGpu(opponent['gpu']);
      oppCpuGameScore = oppCpu?.gamingScore ?? 0;
      oppCpuWorkScore = oppCpu?.workstationScore ?? 0;
      oppGpuScore = oppGpu?.performanceScore ?? 0;
      oppUpscaling = oppGpu?.upscaling ?? "N/A";
      oppRamString = opponent['ram'] ?? "Unknown";
      oppStorageString = opponent['storage'] ?? "Unknown";
    }

    TextAlign alignText = isLeft ? TextAlign.left : TextAlign.right;

    Widget swapBtn = IconButton(
      onPressed: () => _selectBuild(isLeft),
      icon: Icon(Icons.swap_horiz, color: color.withOpacity(0.8), size: 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      tooltip: "Swap Build",
    );

    return Column(
      children: [
        // HEADER
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isLeft) swapBtn, 
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(build['name'].toString().toUpperCase(), 
                        style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        textAlign: alignText,
                      ),
                    ),
                  ),
                  if (isLeft) swapBtn,
                ],
              ),
              Align(
                alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(height: 2, width: 30, color: color, margin: const EdgeInsets.only(top: 5))
              ),
            ],
          ),
        ),

        // SCROLLABLE CONTENT
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _buildSectionHeader("PROCESSOR", isLeft),
                _buildDetailRow(realCpu?.name ?? (build['cpu'] ?? "N/A"), isLeft),
                _buildScoreRow("GAMING", cpuGameScore, oppCpuGameScore, color, isLeft),
                _buildScoreRow("WORKSTATION", cpuWorkScore, oppCpuWorkScore, color, isLeft),
                _buildCoreClockRow(coreCount, 0, clockSpeed, 0, color, isLeft),

                const SizedBox(height: 20),

                _buildSectionHeader("GRAPHICS", isLeft),
                _buildDetailRow(realGpu?.name ?? (build['gpu'] ?? "N/A"), isLeft),
                _buildScoreRow("3D PERFORMANCE", gpuScore, oppGpuScore, color, isLeft),
                _buildUpscaleRow(gpuUpscaling, oppUpscaling, color, isLeft),

                const SizedBox(height: 20),

                _buildSectionHeader("MEMORY", isLeft),
                _buildParsedRamRow(ramString, oppRamString, isLeft, color),

                const SizedBox(height: 20),

                _buildSectionHeader("STORAGE", isLeft),
                _buildParsedStorageRow(storageString, oppStorageString, isLeft, color),

                const SizedBox(height: 20),

                _buildSectionHeader("CONNECTIVITY", isLeft),
                _buildWifiRow(wifiText, hasWifi, color, isLeft),

                const SizedBox(height: 20),

                _buildSectionHeader("COST", isLeft),
                _buildPriceRow(build['cost'] ?? "0", color, isLeft),

                const SizedBox(height: 50), 
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- HELPERS ---

  Widget _buildSectionHeader(String title, bool isLeft) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(title, 
        style: GoogleFonts.orbitron(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1),
        textAlign: isLeft ? TextAlign.left : TextAlign.right, 
      ),
    );
  }

  Widget _buildDetailRow(String text, bool isLeft) {
    String cleanText = text.replaceAll(RegExp(r'Intel Core |AMD Ryzen |NVIDIA GeForce |AMD Radeon '), '');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(cleanText, 
        style: GoogleFonts.roboto(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
        maxLines: 1, overflow: TextOverflow.ellipsis,
        textAlign: isLeft ? TextAlign.left : TextAlign.right,
      ),
    );
  }

  Widget _buildPriceRow(String cost, Color color, bool isLeft) {
    return Container(
      width: double.infinity,
      child: Text("₹$cost", 
        style: GoogleFonts.orbitron(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: isLeft ? TextAlign.left : TextAlign.right,
      ),
    );
  }

  Widget _buildScoreRow(String label, int myScore, int oppScore, Color color, bool isLeft) {
    bool isWinner = (myScore > oppScore) && (oppScore > 0);
    Color scoreColor = isLeft ? neonCyan : neonRed; 

    EdgeInsets safetyPadding = isLeft 
        ? const EdgeInsets.only(right: 35) 
        : const EdgeInsets.only(left: 35);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: isLeft 
        ? [
            Text(label, style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 12)),
            Padding(
              padding: safetyPadding,
              child: Row(children: [
                Text("$myScore", style: GoogleFonts.orbitron(color: isWinner ? scoreColor : Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                if (isWinner) Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.arrow_drop_up, color: scoreColor, size: 16)),
              ]),
            )
          ]
        : [
            Padding(
              padding: safetyPadding,
              child: Row(children: [
                if (isWinner) Padding(padding: const EdgeInsets.only(right: 15), child: Icon(Icons.arrow_drop_up, color: scoreColor, size: 16)),
                Text("$myScore", style: GoogleFonts.orbitron(color: isWinner ? scoreColor : Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
              ]),
            ),
            Text(label, style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 12)),
          ],
      ),
    );
  }

  Widget _buildWifiRow(String text, bool hasWifi, Color color, bool isLeft) {
    Color textColor = hasWifi ? color : Colors.white38;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLeft) Icon(hasWifi ? Icons.wifi : Icons.cable, color: textColor, size: 16),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.orbitron(color: textColor, fontSize: 12)),
          const SizedBox(width: 8),
          if (!isLeft) Icon(hasWifi ? Icons.wifi : Icons.cable, color: textColor, size: 16),
        ],
      ),
    );
  }

  Widget _buildUpscaleRow(String myTech, String oppTech, Color color, bool isLeft) {
    double getTechScore(String t) {
      if (t.contains("DLSS 4")) return 5.0;
      if (t.contains("DLSS 3.5")) return 4.5;
      if (t.contains("DLSS 3")) return 4.0;
      if (t.contains("FSR 3")) return 3.8;
      if (t.contains("DLSS 2")) return 3.0;
      if (t.contains("FSR 2")) return 2.5;
      return 0.0;
    }

    double myScore = getTechScore(myTech);
    double oppScore = getTechScore(oppTech);
    bool isWinner = (myScore > oppScore) && (oppScore > 0);
    Color winColor = isLeft ? neonCyan : neonRed;

    Widget techTag = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isWinner ? winColor.withOpacity(0.1) : Colors.white10,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isWinner ? winColor : Colors.white24)
      ),
      child: Text(myTech, style: GoogleFonts.orbitron(
        color: isWinner ? winColor : Colors.white70, 
        fontSize: 10, fontWeight: isWinner ? FontWeight.bold : FontWeight.normal
      )),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isLeft) ...[
            techTag,
            const SizedBox(width: 4),
            Text("SCALING", style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 12)),
          ],
          if (!isLeft) ...[
            Text("SCALING", style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 12)),
            const SizedBox(width: 4),
            techTag,
          ]
        ],
      ),
    );
  }

  Widget _buildCoreClockRow(int myCores, int oppCores, double myClock, double oppClock, Color color, bool isLeft) {
    bool coreWin = (myCores > oppCores) && (oppCores > 0);
    bool clockWin = (myClock > oppClock) && (oppClock > 0);
    Color winColor = isLeft ? neonCyan : neonRed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          _tag("${myCores}C", coreWin ? winColor : Colors.white24, coreWin),
          const SizedBox(width: 4),
          _tag("${myClock}GHz", clockWin ? winColor : Colors.white24, clockWin),
        ],
      ),
    );
  }

  Widget _buildParsedRamRow(String myRam, String oppRam, bool isLeft, Color color) {
    int mySize = _parseSize(myRam);
    int oppSize = _parseSize(oppRam);
    bool sizeWin = (mySize > oppSize) && (oppSize > 0);

    bool myDDR5 = myRam.contains("DDR5");
    bool oppDDR5 = oppRam.contains("DDR5");
    bool typeWin = myDDR5 && !oppDDR5;

    Color winColor = isLeft ? neonCyan : neonRed;
    String sizeText = myRam.contains("32GB") ? "32GB" : (myRam.contains("16GB") ? "16GB" : "8GB");
    String typeText = myDDR5 ? "DDR5" : "DDR4";

    return Row(
      mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        _tag(sizeText, sizeWin ? winColor : Colors.white24, sizeWin),
        const SizedBox(width: 4),
        _tag(typeText, typeWin ? winColor : Colors.white24, typeWin),
      ],
    );
  }

  Widget _buildParsedStorageRow(String mySto, String oppSto, bool isLeft, Color color) {
    int myCap = _parseStorage(mySto);
    int oppCap = _parseStorage(oppSto);
    bool capWin = (myCap > oppCap) && (oppCap > 0);

    int myTypeSc = mySto.contains("NVMe") ? 3 : (mySto.contains("SSD") ? 2 : 1);
    int oppTypeSc = oppSto.contains("NVMe") ? 3 : (oppSto.contains("SSD") ? 2 : 1);
    bool typeWin = (myTypeSc > oppTypeSc);

    Color winColor = isLeft ? neonCyan : neonRed;
    String capText = mySto.contains("1TB") ? "1TB" : (mySto.contains("500GB") ? "500GB" : "2TB");
    String typeText = mySto.contains("NVMe") ? "NVMe" : (mySto.contains("SSD") ? "SSD" : "HDD");

    return Row(
      mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        _tag(capText, capWin ? winColor : Colors.white24, capWin),
        const SizedBox(width: 4),
        _tag(typeText, typeWin ? winColor : Colors.white24, typeWin),
      ],
    );
  }

  int _parseSize(String s) {
    if (s.contains("64GB")) return 64;
    if (s.contains("32GB")) return 32;
    if (s.contains("16GB")) return 16;
    return 8;
  }
  int _parseStorage(String s) {
    if (s.contains("4TB")) return 4000;
    if (s.contains("2TB")) return 2000;
    if (s.contains("1TB")) return 1000;
    if (s.contains("500GB")) return 500;
    return 250;
  }

  Widget _tag(String text, Color borderColor, bool isWinner) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      decoration: BoxDecoration(
        color: isWinner ? borderColor.withOpacity(0.1) : Colors.white10,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isWinner ? borderColor : Colors.white24)
      ),
      child: Text(text, style: GoogleFonts.roboto(
        color: isWinner ? borderColor : Colors.white70, 
        fontSize: 10, fontWeight: isWinner ? FontWeight.bold : FontWeight.normal
      )),
    );
  }

  // --- GLOWING LIQUID LOGO ---
  Widget _buildNeonLiquidLogo(bool showBubbles) {
    return SizedBox(
      width: 140, 
      height: 140,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          border: Border.all(color: Colors.white24, width: 2),
          boxShadow: [
            BoxShadow(color: neonCyan.withOpacity(_currentRatio * 0.7), blurRadius: 60, spreadRadius: -5),
            BoxShadow(color: neonRed.withOpacity((1-_currentRatio) * 0.7), blurRadius: 60, spreadRadius: -5),
          ]
        ),
        child: ClipOval( 
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _liquidController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(140, 140),
                    painter: NeonPhysicsPainter(
                      ratio: _currentRatio, 
                      wavePhase: _liquidController.value * 2 * math.pi, 
                      tilt: _tiltAngle, 
                      colorCyan: neonCyan,
                      colorRed: neonRed,
                      dots: _dots,
                      showBubbles: showBubbles, // ✅ PASS THE FLAG
                    ),
                  );
                },
              ),
              Center(child: Icon(Icons.bug_report, size: 70, color: Colors.white.withOpacity(0.95))),
              Positioned(
                top: 0, left: 0, right: 0, height: 70,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                      begin: Alignment.topCenter, end: Alignment.bottomCenter
                    )
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

class MicroDot {
  static final _rnd = math.Random();
  double x = 0; double y = 0; double size = 0; double speed = 0;
  MicroDot() { reset(true); }
  void reset(bool randomY) {
    x = (_rnd.nextDouble() * 100) - 50; 
    y = randomY ? (_rnd.nextDouble() * 130) - 65 : 70; 
    size = _rnd.nextDouble() * 2 + 1; 
    speed = _rnd.nextDouble() * 0.8 + 0.3; 
  }
  void update() {
    y -= speed; if (y < -70) reset(false);
  }
}

class NeonPhysicsPainter extends CustomPainter {
  final double ratio; final double wavePhase; final double tilt; 
  final Color colorCyan; final Color colorRed; final List<MicroDot> dots;
  // ✅ FEATURE 2: Added Flag
  final bool showBubbles;

  NeonPhysicsPainter({
    required this.ratio, 
    required this.wavePhase, 
    required this.tilt, 
    required this.colorCyan, 
    required this.colorRed, 
    required this.dots,
    required this.showBubbles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. RED (Background)
    Paint redPaint = Paint()
      ..shader = RadialGradient(
        colors: [colorRed.withOpacity(0.9), colorRed.withOpacity(0.4)],
        center: Alignment.bottomRight,
        radius: 1.2
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), redPaint);

    // 2. CYAN (Foreground)
    Paint cyanPaint = Paint()
      ..shader = RadialGradient(
        colors: [colorCyan.withOpacity(0.9), colorCyan.withOpacity(0.4)],
        center: Alignment.topLeft,
        radius: 1.2
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path cyanPath = Path();
    double extraWidth = size.width * 0.6;
    double drawWidth = size.width + (extraWidth * 2);
    double baseHeight = size.height * (1.0 - ratio);

    cyanPath.moveTo(-extraWidth, size.height);
    for (double x = -extraWidth; x <= drawWidth; x+=5) {
      double y = baseHeight + 5.0 * math.sin((x * 0.02) + wavePhase); 
      cyanPath.lineTo(x, y);
    }
    cyanPath.lineTo(drawWidth, size.height);
    cyanPath.lineTo(-extraWidth, size.height);
    cyanPath.close();

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(tilt); 
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawPath(cyanPath, cyanPaint);

    // ✅ FEATURE 2: Only draw bubbles if active
    if (showBubbles) {
      Paint dotPaint = Paint()..color = Colors.white.withOpacity(0.6);
      for (var d in dots) {
        canvas.drawCircle(Offset(size.width/2 + d.x, size.height/2 + d.y), d.size, dotPaint);
      }
    }
    
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}