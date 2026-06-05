import 'dart:ui';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:video_player/video_player.dart'; 
import '../simulator/simulator_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LevelOneScreen extends StatefulWidget {
  const LevelOneScreen({super.key});

  @override
  State<LevelOneScreen> createState() => _LevelOneScreenState();
}

class _LevelOneScreenState extends State<LevelOneScreen> with SingleTickerProviderStateMixin {
  int bossHearts = 3;
  int currentPhase = 1;
  bool isGameOver = false;
  String currentFailQuote = ""; 
  
  bool _isExploding = false; 

  final GlobalKey simulatorKey = GlobalKey();

  VideoPlayerController? _videoController;
  bool isPlayingVideo = false;
  late AnimationController _shakeController;

  int dialogIndex = 0;

  // --- TIMER & UI STATE VARIABLES ---
  Timer? _countdownTimer;
  int _secondsRemaining = 20; // 20 Seconds
  
  Timer? _menuCheckTimer;
  bool _isMenuOpen = false;

  final List<Map<String, String>> phase1Dialogs = [
    {
      "speaker": "doc_ock",
      "name": "DOCO OCKO",
      "text": "My neural harness is starved! I demand CUDA cores and a massive Power Supply, or your system melts!"
    },
    {
      "speaker": "spiderman",
      "name": "SPYDAR",
      "text": "He's trying to trip the main breakers! I need to drop in any GPU having CUDA cores and a 750W+ PSU before he fries the board."
    }
  ];

  final List<Map<String, String>> phase2Dialogs = [
    {
      "speaker": "doc_ock",
      "name": "DOC OCKO",
      "text": "Enough! I have synchronized my strikes to a 4.0 GHz base frequency and I’m saturating every single PCIe lane with recursive garbage data!"
    },
    {
      "speaker": "doc_ock",
      "name": "DOC OCKO",
      "text": "If your storage isn't sitting directly on the CPU's high-speed lanes, you're just a sluggish glitch in my masterpiece!"
    },
    {
      "speaker": "spiderman",
      "name": "SPYDAR",
      "text": "Whoa, talk about a mid-life hardware crisis! If I don't match that clock cycle and clear the data fog, I'm toast..."
    },
    {
      "speaker": "spiderman",
      "name": "SPYDAR",
      "text": "...and if I don't handle the thermal overhead of this overclock, I’m gonna end up as a pile of melted solder!"
    }
  ];

  final List<Map<String, String>> phase3Dialogs = [
    {
      "speaker": "doc_ock",
      "name": "DOC OCKO",
      "text": "You've survived the flood, but you cannot survive the Latency! I am fragmenting your reality into a million unmapped sectors!"
    },
    {
      "speaker": "doc_ock",
      "name": "DOC OCKO",
      "text": "If your board isn't rated for Gen 5 bandwidth and your memory isn't pulsing at 6000 Mega-Transfers, you'll be dead before you can blink!"
    },
    {
      "speaker": "spiderman",
      "name": "SPYDAR",
      "text": "He's attacking the system's reaction time! If I don't get a DDR5 kit running at least 6000 MT/s, I'll be moving in slow motion..."
    },
    {
      "speaker": "spiderman",
      "name": "SPYDAR",
      "text": "But that memory won't mean a thing if my Motherboard can't handle the Gen 5 bus. I might have to rip out the whole heart of this rig to make them fit!"
    }
  ];

  List<Map<String, String>> get currentDialogList {
    if (currentPhase == 1) return phase1Dialogs;
    if (currentPhase == 2) return phase2Dialogs;
    return phase3Dialogs;
  }
  
  bool get isTalking => dialogIndex < currentDialogList.length;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    
    // THE HUD ZAPPER POLLER (Now correctly uses your new bridge)
    _menuCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      try {
        final simState = simulatorKey.currentState as dynamic;
        if (simState != null) {
          // 1. Get the currently selected slot name from the simulator
          String? slot = simState.selectedSlot; 
          
          // 2. Define which components open the menu on the RIGHT
          const rightDockItems = ["CPU", "MOTHER\nBOARD", "RAM", "COOLER"];
          
          // 3. Only set _isMenuOpen to true if it's one of those items
          bool isRightMenuOpen = slot != null && rightDockItems.contains(slot);

          if (isRightMenuOpen != _isMenuOpen && mounted) {
            setState(() { _isMenuOpen = isRightMenuOpen; });
          }
        }
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _menuCheckTimer?.cancel();
    _shakeController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  // --- FORCE CLOSE MENU LOGIC ---
  void _forceCloseMenu() {
    try {
      final simState = simulatorKey.currentState as dynamic;
      if (simState?.isMenuOpen == true) {
        simState.closeMenuExternal(); // Uses the new bridge!
        setState(() { _isMenuOpen = false; });
      }
    } catch (e) {
      // Ignored safely
    }
  }

  // --- TIMER LOGIC ---
  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = 20); // Reset to 20

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _countdownTimer?.cancel();
        // TIMER OUT: Play video first!
        _triggerGameOver('"Too slow, Spydar! Your hesitation has cost you the mainframe!"');
      }
    });
  }

  void _advanceDialog() {
    setState(() {
      dialogIndex++;
      if (!isTalking) {
        _startTimer(); 
      }
    });
  }

  void _triggerGameOver(String quote) {
    _countdownTimer?.cancel();
    _forceCloseMenu(); // Zap away menu 
    currentFailQuote = quote; 
    
    // PLAY CINEMATIC FIRST!
    _playCinematic(false, quote); 
  }

  // --- THE MASTER ATTACK LOGIC ---
  void _checkBuild() {
    _countdownTimer?.cancel(); 
    _forceCloseMenu(); // Force menu closed
    
    final simState = simulatorKey.currentState as dynamic;
    if (simState == null) return;

    bool isCorrectBuild = false;
    String failQuote = '"System Failure."';

    if (currentPhase == 1) {
      final gpu = simState.currentGpu;
      final psu = simState.currentPsu;

      if (gpu != null && psu != null) {
        bool isNvidia = gpu.name.toUpperCase().contains('NVIDIA') || 
                        gpu.name.toUpperCase().contains('RTX') || 
                        gpu.name.toUpperCase().contains('GTX');
        if (isNvidia && psu.wattage >= 750) {
          isCorrectBuild = true;
        } else {
          failQuote = '"A bottleneck? You insult my genius with this pathetic hardware! The mainframe is MINE!"';
        }
      } else {
        failQuote = '"Incomplete system! You cannot fight me with missing components!"';
      }

    } else if (currentPhase == 2) {
      final cpu = simState.currentCpu;
      final storage = simState.currentStorage;
      final cooler = simState.currentCooler;

      if (cpu != null && storage != null) {
        bool hasFrequency = cpu.baseClock >= 4.0 || cpu.boostClock >= 4.0; 
        bool hasM2 = storage.format == "M.2";
        bool hasThermalStability = cooler != null && cooler.computedTdp >= cpu.tdp;

        if (hasFrequency && hasM2 && hasThermalStability) {
          isCorrectBuild = true;
        } else if (!hasFrequency) {
          failQuote = '"Too slow! Your clock cycles are prehistoric!"';
        } else if (!hasM2) {
          failQuote = '"SATA? How quaint. You brought a tricycle to a warp-speed dogfight!"';
        } else if (!hasThermalStability) {
          failQuote = '"I smell smoke, Spydar. Your \'heroism\' just hit 100 degrees Celsius."';
        }
      } else {
        failQuote = '"Incomplete system! You cannot fight me with missing components!"';
      }

    } else if (currentPhase == 3) {
      final cpu = simState.currentCpu;
      final mobo = simState.currentMotherboard;
      final ram = simState.currentRam;

      if (cpu != null && mobo != null && ram != null) {
        bool hasBusSpeed = mobo.pcieGen >= 5;
        bool hasMemorySpeed = ram.speed >= 6000;
        
        bool isCompatible = (cpu.socket.toUpperCase() == mobo.socket.toUpperCase()) && 
                            (ram.type.toUpperCase() == mobo.memoryType.toUpperCase());

        if (hasBusSpeed && hasMemorySpeed && isCompatible) {
          isCorrectBuild = true;
        } else if (!isCompatible) {
          failQuote = '"A hardware mismatch! You tried to force a build that won\'t even POST!"';
        } else if (!hasBusSpeed) {
          failQuote = '"Gen 4? Your motherboard is too slow to track my neural interface!"';
        } else if (!hasMemorySpeed) {
          failQuote = '"Latency death! Your RAM is lagging behind my superior intellect!"';
        }
      } else {
        failQuote = '"Incomplete system! I expected more from a \'hero.\'"';
      }
    }

    _playCinematic(isCorrectBuild, failQuote);
  }

  Future<void> _playCinematic(bool isSuccess, String failQuote) async {
    if (!isSuccess) {
      currentFailQuote = failQuote;
    }

    String videoPath = isSuccess ? 'assets/spidey_attack_doc.mp4' : 'assets/doc_attack.mp4';
    
    _videoController = VideoPlayerController.asset(videoPath);
    await _videoController!.initialize();
    
    setState(() {
      isPlayingVideo = true;
    });
    
    _videoController!.play();

    _videoController!.addListener(() {
      if (_videoController!.value.position == _videoController!.value.duration) {
        if (isPlayingVideo) {
          _finishAttackSequence(isSuccess);
        }
      }
    });
  }

  void _finishAttackSequence(bool isSuccess) {
    setState(() {
      isPlayingVideo = false;
    });
    
    _videoController?.dispose();
    _videoController = null;

    if (isSuccess) {
      HapticFeedback.heavyImpact();
      _shakeController.forward(from: 0.0);

      setState(() {
        _isExploding = true;
      });

      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() {
          _isExploding = false;
          bossHearts--;
          
          if (bossHearts > 0) {
            currentPhase++;
            dialogIndex = 0; 
          } else {
            _showVictoryScreen();
          }
        });
      });
      
    } else {
      // GAME OVER STATE ONLY TRIGGERED AFTER VIDEO ENDS
      setState(() {
        isGameOver = true;
      });
    }
  }

  void _restartLevel() {
    setState(() {
      isGameOver = false;
      bossHearts = 3;
      currentPhase = 1;
      dialogIndex = 0;
      _isExploding = false;
      _secondsRemaining = 20;
    });
    _forceCloseMenu(); // Ensure the simulator starts clean
  }

void _showVictoryScreen() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: const Color(0xFF050505),
          contentPadding: const EdgeInsets.fromLTRB(20, 25, 20, 10), // Tightened padding
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
            borderRadius: BorderRadius.circular(16),
          ),
          // We removed the 'title:' parameter to kill the default hidden gap
          // SingleChildScrollView guarantees NO bottom overflow errors
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. MOVED TITLE HERE for perfect spacing control
                const Text("MISSION COMPLETE", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.cyanAccent, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: 4,
                    fontSize: 18,
                    shadows: [Shadow(color: Colors.cyanAccent, blurRadius: 12.0)]
                  )
                ),
                const SizedBox(height: 10), // Tightly controlled gap
                
                // 2. Neon Divider
                Container(
                  height: 1,
                  width: 150,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.cyanAccent, Colors.transparent],
                    ),
                  ),
                ),
                const SizedBox(height: 15), // Reduced from 25
                
                // 3. Reward Text
                const Text("REWARD UNLOCKED", 
                  style: TextStyle(
                    color: Colors.redAccent, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 14,
                    letterSpacing: 2,
                    shadows: [Shadow(color: Colors.redAccent, blurRadius: 8.0)]
                  )
                ),
                const SizedBox(height: 10), // Reduced from 15
                
                // 4. THE MISSION REWARD IMAGE
                Container(
                  padding: const EdgeInsets.all(4), 
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.5), width: 1),
                    boxShadow: [
                      BoxShadow(color: Colors.redAccent.withOpacity(0.1), blurRadius: 20.0, spreadRadius: 5.0)
                    ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset('assets/doc_ock_bg.png', height: 80, width: 160, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 12),
                const Text("DOC OCK BACKGROUND", 
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2)
                ),
                const SizedBox(height: 8), // Reduced from 20
              ],
            ),
          ),
         actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.cyanAccent, width: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    backgroundColor: Colors.cyanAccent.withOpacity(0.05),
                  ),
                  // ✅ FIXED: Saves the unlock state to local storage before closing!
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('doc_ock_unlocked', true);
                    
                    if (!context.mounted) return;
                    Navigator.pop(context); 
                    Navigator.pop(context); 
                  },
                  child: const Text("PROCEED TO MAP", 
                    style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13)
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDialog = isTalking ? currentDialogList[dialogIndex] : null;
    final isDocOck = currentDialog?['speaker'] == 'doc_ock';

    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final dx = math.sin(_shakeController.value * math.pi * 8) * (1.0 - _shakeController.value) * 20;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF050505),
        body: Stack(
          children: [
            // LAYER 1: SIMULATOR
            Positioned.fill(
              child: SimulatorScreen(key: simulatorKey, hidePowerButton: true),
            ),

            // LAYER 2: OVERLAY FOR DIALOGUE 
            if (isTalking && !isGameOver && !isPlayingVideo)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _advanceDialog,
                  child: Container(color: Colors.black.withOpacity(0.75)),
                ),
              ),

           // LAYER 3: HEALTH BAR (ZAPS AWAY WHEN MENU OPENS)
            if (!isGameOver && !isPlayingVideo && !isTalking)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                top: 110, 
                right: _isMenuOpen ? -150 : 30, // Hides completely off-screen
                child: Column(
                  children: List.generate(3, (index) {
                    bool isCellActive = index < bossHearts;
                    bool isThisCellExploding = _isExploding && index == bossHearts - 1;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      // 1. FIX: Changed from easeOutBack to easeOut to prevent negative bouncing!
                      curve: Curves.easeOut, 
                      margin: const EdgeInsets.only(bottom: 8), 
                      width: isThisCellExploding ? 35 : 20, 
                      height: isThisCellExploding ? 35 : 40, 
                      decoration: BoxDecoration(
                        color: isThisCellExploding ? Colors.white : (isCellActive ? Colors.redAccent.withOpacity(0.8) : Colors.transparent),
                        borderRadius: BorderRadius.circular(isThisCellExploding ? 20 : 4),
                        border: Border.all(
                          color: isThisCellExploding ? Colors.cyanAccent : (isCellActive ? Colors.redAccent : Colors.grey.withOpacity(0.3)), 
                          width: 2
                        ),
                        // 2. FIX: Provided a safe 0.0 fallback instead of an empty list []
                        boxShadow: (isCellActive || isThisCellExploding) && !isTalking 
                            ? [BoxShadow(color: isThisCellExploding ? Colors.cyanAccent : Colors.redAccent.withOpacity(0.6), blurRadius: isThisCellExploding ? 20.0 : 10.0, spreadRadius: isThisCellExploding ? 5.0 : 2.0)] 
                            : [const BoxShadow(color: Colors.transparent, blurRadius: 0.0, spreadRadius: 0.0)],
                      ),
                      child: isThisCellExploding ? const Center(child: Icon(Icons.flash_on, color: Colors.cyanAccent, size: 20)) : null,
                    );
                  }),
                ),
              ),

            // LAYER 4: TIMER (ZAPS AWAY WHEN MENU OPENS)
          // LAYER 4: TIMER (STAYING STILL)
if (!isTalking && !isGameOver && !isPlayingVideo)
  Positioned( // Changed from AnimatedPositioned to Positioned
    top: 290, 
    left: 15, // Fixed value so it doesn't move
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _secondsRemaining <= 5 ? Colors.redAccent : Colors.cyanAccent, 
          width: 1
        ),
        boxShadow: _secondsRemaining <= 5 ? [BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 10)] : [],
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: _secondsRemaining <= 5 ? Colors.redAccent : Colors.cyanAccent, size: 18),
          const SizedBox(width: 8),
          Text(
            "00:${_secondsRemaining.toString().padLeft(2, '0')}",
            style: TextStyle(
              color: _secondsRemaining <= 5 ? Colors.redAccent : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    ),
  ),
            // LAYER 5: CHARACTERS
            if (isTalking && !isGameOver && !isPlayingVideo) ...[
              Positioned(left: -20, bottom: -10, child: Image.asset('assets/spider_convo.png', height: 250, fit: BoxFit.contain)),
              Positioned(right: -20, bottom: -10, child: Image.asset('assets/docok.png', height: 260, fit: BoxFit.contain)),
            ],

           // LAYER 6: DIALOGUE BOX
            if (isTalking && !isGameOver && !isPlayingVideo)
              Positioned(
                bottom: 30, left: isDocOck ? null : 150, right: isDocOck ? 150 : null, 
                child: GestureDetector(
                  onTap: _advanceDialog, // ✅ Added tap detection to the dialogue box itself
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 260), 
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDocOck ? Colors.redAccent.withOpacity(0.15) : Colors.blueAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isDocOck ? Colors.redAccent : Colors.cyanAccent, width: 2),
                            boxShadow: [BoxShadow(color: (isDocOck ? Colors.redAccent : Colors.cyanAccent).withOpacity(0.2), blurRadius: 15, spreadRadius: 1)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, 
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (isDocOck ? Colors.redAccent : Colors.cyanAccent).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: (isDocOck ? Colors.redAccent : Colors.cyanAccent).withOpacity(0.5), width: 1),
                                ),
                                child: Text(currentDialog!['name']!, style: TextStyle(color: isDocOck ? Colors.redAccent : Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                              ),
                              const SizedBox(height: 10),
                              Text(currentDialog['text']!, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("TAP", style: TextStyle(color: (isDocOck ? Colors.redAccent : Colors.cyanAccent).withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.bold)),
                                    Icon(Icons.double_arrow_rounded, color: isDocOck ? Colors.redAccent : Colors.cyanAccent, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // LAYER 7: THE ATTACK BUTTON (ALWAYS VISIBLE)
            if (!isTalking && !isGameOver && !isPlayingVideo)
              Positioned( // ✅ Changed from AnimatedPositioned
                bottom: 30, 
                right: 20, // ✅ Fixed position so it never disappears
                child: GestureDetector(
                  onTap: _checkBuild,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.15), borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent, width: 2),
                      boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)],
                    ),
                    child: const Center(child: Text("ATTACK ➔", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 2))),
                  ),
                ),
              ),

            // LAYER 8: FULL SCREEN VIDEO CUTSCENE
            if (isPlayingVideo && _videoController != null && _videoController!.value.isInitialized)
              Positioned.fill(
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: AspectRatio(aspectRatio: _videoController!.value.aspectRatio, child: VideoPlayer(_videoController!)),
                  ),
                ),
              ),

            // LAYER 9: MINIMALIST GAME OVER (Only shows AFTER video ends)
            if (isGameOver && !isPlayingVideo)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    color: Colors.black.withOpacity(0.85), 
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.close_rounded, color: Colors.redAccent, size: 80),
                        const SizedBox(height: 16),
                        const Text("SYSTEM FAILURE", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 6)),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            currentFailQuote, 
                            textAlign: TextAlign.center, 
                            style: const TextStyle(color: Colors.grey, fontSize: 16, fontStyle: FontStyle.italic, height: 1.5)
                          ),
                        ),
                        const SizedBox(height: 50),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent, width: 1), 
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                          ),
                          onPressed: _restartLevel,
                          child: const Text("REBOOT SYSTEM", style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}