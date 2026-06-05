import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/heuristic_engine.dart';
import '../models/component_model.dart';
import '../Screens/simulator/os_screen.dart';

// ==========================================
// 1. BOOT LOGIC & MODELS
// ==========================================

enum BootStatus {
  incomplete,       // Missing essential parts
  psuExplosion,     // Wattage exceeded
  noDisplay,        // F-series CPU + No GPU
  bottleneckWarning,// >30% bottleneck
  success           // Safe to boot
}

class BootResult {
  final BootStatus status;
  final String title;
  final String message;
  final double? bottleneckPercentage;

  BootResult({
    required this.status,
    required this.title,
    required this.message,
    this.bottleneckPercentage,
  });
}

class BootLogic {
  // ✅ THE NEW MASTER FUNCTION
  static BootResult runBootSequence({
    required Cpu? cpu,
    required Gpu? gpu,
    required Motherboard? mobo,
    required Ram? ram,
    required Storage? storage,
    required Psu? psu,
    required Cooler? cooler,
  }) {
    
    // 1. COMPLETENESS CHECK
    if (cpu == null || mobo == null || ram == null || storage == null || psu == null) {
      return BootResult(
        status: BootStatus.incomplete,
        title: "Build Incomplete",
        message: "You must install CPU, Motherboard, RAM, Storage, and PSU before booting.",
      );
    }

    // 2. CALCULATE BOTTLENECK
    final report = HeuristicEngine.calculateFullBottleneck(
      cpu: cpu, gpu: gpu, mobo: mobo, cooler: cooler, storage: storage, ram: ram,
    );
    final double calculatedBottleneck = report["percentage"];

    // 3. RUN HEALTH CHECK
    return _checkSystemHealth(
      cpu: cpu,
      gpu: gpu,
      psu: psu,
      bottleneckPercentage: calculatedBottleneck,
      totalWatts: HeuristicEngine.calculateTotalWattage(
        cpu: cpu, mobo: mobo, ram: ram, storage: storage, gpu: gpu, cooler: cooler
      ),
    );
  }

  static BootResult _checkSystemHealth({
    required Cpu cpu,
    required Gpu? gpu,
    required Psu psu,
    required double bottleneckPercentage,
    required int totalWatts,
  }) {
    
    // RULE 1: EXPLOSION
    if (totalWatts > psu.wattage) {
      return BootResult(
        status: BootStatus.psuExplosion,
        title: "SYSTEM FAILURE",
        message: "CRITICAL: Power Supply Overload!\n\nSystem needs ${totalWatts}W, but PSU provides ${psu.wattage}W.",
      );
    }

    // RULE 2: BLACK SCREEN (No Video)
    bool cpuHasGraphics = !cpu.name.toUpperCase().endsWith('F') && 
                          !cpu.name.toUpperCase().endsWith('KF');
    if (!cpuHasGraphics && gpu == null) {
      return BootResult(
        status: BootStatus.noDisplay,
        title: "NO DISPLAY SIGNAL",
        message: "The ${cpu.name} processor lacks integrated graphics.\nYou must equip a Discrete GPU.",
      );
    }

    // RULE 3: BOTTLENECK
    if (bottleneckPercentage > 30.0) {
      return BootResult(
        status: BootStatus.bottleneckWarning,
        title: "SYSTEM UNSTABLE",
        message: "Severe Bottleneck (${bottleneckPercentage.toStringAsFixed(1)}%). System may crash.",
        bottleneckPercentage: bottleneckPercentage,
      );
    }

    // RULE 4: SUCCESS
    return BootResult(
      status: BootStatus.success,
      title: "SYSTEM NORMAL",
      message: "Boot sequence initiated...",
    );
  }
}// ==========================================
// 2. BOOT SEQUENCE UI SCREEN
// ==========================================

class BootSequenceScreen extends StatefulWidget {
  final BootResult bootResult;
  final Cpu? cpu;
  final Gpu? gpu;
  final Ram? ram;
  final Motherboard? mobo;
  final Psu? psu;
  final Storage? storage;
  final Cooler? cooler;

  const BootSequenceScreen({
    super.key,
    required this.bootResult,
    this.cpu,
    this.gpu,
    this.ram,
    this.mobo,
    this.psu,
    this.storage,
    this.cooler,
  });

  @override
  State<BootSequenceScreen> createState() => _BootSequenceScreenState();
}

class _BootSequenceScreenState extends State<BootSequenceScreen> {
  late VideoPlayerController _controller;
  bool _isVideoFinished = false;
  bool _showWelcomeScreen = false; // ✅ NEW: Tracks if we should show the welcome text

  static const Color neonRed = Color(0xFFFF003C);
  static const Color neonCyan = Color(0xFF00F3FF); // ✅ Added Cyan for the Welcome screen

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/boot.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((error) {
        debugPrint("CRITICAL VIDEO ERROR: $error"); 
      });

    _controller.addListener(() {
      if (_controller.value.isInitialized && !_isVideoFinished) {
        if (_controller.value.position >= const Duration(seconds: 4) || 
            _controller.value.position >= _controller.value.duration) {
          
          _controller.pause(); 
          _handleVideoComplete();
        }
      }
    });
  }

  void _handleVideoComplete() {
    setState(() {
      _isVideoFinished = true;
    });

    if (widget.bootResult.status == BootStatus.success) {
      // ✅ 1. Show the Welcome Screen
      setState(() {
        _showWelcomeScreen = true;
      });

      // ✅ 2. Wait exactly 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          // ✅ 3. Navigate to the OS
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OsScreen(
                cpu: widget.cpu,
                gpu: widget.gpu,
                ram: widget.ram,
                mobo: widget.mobo,
                psu: widget.psu,
                storage: widget.storage,
                cooler: widget.cooler,
              ),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. VIDEO PLAYER (Hides immediately when finished)
          if (!_isVideoFinished)
            Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const SizedBox(),
            ),

          // ✅ 2. THE WELCOME SCREEN (Shows for 2 seconds on success)
          if (_showWelcomeScreen)
            Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800), // Smooth fade in
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "WELCOME TO",
                          style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 16, letterSpacing: 4),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "SPYDAR OS",
                          style: GoogleFonts.orbitron(
                            color: neonCyan, 
                            fontSize: 32, 
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                            shadows: [
                              Shadow(color: neonCyan.withOpacity(0.6), blurRadius: 20)
                            ]
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 150,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white10,
                            color: neonCyan,
                            minHeight: 2,
                          ),
                        )
                      ],
                    ),
                  );
                }
              ),
            ),

          // 3. THE BIOS ERROR SCREEN (Shows on failure)
          if (_isVideoFinished && widget.bootResult.status != BootStatus.success)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container( 
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: neonRed, width: 1.5),
                    boxShadow: [
                      BoxShadow(color: neonRed.withOpacity(0.15), blurRadius: 30)
                    ]
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: neonRed, size: 28),
                          const SizedBox(width: 15),
                          Text(
                            "BOOT_ERROR", 
                            style: GoogleFonts.shareTechMono(color: neonRed, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1)
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Divider(color: Colors.white24, height: 1),
                      ),
                      Text(
                        "[ DIAGNOSTIC ] : ${widget.bootResult.title}",
                        style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.bootResult.message,
                        style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14, height: 1.5),
                      ),
                      const SizedBox(height: 20),
                      if (widget.bootResult.bottleneckPercentage != null)
                        Text(
                          "Cannot Proceed.",
                          style: GoogleFonts.shareTechMono(color: const Color.fromARGB(255, 255, 255, 255), fontSize: 14),
                        ),
                      
                      const SizedBox(height: 35), 
                      
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: neonRed.withOpacity(0.08), 
                            border: Border.all(color: neonRed.withOpacity(0.5)),
                          ),
                          child: Text(
                            "ACKNOWLEDGE",
                            style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 15, letterSpacing: 3, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}