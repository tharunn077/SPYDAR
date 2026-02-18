import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import '../../models/component_model.dart';
import '../../data/games_db.dart';

// ==========================================
// SCREEN 1: THE DASHBOARD (Standard - UNTOUCHED)
// ==========================================
class BenchmarkScreen extends StatelessWidget {
  final Cpu cpu;
  final Gpu? gpu;
  final Ram ram;
  final Storage storage;

  const BenchmarkScreen({
    super.key,
    required this.cpu,
    required this.gpu,
    required this.ram,
    required this.storage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 600;
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 6, child: _buildTargetSystemBox()),
                        const SizedBox(width: 30),
                        Expanded(flex: 4, child: _buildActionBox(context)),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildTargetSystemBox(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: _buildActionBox(context),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTargetSystemBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.radar, color: Colors.redAccent, size: 18),
            const SizedBox(width: 6),
            Text("TARGET SYSTEM",
                style: GoogleFonts.orbitron(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              _buildSpecRow("PROCESSOR", cpu.name, Icons.memory),
              const Divider(color: Colors.white10, height: 6),
              _buildSpecRow("GRAPHICS", gpu?.name ?? "Integrated Graphics", Icons.videogame_asset),
              const Divider(color: Colors.white10, height: 6),
              _buildSpecRow("MEMORY", "${ram.capacity}GB ${ram.type}", Icons.speed),
              const Divider(color: Colors.white10, height: 6),
              _buildSpecRow("STORAGE", "${storage.capacity}GB ${storage.type}", Icons.storage),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionBox(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("READY FOR STRESS TEST",
            style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 10, letterSpacing: 1.5)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenResult(cpu: cpu, gpu: gpu, ram: ram, storage: storage),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5252), Color(0xFFB71C1C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.redAccent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text("RUN SIMULATION",
                    style: GoogleFonts.orbitron(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white38, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// SCREEN 2: THE NETFLIX LANES ENGINE (With Verdict)
// ==========================================
class FullScreenResult extends StatefulWidget {
  final Cpu cpu;
  final Gpu? gpu;
  final Ram ram;
  final Storage storage;

  const FullScreenResult({
    super.key,
    required this.cpu,
    required this.gpu,
    required this.ram,
    required this.storage,
  });

  @override
  State<FullScreenResult> createState() => _FullScreenResultState();
}

class _FullScreenResultState extends State<FullScreenResult> {
  bool _isLoading = true;
  
  // Data Containers
  List<Map<String, dynamic>> _esports = [];
  List<Map<String, dynamic>> _aaaTitles = [];
  List<Map<String, dynamic>> _workstation = [];

  // Verdict Variables
  String _grade = "B";
  String _mainBottleneck = "BALANCED";
  Color _gradeColor = Colors.cyanAccent; // Changed to match blue theme

  @override
  void initState() {
    super.initState();
    _runLogic();
  }

  // --- SMART DIAGNOSIS ENGINE ---
  String _getSmartDiagnosis(String gameName, String limiter, double fps, bool isWorkstation) {
    if (isWorkstation) {
       if (fps < 500) return "Multi-Core Bottleneck. Rendering tasks require high thread counts (i7/Ryzen 7+).";
       return "High IPC & Multi-threading detected. Workstation grade performance.";
    }

    switch (gameName) {
      case "Black Myth: Wukong":
      case "Cyberpunk 2077":
        if (limiter == "GPU") return "Lumen/Ray Tracing Overload. GPU Compute Units saturated.";
        return "Asset Streaming Lag. CPU unable to feed geometry to GPU fast enough.";
      
      case "Spider-Man 2":
        if (limiter == "GPU") return "VRAM Saturated. High-Res textures exceeding video memory.";
        return "Traversal Stutter. CPU/SSD too slow for open-world streaming.";
      
      case "Valorant":
      case "CS:GO 2":
      case "League of Legends":
        if (limiter == "CPU") return "Single-Core Speed Limit. Esports engines prefer High GHz over Core Count.";
        return "Uncapped Frame Rate. System latency is minimal.";

      case "Forza Horizon 5":
      case "GTA V":
      case "Fortnite":
        if (limiter == "GPU") return "Rasterization Limit. Shader complexity high for this resolution.";
        return "Physics/AI Calculation Lag. CPU struggling with open-world logic.";

      default:
        return limiter == "CPU" ? "CPU Logic Bound." : "GPU Compute Bound.";
    }
  }

  void _runLogic() async {
    await Future.delayed(const Duration(seconds: 2));
    
    List<Map<String, dynamic>> esportsTemp = [];
    List<Map<String, dynamic>> aaaTemp = [];
    List<Map<String, dynamic>> workstationTemp = [];

    int cpuStrikes = 0;
    int gpuStrikes = 0;
    double totalFps = 0;
    int gameCount = 0;

    for (var app in benchmarkGames) {
      // Logic Calculation
      int userCpuScore = (app.category == "Workstation") ? widget.cpu.workstationScore : widget.cpu.gamingScore;
      int userGpuScore = widget.gpu?.performanceScore ?? 15;
      
      double cpuRatio = userCpuScore / (app.recCpuScore > 0 ? app.recCpuScore : 1);
      double gpuRatio = userGpuScore / (app.recGpuScore > 0 ? app.recGpuScore : 1);
      
      String limiter = (cpuRatio < gpuRatio) ? "CPU" : "GPU";
      if (app.category == "Workstation") limiter = "CPU"; 

      if (limiter == "CPU") cpuStrikes++; else gpuStrikes++;

      double performanceRatio = (app.category == "Workstation") ? cpuRatio : min(cpuRatio, gpuRatio);
      double fps = 60 * performanceRatio;
      
      if (widget.ram.capacity < app.recRamGB) fps *= 0.7;
      if (app.needsSSD && widget.storage.type == 'HDD') fps *= 0.5;
      if (fps > 240) fps = 240;

      if (app.category != "Workstation") {
        totalFps += fps;
        gameCount++;
      }

      // --- NEW COLOR LOGIC (Blue Border / Red Text) ---
      // We force the border color to be Cyan/Blue for that "Cyber" look
      Color borderColor = Colors.cyanAccent; 
      // We force status text to be Red as requested
      Color statusTextColor = Colors.redAccent; 

      String status;
      if (app.category == "Workstation") {
        int score = (1000 * performanceRatio).toInt();
        if (score > 800) status = "EXCELLENT"; 
        else if (score > 400) status = "GOOD"; 
        else status = "WEAK CPU";
      } else {
        if (fps >= 60) status = "SMOOTH"; 
        else if (fps >= 30) status = "PLAYABLE"; 
        else status = "$limiter LIMIT";
      }

      String techAnalysis = _getSmartDiagnosis(app.name, limiter, (app.category == "Workstation" ? 1000 * performanceRatio : fps), app.category == "Workstation");

      var itemData = {
        'name': app.name,
        'value': app.category == "Workstation" ? (1000 * performanceRatio).toInt().toString() : fps.toInt().toString(),
        'unit': app.category == "Workstation" ? "pts" : "FPS",
        'color': borderColor,      // BLUE OUTLINE
        'textColor': statusTextColor, // RED TEXT
        'status': status,
        'techAnalysis': techAnalysis,
        'imagePath': app.imagePath,
      };

      if (app.category == "Esports") esportsTemp.add(itemData);
      else if (app.category == "Workstation") workstationTemp.add(itemData);
      else aaaTemp.add(itemData);
    }

    // Verdict Logic
    if (gpuStrikes > cpuStrikes) { _mainBottleneck = "GPU BOTTLENECK"; } 
    else if (cpuStrikes > gpuStrikes) { _mainBottleneck = "CPU BOTTLENECK"; } 
    else { _mainBottleneck = "BALANCED"; } // Shortened text for compact UI

    double avgFps = (gameCount > 0) ? totalFps / gameCount : 0;
    if (avgFps >= 100) _grade = "S"; 
    else if (avgFps >= 60) _grade = "A"; 
    else if (avgFps >= 45) _grade = "B"; 
    else if (avgFps >= 30) _grade = "C"; 
    else _grade = "F"; 

    if (mounted) {
      setState(() {
        _isLoading = false;
        _esports = esportsTemp;
        _aaaTitles = aaaTemp;
        _workstation = workstationTemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator(color: Colors.redAccent)));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("DIAGNOSTICS", style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- VERDICT HEADER (COMPACT VERSION) ---
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Reduced Margin
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Reduced Padding
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12), // Smaller radius
                border: Border.all(color: _gradeColor.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Grade Section
                  Row(
                    children: [
                      Text("GRADE: ", style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 14)),
                      Text(_grade, style: GoogleFonts.orbitron(color: _gradeColor, fontSize: 32, fontWeight: FontWeight.bold)), // Smaller Font
                    ],
                  ),
                  // Limiter Section
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: Text(_mainBottleneck, style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),

            // --- LANES ---
            _buildLaneHeader("ESPORTS PERFORMANCE", Icons.bolt),
            _buildHorizontalLane(_esports),
            const SizedBox(height: 20), // Tighter spacing

            _buildLaneHeader("HEAVY HITTERS (AAA)", Icons.videogame_asset),
            _buildHorizontalLane(_aaaTitles),
            const SizedBox(height: 20),

            _buildLaneHeader("CREATOR WORKFLOW", Icons.design_services),
            _buildHorizontalLane(_workstation),
            
            const SizedBox(height: 30),

            // --- TWEAK BUTTON ---
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context), 
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  decoration: BoxDecoration(
                    color: _gradeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: _gradeColor),
                  ),
                  child: Text("TWEAK BUILD", style: GoogleFonts.orbitron(color: _gradeColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLaneHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 14),
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
        ],
      ),
    );
  }

  Widget _buildHorizontalLane(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 140, // Reduced Height for compactness
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: HeroTile(item: items[index]),
          );
        },
      ),
    );
  }
}

// ==========================================
// TILE WIDGET (UPDATED FOR BLUE BORDER / RED TEXT)
// ==========================================
class HeroTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const HeroTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            transitionDuration: const Duration(milliseconds: 600),
            reverseTransitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => HeroDetailScreen(item: item),
          ),
        );
      },
      child: Hero(
        tag: item['name'],
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200, 
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              // BLUE OUTLINE (Using item['color'] which is now set to Cyan/Blue)
              border: Border.all(color: item['color'].withOpacity(0.8), width: 1.5),
              boxShadow: [BoxShadow(color: item['color'].withOpacity(0.1), blurRadius: 10)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  if (item['imagePath'] != null)
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(item['imagePath'], fit: BoxFit.cover),
                      ),
                    ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(item['value'], style: GoogleFonts.orbitron(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Text(item['unit'], style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 10)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(item['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 12)),
                        const SizedBox(height: 4),
                        // RED STATUS TEXT
                        Text(item['status'], style: GoogleFonts.shareTechMono(color: item['textColor'], fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// DETAIL POPUP (COMPACT VERSION)
// ==========================================
class HeroDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;
  const HeroDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Hero(
            tag: item['name'],
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7, 
                height: 330,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: item['color'], width: 2),
                  boxShadow: [BoxShadow(color: item['color'].withOpacity(0.2), blurRadius: 40)],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['name'], 
                      textAlign: TextAlign.center, 
                      style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Text(item['value'], 
                      style: GoogleFonts.orbitron(color: item['color'], fontSize: 60, fontWeight: FontWeight.bold)),
                    Text(item['unit'], 
                      style: GoogleFonts.shareTechMono(color: Colors.grey, fontSize: 14)),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.analytics_outlined, color: Colors.white70, size: 14),
                              const SizedBox(width: 8),
                              Text("DIAGNOSIS", style: GoogleFonts.shareTechMono(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(item['techAnalysis'], 
                            textAlign: TextAlign.center, 
                            style: GoogleFonts.roboto(color: Colors.white, height: 1.3, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Text("TAP TO CLOSE", style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 10)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}