import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:ui';
import '../../models/component_model.dart';
import '../../data/games_db.dart';
import '../simulator/widgets/glitters.dart';

// ==========================================
// SCREEN 1: THE DASHBOARD
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
      body: Stack(
        children: [
          const Positioned.fill(
            child: CyberGlitters(),
          ),
          Positioned.fill(
            child: LayoutBuilder(
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
          ),
        ],
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
            const SizedBox(width: 6),
            Text("TARGET SYSTEM",
                style: GoogleFonts.orbitron(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
// SCREEN 2: THE RESULTS ENGINE
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
  String _resolution = "1080p"; 
  
  List<Map<String, dynamic>> _esports = [];
  List<Map<String, dynamic>> _aaaTitles = [];
  List<Map<String, dynamic>> _workstation = [];

  String _grade = "B";

  @override
  void initState() {
    super.initState();
    _runLogic();
  }

  void _runLogic() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); 
    
    List<Map<String, dynamic>> esportsTemp = [];
    List<Map<String, dynamic>> aaaTemp = [];
    List<Map<String, dynamic>> workstationTemp = [];

    double totalFps = 0;
    int gameCount = 0;

    for (var app in benchmarkGames) {
      // Direct 0-100 raw scores from your hardware models
      double cScore = (app.category == "Workstation") ? widget.cpu.workstationScore.toDouble() : widget.cpu.gamingScore.toDouble();
      double gScore = widget.gpu?.performanceScore.toDouble() ?? 15.0;

      double fps = 0;
      double workstationPts = 0;
      
      if (app.category == "Esports") {
        // Simple mapping: 80 base + CPU push + minor GPU push
        fps = 80.0 + (cScore * 4.5) + (gScore * 1.5);
        if (_resolution == "4K") fps *= 0.65;
      } 
      else if (app.category == "Workstation") {
        // Simple mapping: 300 base + heavy CPU focus
        workstationPts = 300.0 + (cScore * 12.0) + (gScore * 5.0);
      } 
      else {
        // AAA Games: 20 base + minor CPU push + heavy GPU push
        fps = 20.0 + (cScore * 0.4) + (gScore * 1.4);

        // Simple hardcoded modifiers to prevent identical FPS for different games
        String name = app.name.toLowerCase();
        if (name.contains("wukong") || name.contains("cyberpunk") || name.contains("heavy")) {
          fps *= 0.85; // Penalty for heavy games
        } else if (name.contains("gta") || name.contains("forza") || name.contains("spider")) {
          fps *= 1.45; // Bonus for optimized/older games
        }

        if (_resolution == "4K") fps *= 0.50; // 4K cuts FPS in half
      }

      // Add tiny 2-5 FPS variation for realism
      if (app.category != "Workstation") {
        fps += (Random().nextDouble() * 6) - 3;
        if (fps < 15) fps = 15.0 + Random().nextDouble() * 5; // Absolute minimum floor
        
        totalFps += fps;
        gameCount++;
      }

      String status;
      if (app.category == "Workstation") {
        status = workstationPts > 1500 ? "ELITE" : (workstationPts > 800 ? "EXCELLENT" : "GOOD");
      } else {
        status = fps >= 144 ? "COMPETITIVE" : (fps >= 60 ? "SMOOTH" : (fps >= 30 ? "PLAYABLE" : "LIMIT"));
      }

      var itemData = {
        'name': app.name,
        'value': app.category == "Workstation" ? workstationPts.toInt().toString() : fps.toInt().toString(),
        'unit': app.category == "Workstation" ? "pts" : "FPS",
        'status': status,
        'imagePath': app.imagePath,
      };

      if (app.category == "Esports") esportsTemp.add(itemData);
      else if (app.category == "Workstation") workstationTemp.add(itemData);
      else aaaTemp.add(itemData);
    }

    double avgFps = (gameCount > 0) ? totalFps / gameCount : 0;
    if (avgFps >= 120) _grade = "S"; 
    else if (avgFps >= 80) _grade = "A"; 
    else if (avgFps >= 50) _grade = "B"; 
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
    if (_isLoading) return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)));

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        centerTitle: true, 
        title: Text(
          "SPYDAR MARK", 
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            shadows: const [
              Shadow(color: Colors.cyanAccent, blurRadius: 10),
              Shadow(color: Colors.cyanAccent, blurRadius: 20),
            ]
          )
        ),
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.cyanAccent), onPressed: () => Navigator.pop(context)),
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: CyberGlitters(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- VERDICT HEADER (Removed Bottleneck Text, Locked to Cyan) ---
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), 
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), 
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(12), 
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Text("OVERALL GRADE: ", style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 14)),
                        Text(_grade, style: GoogleFonts.orbitron(color: Colors.cyanAccent, fontSize: 32, fontWeight: FontWeight.bold)), 
                      ],
                    ),
                  ),

                  // --- RESOLUTION TOGGLES ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildResolutionButton("1080p", Icons.hd),
                        const SizedBox(width: 15),
                        _buildResolutionButton("4K", Icons.monitor),
                      ],
                    ),
                  ),

                  // --- LANES ---
                  _buildLaneHeader("ESPORTS PERFORMANCE ($_resolution)", Icons.bolt),
                  _buildHorizontalLane(_esports),
                  const SizedBox(height: 20), 

                  _buildLaneHeader("HEAVY HITTERS (AAA) ($_resolution)", Icons.videogame_asset),
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
                          color: Colors.cyanAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.cyanAccent),
                        ),
                        child: Text("TWEAK BUILD", style: GoogleFonts.orbitron(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionButton(String res, IconData icon) {
    bool isSelected = _resolution == res;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          setState(() {
            _resolution = res;
            _runLogic(); 
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.cyanAccent.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.cyanAccent : Colors.white24),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.cyanAccent : Colors.white54, size: 18),
            const SizedBox(width: 6),
            Text("ULTRA $res", style: GoogleFonts.orbitron(
              color: isSelected ? Colors.cyanAccent : Colors.white54, 
              fontSize: 12, 
              fontWeight: FontWeight.bold
            )),
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
          Icon(icon, color: Colors.cyanAccent, size: 14), // Changed to Cyan
          const SizedBox(width: 8),
          Text(title, style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
        ],
      ),
    );
  }

  Widget _buildHorizontalLane(List<Map<String, dynamic>> items) {
    return SizedBox(
      height: 140, 
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
// TILE WIDGET (REMOVED CLICK INTERACTION)
// ==========================================
class HeroTile extends StatelessWidget {
  final Map<String, dynamic> item;
  const HeroTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Removed GestureDetector and Hero tag entirely so it is completely unclickable
    return Container(
      width: 200, 
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.8), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.cyanAccent.withOpacity(0.1), blurRadius: 10)],
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
                  Text(item['status'], style: GoogleFonts.shareTechMono(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}