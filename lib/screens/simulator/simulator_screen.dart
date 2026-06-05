import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spydar/screens/simulator/os_screen.dart';
import '../../data/components_db.dart'; // Make sure this path points to your data folder
import '../../models/component_model.dart';
import 'package:flutter/services.dart';
import 'widgets/inventory_list.dart'; 
import '../../../logic/heuristic_engine.dart';
import 'widgets/cpu_performance_card.dart';
import 'widgets/gpu_performance_card.dart';
import 'widgets/sorting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../../../logic/boot.dart';

class SimulatorScreen extends StatefulWidget {
  // New: Accept the loaded build data (optional)
  final Map<String, dynamic>? loadedBuild; 
  final bool hidePowerButton; // <--- 1. ADD THIS LINE

  // 2. UPDATE THE CONSTRUCTOR TO LOOK LIKE THIS:
  const SimulatorScreen({super.key, this.loadedBuild, this.hidePowerButton = false});

  

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}


class _SimulatorScreenState extends State<SimulatorScreen> {
  
  // Neon palette
  String _currentWallpaper = 'assets/web.png';
  String? selectedSlot;
  Cpu? _previewCpu; // Stores the CPU currently being previewed
  Cpu? _equippedCpu;
  Motherboard? _equippedMotherboard; // ✅ Stores the installed board
  Motherboard? _previewMotherboard;
  List<Cpu> _currentCpuList = [];
  List<Motherboard> _currentMoboList = [];
  Ram? _equippedRam;
  Ram? _previewRam;
  List<Ram> _currentRamList = []; // For sorting
  Gpu? _equippedGpu;
  Gpu? _previewGpu;
  List<Gpu> _currentGpuList = [];
  Storage? _equippedStorage;
  Storage? _previewStorage;
  List<Storage> _currentStorageList = [];
  Psu? _equippedPsu;
Psu? _previewPsu;
List<Psu> _currentPsuList = ComponentsDB.psus;
Cooler? _equippedCooler;
Cooler? _previewCooler;
List<Cooler> _currentCoolerList = ComponentsDB.coolers;
bool _isSorting = false; 
final ScrollController _detailScrollController = ScrollController();
  

// For access in levels
  Gpu? get currentGpu => _equippedGpu;
  Psu? get currentPsu => _equippedPsu;
  Cpu? get currentCpu => _equippedCpu;
  Storage? get currentStorage => _equippedStorage;
  Cooler? get currentCooler => _equippedCooler;
  Ram? get currentRam => _equippedRam;
  Motherboard? get currentMotherboard => _equippedMotherboard;
  bool get isMenuOpen => selectedSlot != null;
  void closeMenuExternal() => _closeMenu();


  static const Color neonCyan = Color(0xFF00F3FF);
  static const Color neonRed = Color(0xFFFF003C);
  static const Color neonPurple = Color.fromARGB(255, 221, 147, 234);
  static const Color bgDark = Color(0xFF050505);
  
  
  bool _isImageLoaded = false;
  bool _showMenuContent = false; // Controls the text staggering
  // Inside _SimulatorScreenState class
bool _showPerformanceStats = false; // Controls the view inside the panel
  int _menuStage = 0; // 0=Idle, 1=Center Big, 2=Side Docked

  int _getCurrentSystemWattage() {
    return HeuristicEngine.calculateTotalWattage(
      cpu: _equippedCpu,
      mobo: _equippedMotherboard,
      ram: _equippedRam,
      storage: _equippedStorage,
      gpu: _equippedGpu,
      cooler: _equippedCooler,
     
    );
  }
  List<dynamic> _getRawDatabaseList(String slot) {
    if (slot == "CPU") return ComponentsDB.cpus;
    if (slot == "RAM") return ComponentsDB.ramSticks;
    if (slot == "MOTHER\nBOARD") return ComponentsDB.motherboards;
    if (slot == "GPU") return ComponentsDB.gpus;            
    if (slot == "STORAGE") return ComponentsDB.storageItems;
    if (slot == "PSU") return ComponentsDB.psus;             
    if (slot == "COOLER") return ComponentsDB.coolers;       
    return [];
  }
// --- NEW: LOGIC TO LOAD SAVED PARTS ---
  void _loadSavedBuild() {
    if (widget.loadedBuild == null) return;

    final build = widget.loadedBuild!;
    print("LOADING BUILD: $build"); // Debug check

    setState(() {
      // 1. Find CPU
      _equippedCpu = ComponentsDB.cpus.firstWhere(
        (c) => c.name == build['cpu'], 
        orElse: () => ComponentsDB.cpus[0] // Fallback if not found
      );

      // 2. Find RAM
      _equippedRam = ComponentsDB.ramSticks.firstWhere(
        (r) => r.name == build['ram'],
        orElse: () => ComponentsDB.ramSticks[0]
      );

      // 3. Find Motherboard
      _equippedMotherboard = ComponentsDB.motherboards.firstWhere(
        (m) => m.name == build['mobo'],
        orElse: () => ComponentsDB.motherboards[0]
      );

      // 4. Find GPU (Handle "Integrated" case)
      if (build['gpu'] != "Integrated" && build['gpu'] != "None") {
        _equippedGpu = ComponentsDB.gpus.firstWhere(
          (g) => g.name == build['gpu'],
          orElse: () => ComponentsDB.gpus[0]
        );
      }

      // 5. Find Storage
      _equippedStorage = ComponentsDB.storageItems.firstWhere(
        (s) => s.name == build['storage'],
        orElse: () => ComponentsDB.storageItems[0]
      );
print("SAVED PSU NAME: '${build['psu']}'"); // Note the single quotes to see spaces
print("DB PSU NAMES: ${ComponentsDB.psus.map((e) => "'${e.name}'").toList()}");
      // 6. Find PSU (Smarter Match)
_equippedPsu = ComponentsDB.psus.firstWhere(
  (p) {
    // Clean both strings before comparing (remove spaces, lower case)
    final dbName = p.name.toLowerCase().trim();
    final savedName = build['psu'].toString().toLowerCase().trim();
    return dbName == savedName; 
  },
  orElse: () {
    print("CRITICAL: Could not find PSU '${build['psu']}'. Defaulting to ${ComponentsDB.psus[0].name}");
    return ComponentsDB.psus[0];
  }
);

      // 7. Find Cooler
      _equippedCooler = ComponentsDB.coolers.firstWhere(
        (c) => c.name == build['cooler'],
        orElse: () => ComponentsDB.coolers[0]
      );
    });
  }
  
  @override
  void initState() {
    super.initState();
    _loadWallpaper();
    // 1. CHECK FOR SAVED DATA IMMEDIATELY
    if (widget.loadedBuild != null) {
      _loadSavedBuild(); 
    }

    // 2. Fade in background image (Your existing code)
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isImageLoaded = true;
        });
      }
    });
  }
  Future<void> _loadWallpaper() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _currentWallpaper = prefs.getString('saved_wallpaper') ?? 'assets/web.png';
      });
    }
  }

 void _openMenu(String slot) {
    // 1. If clicking the exact same component while already open, do nothing.
    if (selectedSlot == slot && _menuStage == 2) return;

    // --- PREPARE DATA (Update lists before showing) ---
    if (slot == "CPU") {
      _currentCpuList = List.from(ComponentsDB.cpus);
      if (_equippedCpu != null) {
        _currentCpuList.removeWhere((c) => c.name == _equippedCpu!.name);
        _currentCpuList.insert(0, _equippedCpu!);
      }
    }
    if (slot == "MOTHER\nBOARD") {
      _currentMoboList = List.from(ComponentsDB.motherboards);
      if (_equippedMotherboard != null) {
        _currentMoboList.removeWhere((m) => m.name == _equippedMotherboard!.name);
        _currentMoboList.insert(0, _equippedMotherboard!);
      }
    }
    if (slot == "RAM") {
      _currentRamList = List.from(ComponentsDB.ramSticks);
      if (_equippedRam != null) {
        _currentRamList.removeWhere((r) => r.name == _equippedRam!.name);
        _currentRamList.insert(0, _equippedRam!);
      }
    }

    if (slot == "GPU") {
      _currentGpuList = List.from(ComponentsDB.gpus);
      if (_equippedGpu != null) {
        _currentGpuList.removeWhere((g) => g.name == _equippedGpu!.name);
        _currentGpuList.insert(0, _equippedGpu!);
      }
    }
    if (slot == "PSU") {
    _currentPsuList = List.from(ComponentsDB.psus);
    if (_equippedPsu != null) {
      // Find the equipped PSU, remove it, and stick it at the top
      _currentPsuList.removeWhere((p) => p.name == _equippedPsu!.name);
      _currentPsuList.insert(0, _equippedPsu!);
    }
  }
    // ✅ NEW: STORAGE LOAD LOGIC (Inside _openMenu)
    if (slot == "STORAGE") {
      _currentStorageList = List.from(ComponentsDB.storageItems);
      if (_equippedStorage != null) {
        _currentStorageList.removeWhere((s) => s.name == _equippedStorage!.name);
        _currentStorageList.insert(0, _equippedStorage!);
      }
    }

    if (slot == "COOLER") {
  _currentCoolerList = List.from(ComponentsDB.coolers);
  if (_equippedCooler != null) {
    _currentCoolerList.removeWhere((c) => c.name == _equippedCooler!.name);
    _currentCoolerList.insert(0, _equippedCooler!);
  }
}

    // --- LOGIC SPLIT ---

    // CASE A: SWITCHING (Menu is ALREADY OPEN)
    // We must fade out -> swap data -> fade in to prevent flicker
   if (_menuStage == 2) {
      setState(() {
        _showMenuContent = false; // 1. Start Fade Out
        _isSorting = false;       // ✅ ADD THIS LINE HERE! It forces the default list view.
      });

      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            // 2. NOW it is safe to clear previews and swap slots
            _previewCpu = null;
            _previewMotherboard = null;
            _previewRam = null;
            _previewGpu = null;
            _previewStorage = null; 
            _previewPsu = null;     
            _previewCooler = null;
            selectedSlot = slot; 
            _showMenuContent = true; // 3. Start Fade In
          });
        }
      });
      return; 
    }

    // CASE B: OPENING (Menu is CLOSED)
    // It's safe to clear immediately because the menu isn't visible yet
    setState(() {
      _previewCpu = null;
      _previewMotherboard = null;
      _isSorting = false;
      _previewRam = null;
      _previewGpu = null;
      _previewStorage = null;
      _previewPsu = null;
      _previewCooler = null;

      selectedSlot = slot;
      _menuStage = 1; 
      _showMenuContent = false; 
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && selectedSlot == slot) {
        setState(() {
          _menuStage = 2; 
              
          _showMenuContent = true; 
        });
      }
    });
  }
  
 void _closeMenu() {
    if (_menuStage == 0) return; // Already closed

    final String closingSlot = selectedSlot ?? "";

    // 1. Hide the list content & CLEAR PREVIEWS
    setState(() {
      _showMenuContent = false;
      _isSorting = false;
      // ✅ FIX: Kill any active details panel so it doesn't linger
      _previewCpu = null;
      _previewMotherboard = null;
      _previewRam = null;
      _previewGpu = null;
      _previewStorage = null;
      _previewPsu = null;
      _previewCooler = null;
    });

    // 1. Hide the list content
    setState(() {
      _showMenuContent = false;
    });

    // 2. Move to Center (Stage 1)
    setState(() {
      _menuStage = 1;
    });

    // 3. Wait for slide (Reduced to 300ms for snappiness), then Shrink
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        // BUG FIX CHECK:
        // Only shrink if the user HAS NOT clicked a new component.
        // If selectedSlot is different, it means a new Open animation started. ABORT CLOSE.
        if (selectedSlot != closingSlot) return;

        setState(() {
          _menuStage = 0; // Shrink animation
        });

        // 4. Wait for shrink to finish (300ms), then clear selection
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            // BUG FIX CHECK 2:
            // Only clear 'selectedSlot' if we are actually fully closed (Stage 0).
            // If the user clicked something else, stage would be 1 or 2.
            if (_menuStage == 0 && selectedSlot == closingSlot) {
              setState(() {
                selectedSlot = null; // Stop the glow
              });
            }
          }
        });
      }
    });
  }
 // --- HELPER: Get "Signature" Text from Actual Objects ---
  String _getShortSignature(String slot) {
    // 1. CPU: Keep the Model Number (e.g. "5600X")
    if (slot == "CPU" && _equippedCpu != null) {
      return _equippedCpu!.name.split(" ").last;
    }
    
    // 2. GPU: Keep the Model Number (e.g. "3060", "4090")
    if (slot == "GPU" && _equippedGpu != null) {
      // Regex is still best here to pick "4090" out of "NVIDIA RTX 4090"
      RegExp regExp = RegExp(r'\d{3,4}(?: Ti| XT| Super)?', caseSensitive: false);
      Match? match = regExp.firstMatch(_equippedGpu!.name);
      return match != null ? match.group(0)! : "GPU";
    }
    
    // 3. MOTHERBOARD: Show BRAND (e.g. "GIGABYTE", "MSI")
    if (slot == "MOTHER\nBOARD" && _equippedMotherboard != null) {
      return _equippedMotherboard!.brand.toUpperCase(); 
    }
    
    // 4. RAM: Show Capacity (e.g. "16GB")
    if (slot == "RAM" && _equippedRam != null) {
      return "${_equippedRam!.capacity}GB";
    }
    
    // 5. PSU: Show Wattage + "W" (e.g. "450W")
    if (slot == "PSU" && _equippedPsu != null) {
      return "${_equippedPsu!.wattage}W"; 
    }
    
    // 6. STORAGE: Smart Convert (e.g. "1TB" or "500GB")
    if (slot == "STORAGE" && _equippedStorage != null) {
      if (_equippedStorage!.capacity >= 1000) {
        return "${(_equippedStorage!.capacity / 1000).toStringAsFixed(0)}TB";
      }
      return "${_equippedStorage!.capacity}GB";
    }
    
    // 7. COOLER: Show Brand (e.g. "CORSAIR")
    if (slot == "COOLER" && _equippedCooler != null) {
       return _equippedCooler!.brand.toUpperCase();
    }

    return slot;
  }
  @override
  Widget build(BuildContext context) {
    // 1. GET SCREEN SIZE
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: bgDark,
      // Wrap the FAB in AnimatedScale
     floatingActionButton: widget.hidePowerButton ? null : AnimatedScale(
        scale: _menuStage == 0 ? 1.0 : 0.0, // If Menu Open (Stage 1 or 2), Scale to 0 (Hide)
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack, // Nice bouncy effect
        child: FloatingActionButton(
          onPressed: _handlePowerButton, 
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: neonCyan.withOpacity(0.1),
              border: Border.all(color: neonCyan, width: 2),
              boxShadow: [
                BoxShadow(color: neonCyan.withOpacity(0.4), blurRadius: 15, spreadRadius: 2)
              ]
            ),
            // Later, you can replace this Icon with Image.asset('assets/logo.png')
            child: const Icon(Icons.power_settings_new, color: Colors.white, size: 30),
          ),
        ),
      ),

      body: Stack(
        children: [
          // 1. Solid background first
          Positioned.fill(
            child: Container(color: bgDark),
          ),

         // 2. The Image with Fade-In animation
          if (_isImageLoaded)
            Positioned.fill(
              child: Opacity( // Added Opacity to match your OS vibe
                opacity: 0.8,
                child: Image.asset(
                  _currentWallpaper, // ✅ NOW USES THE DYNAMIC VARIABLE
                  fit: BoxFit.cover,
                  cacheWidth: 2160,
                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) return child;
                    return AnimatedOpacity(
                      opacity: frame == null ? 0 : 1,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOut,
                      child: child,
                    );
                  },
                ),
              ),
            ),

          // 3. Optional Overlay (The Dark Background)
          if (_isImageLoaded)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (selectedSlot != null) {
                    _closeMenu();
                  }
                },
                child: Container(color: Colors.black.withOpacity(0.6)),
              ),
            ),

          /// ================= COMPONENT LAYOUT (Middle Layer) =================
       /// ================= Icon position =================
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                final size = (h * 0.18).clamp(80.0, 120.0);

                return Stack(
                  children: [
                    // CPU
                    Positioned(
                      left: w * 0.12,
                      top: h * 0.25,
                      child: _buildComponentCard("CPU", "assets/cpu.png", neonCyan, size: size, iconScale: 0.65, onTap: () {
                        _openMenu("CPU");
                      }),
                    ),
                    // Motherboard
                    Positioned(
                      left: w * 0.12,
                      top: h * 0.52,
                      child: _buildComponentCard("MOTHER\nBOARD", "assets/motherboard.png", neonCyan, size: size, iconScale: 0.62, onTap: () {
                        _openMenu("MOTHER\nBOARD");
                      }),
                    ),
                    // RAM
                    Positioned(
                      left: w * 0.28,
                      top: h * 0.38,
                      child: _buildComponentCard("RAM", "assets/memory.png", neonCyan, size: size, iconScale: 0.8, onTap: () {
                        _openMenu("RAM");
                      }),
                    ),
                    
                    // COOLER (Kept your "Little Down" adjustment)
                    Positioned(
                      left: w * 0.44,
                      top: h * 0.36, 
                      child: _buildComponentCard("COOLER", "assets/cooler.png", neonPurple, size: size * 1.25, isCenter: true, iconScale: 1.0, imageOffset: const Offset(0,10), textOffset: const Offset(0, 10),onTap: () {
                        _openMenu("COOLER");
                      }),
                    ),

                    // --- GPU (FIXED HERE) ---
                    Positioned(
                      right: w * 0.28, // Reverted to original position (Box stays put)
                      top: h * 0.38,
                      child: _buildComponentCard(
                        "GPU", 
                        "assets/gpu.png", 
                        neonRed, 
                        size: size, 
                        iconScale: 0.8, 
                        
                        // THIS MOVES THE IMAGE INSIDE THE BOX!
                        // -10 = Left, 10 = Right, 0 = Center
                        imageOffset: const Offset(2,0), 
                        
                        onTap: () => _openMenu("GPU"),
                      ),
                    ),

                    // Storage
                    Positioned(
                      right: w * 0.12,
                      top: h * 0.25,
                      child: _buildComponentCard("STORAGE", "assets/storage.png", neonRed, size: size, iconScale: 0.7, onTap: () {
                        _openMenu("STORAGE");
                      }),
                    ),
                    // PSU
                    Positioned(
                      right: w * 0.12,
                      top: h * 0.52,
                      child: _buildComponentCard("PSU", "assets/psu.png", neonRed, size: size, iconScale: 0.7,imageOffset: const Offset(2,0), onTap: () {
                        _openMenu("PSU");
                      }),
                    ),
                  ],
                );
              },
            ),
          ),

          /// ================= SMART SIDE MENU (Final Fix) =================
          Builder(
            builder: (context) {
              double? topPos, bottomPos, leftPos, width, height;
              Color themeColor;

              // 1. Theme Logic
              String currentSlot = selectedSlot ?? "Unknown";
              
              if (currentSlot == "COOLER") {
                themeColor = neonPurple;
              } else {
                themeColor = _isLeftComponent ? neonCyan : neonRed;
              }

              // 2. Calculate Position
              if (_menuStage == 0) {
                // STAGE 0: IDLE
                width = 240; 
                height = 50; 
                bottomPos = 20;
                topPos = null;
                leftPos = (screenWidth - width) / 2; 
              } 
              else if (_menuStage == 1) {
                // STAGE 1: EXPANDED
                width = 310;
                height = 260; 
                bottomPos = 20;
                topPos = null; 
                leftPos = (screenWidth - 310) / 2;
              } 
              else {
                // STAGE 2: DOCKED
                width = 300;
                height = 260; 
                bottomPos = 20;
                topPos = null;
                leftPos = _isLeftComponent ? screenWidth - 310 - 20 : 20;
              }

              return AnimatedPositioned(
                duration: Duration(milliseconds: _menuStage == 1 ? 450 : 400),
                curve: _menuStage == 1 ? Curves.easeInOutBack : Curves.easeInOutCubic,
                
                left: leftPos, bottom: bottomPos, top: topPos, width: width, height: height,

                child: Container(
                  // 1. CLIP THE OVERFLOW (Silences the error safely)
                  clipBehavior: Clip.hardEdge, 
                  decoration: BoxDecoration(
                    color: const Color(0xFF12121A).withOpacity(0.95),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _menuStage == 0 ? Colors.white12 : themeColor.withOpacity(0.5),
                      width: _menuStage == 0 ? 1 : 2
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _menuStage == 0 ? Colors.black54 : themeColor.withOpacity(0.15),
                        blurRadius: 20
                      ),
                    ],
                  ),

                  // INSIDE your Builder(builder: (context) { ... return AnimatedPositioned(...) })
// Replace the 'child' of the Container with this:

child: AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  child: _menuStage == 0
      // STATE 1: IDLE (Small Box)
      ? Center(
          key: const ValueKey(0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.touch_app, color: Colors.white54, size: 18),
              const SizedBox(width: 8),
              Text("TAP A COMPONENT",
                  style: GoogleFonts.orbitron(
                      color: Colors.white54, fontSize: 12, letterSpacing: 2)),
            ],
          ),
        )
      // STATE 2: MENU OPEN (Big Box)
      : LayoutBuilder(
          key: ValueKey(_isSorting ? "Sorting" : "List"), // ✅ THIS FORCES THE REBUILD
          builder: (context, constraints) {
            if (constraints.maxHeight < 100) return const SizedBox();

            // 1. Are we looking at a specific item's details?
            if (_previewCpu != null || _previewMotherboard != null || _previewRam != null || _previewGpu != null || _previewStorage != null || _previewPsu != null || _previewCooler != null) {
              return _buildDetailPanel();
            }

            // 2. Are we sorting? Show the embedded menu
            if (_isSorting) {
              return EmbeddedSortMenu(
                slotType: currentSlot,
                allItems: _getRawDatabaseList(currentSlot), 
                themeColor: themeColor,
                onClose: () {
                  setState(() { _isSorting = false; });
                },
               onApply: (filteredResults) {
                  setState(() {
                    if (currentSlot == "CPU") _currentCpuList = filteredResults.cast<Cpu>();
                    else if (currentSlot == "RAM") _currentRamList = filteredResults.cast<Ram>();
                    else if (currentSlot == "MOTHER\nBOARD") _currentMoboList = filteredResults.cast<Motherboard>();
                    else if (currentSlot == "GPU") _currentGpuList = filteredResults.cast<Gpu>();                 // ✅ ADDED
                    else if (currentSlot == "STORAGE") _currentStorageList = filteredResults.cast<Storage>();     // ✅ ADDED
                    else if (currentSlot == "PSU") _currentPsuList = filteredResults.cast<Psu>();                 // ✅ ADDED
                    else if (currentSlot == "COOLER") _currentCoolerList = filteredResults.cast<Cooler>();        // ✅ ADDED
                    _isSorting = false; 
                  });
                },
              );
            }

            // 3. Otherwise, show the standard list
            return Column(
              children: [
                // --- HEADER ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SELECT ${currentSlot.replaceAll('\n', ' ')}",
                        style: GoogleFonts.orbitron(
                            color: themeColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w900),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() { 
                                _isSorting = true; 
                                print("Sort tapped! _isSorting is now $_isSorting"); // Debug print
                              });
                            },
                            child: Icon(Icons.sort, color: themeColor, size: 20),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: _closeMenu,
                            child: const Icon(Icons.close, color: neonRed, size: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                // --- LIST ---
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: _buildInventoryList(themeColor),
                  ),
                ),
              ],
            );
          },
        ),
),
                ),
              );
            }
          ),
          /// ================= TOP HUD =================
          Positioned(
            top: 0,
            left: -12,
            right: 7,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                child: SizedBox(
                  height: 70,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT PANEL
                      Expanded(
                        child: _buildHudPanel(
                          color: neonCyan,
                          isLeft: true,
                          child: _buildPowerMeter(),
                        ),
                      ),
                      // CENTER LOGO
                      Container(
                        width: 200,
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.only(top: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "SPYDAR",
                              style: GoogleFonts.orbitron(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: const [
                                  Shadow(color: Colors.white30, blurRadius: 12),
                                ],
                              ),
                            ),
                            Text(
                              "SIMULATOR",
                              style: GoogleFonts.orbitron(
                                fontSize: 10,
                                letterSpacing: 4,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // RIGHT PANEL
                      Expanded(
                        child: _buildHudPanel(
                          color: neonRed,
                          isLeft: false,
                          child: _buildBottleneckMeter(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= UI HELPERS =================

  Widget _buildHudPanel({required Color color, required bool isLeft, required Widget child}) {
    return CustomPaint(
      painter: HudPanelPainter(color: color, isLeft: isLeft),
      child: Container(
        height: 55,
        padding: EdgeInsets.fromLTRB(
          isLeft ? 2 : 10,
          5,
          isLeft ? 10 : 20,
          5,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  bool get _isLeftComponent {
    const leftItems = ["CPU", "MOTHER\nBOARD", "RAM", "COOLER"];
    return leftItems.contains(selectedSlot);
  }
Widget _buildPowerMeter() {
  // 1. Get Real Numbers
  int currentWatts = _getCurrentSystemWattage();
  int maxWatts = _equippedPsu?.wattage ?? 0;

  // 2. Determine Colors & Status
  bool isOverloaded = currentWatts > maxWatts && maxWatts > 0;
  bool isWarning = maxWatts > 0 && (currentWatts / maxWatts) > 0.9 && !isOverloaded;
  
  Color meterColor;
  if (isOverloaded || isWarning) {
    meterColor = neonRed;
  } else if (maxWatts > 0) {
    meterColor = neonCyan;
  } else {
    meterColor = Colors.grey;
  }

  // 3. Calculate Bars
  int barsToLight;
  if (isOverloaded) {
    barsToLight = 10; 
  } else if (maxWatts == 0) {
    barsToLight = 0; 
  } else {
    double usagePercent = currentWatts / maxWatts;
    barsToLight = (usagePercent * 10).round().clamp(0, 10); 
  }

  // 4. Text Logic
  String textDisplay = maxWatts > 0 
      ? "$currentWatts / $maxWatts W" 
      : "LOAD: $currentWatts W";

  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Icon
        Icon(
          isOverloaded ? Icons.warning_amber_rounded : FontAwesomeIcons.bolt, 
          color: isOverloaded ? neonRed : (maxWatts > 0 ? neonCyan : Colors.white70), 
          size: 18
        ), 
        const SizedBox(width: 8),

        // 2. BATTERY GRAPHIC
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tip (Now matches the theme color)
            Container(
              width: 3, 
              height: 6, 
              decoration: BoxDecoration(
                color: meterColor.withOpacity(0.5), // ✅ Tinted Tip
                borderRadius: BorderRadius.circular(1)
              )
            ),
            // Body
            Container(
              width: 100, 
              height: 14,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                // ✅ Tinted Border (Dim Neon)
                border: Border.all(color: meterColor.withOpacity(0.4)), 
                borderRadius: BorderRadius.circular(2), 
                color: Colors.black.withOpacity(0.5),
              ),
              child: Row(
                children: List.generate(10, (index) {
                  bool isActive = index < barsToLight; 
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0.5),
                      decoration: BoxDecoration(
                        // ✅ Empty slots are now faint neon (Glass effect) instead of grey
                        color: isActive ? meterColor : meterColor.withOpacity(0.15), 
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
        
        const SizedBox(width: 8),

        // 3. TEXT DISPLAY
        SizedBox(
          width: 110, 
          child: Text(
            textDisplay,
            textAlign: TextAlign.left, 
            maxLines: 1, 
            overflow: TextOverflow.visible, 
            style: GoogleFonts.orbitron(
              color: isOverloaded ? neonRed : Colors.white, 
              fontSize: 12, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    ),
  );
}
 Widget _buildBottleneckMeter() {
  // ✅ CALL THE ENGINE ONCE
  final report = HeuristicEngine.calculateFullBottleneck(
    cpu: _equippedCpu,
    gpu: _equippedGpu,
    mobo: _equippedMotherboard,
    cooler: _equippedCooler,
    storage: _equippedStorage,
    ram: _equippedRam,
  );

  double percentage = report["percentage"];
  Color statusColor = percentage < 10 ? Colors.greenAccent : (percentage < 20 ? Colors.orangeAccent : neonRed);

  return FittedBox(
    fit: BoxFit.scaleDown,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(FontAwesomeIcons.gaugeHigh, color: statusColor, size: 18),
        const SizedBox(width: 8),
        Container(height: 16, width: 1, color: Colors.grey.withOpacity(0.5)),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            style: GoogleFonts.orbitron(fontSize: 12, fontWeight: FontWeight.bold),
            children: [
              const TextSpan(text: "BOTTLENECK: ", style: TextStyle(color: Colors.white)),
              TextSpan(text: "${percentage.toStringAsFixed(0)}%", style: TextStyle(color: statusColor)),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // ✅ NEW: PASS THE 'report' Map TO YOUR POPUP
       GestureDetector(
  onTap: () {
    // 1. 🔄 CALCULATE FRESH DATA (Do not use the old 'report' variable)
    final freshReport = HeuristicEngine.calculateFullBottleneck(
      cpu: _equippedCpu,
      gpu: _equippedGpu,
      mobo: _equippedMotherboard,
      cooler: _equippedCooler,
      storage: _equippedStorage,
      ram: _equippedRam, // This ensures it sees the T705!
    );

    // 2. 🕵️ DEBUG CHECK (Optional, just to verify)
    print("FRESH REPORT -> Storage Issue: ${freshReport['storagePenalty']}");

    // 3. SHOW POPUP WITH FRESH DATA
    _showBottleneckReport(freshReport); 
  },
  child: const Icon(Icons.info_outline, color: neonCyan, size: 16),
),
      ],
    ),
  );
}

void _showBottleneckReport(Map<String, dynamic> report) {
    final double percentage = report["percentage"];
    final int storageScore = report["storageTileScore"] ?? 100;
    
    // ✅ ADDED MISSING CHECKS
    final bool hasStorage = _equippedStorage != null;
    final bool hasRam = _equippedRam != null;
    final bool hasCpu = _equippedCpu != null; 
    final bool hasGpu = _equippedGpu != null;

    final Color statusColor = percentage < 10
        ? Colors.greenAccent
        : (percentage < 20 ? Colors.orangeAccent : neonRed);

    final int cpuScore = report["cpuScore"] ?? 0;
    final int gpuScore = report["gpuScore"] ?? 0;
    final int ramScore = report["ramTileScore"] ?? 100;

    // ✅ NEW COLORS (Grey if missing)
    final Color cpuColor = !hasCpu ? Colors.grey : neonCyan;
    final Color gpuColor = !hasGpu ? Colors.grey : neonRed;
    final Color ramColor = !hasRam ? Colors.grey : neonCyan; 
    final Color storageColor = !hasStorage ? Colors.grey : neonRed; 

    final List<Widget> cards = [
      // --- CPU CARD ---
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: _buildMiniCard(
          title: "CPU (Gaming Pwr)",
          // ✅ FIX: Check if CPU exists first
          subtitle: !hasCpu 
              ? "No CPU selected" 
              : (report["type"] == "CPU Bottleneck"
                  ? "Processor limit detected"
                  : "Processor is performing well"),
          color: cpuColor,
          // ✅ FIX: Recommendation for missing CPU
          recommendation: !hasCpu 
              ? "Select a processor to analyze." 
              : ((cpuScore < gpuScore) || report["thermalPenalty"]
                  ? report["recommendation"]
                  : "Optimal performance."),
          warning: (hasCpu && report["thermalPenalty"]) ? "⚠️ THERMAL THROTTLING" : null,
          score: hasCpu ? cpuScore : 0,
        ),
      ),

      // --- GPU CARD ---
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: _buildMiniCard(
          title: "GPU (Render Pwr)",
          // ✅ FIX: Check if GPU exists first
          subtitle: !hasGpu 
              ? "No GPU selected" 
              : (report["type"] == "GPU Bottleneck"
                  ? "Graphics limit detected"
                  : "Graphics is performing well"),
          color: gpuColor,
          // ✅ FIX: Recommendation for missing GPU
          recommendation: !hasGpu 
              ? "Select a graphics card." 
              : ((gpuScore < cpuScore)
                  ? report["recommendation"]
                  : "Optimal performance detected."),
          score: hasGpu ? gpuScore : 0,
        ),
      ),
      
// --- RAM CARD ---
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: _buildMiniCard(
          title: "RAM (Capacity)",
          subtitle: !hasRam ? "No RAM selected" : "Optimal Standard",
          color: ramColor,
          recommendation: !hasRam
              ? "Select memory modules."
              : "Meets recommended specifications.",
          score: !hasRam ? 0 : ramScore,
        ),
      ),

      // --- STORAGE CARD ---
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: _buildMiniCard(
          title: "Storage (Bandwidth)",
          subtitle: !hasStorage
              ? "No storage selected"
              : (storageScore < 100 ? "Bandwidth Limited" : "Optimal Speed"),
          color: storageColor, 
          recommendation: !hasStorage
              ? "Select a storage drive."
              : (storageScore < 100
                  ? "Gen ${_equippedStorage?.pcieGen} SSD limited by Slot."
                  : "PCIe bandwidth is sufficient."),
          score: !hasStorage ? 0 : storageScore,
        ),
      ),

      
    ];

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F1A).withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- HEADER ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("BOTTLENECK ANALYSIS",
                            style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: Colors.white38),
                        ),
                      ],
                    ),
                  ),

                  // --- OVERALL BOTTLENECK ---
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Overall Bottleneck",
                                style: TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(width: 10),
                            Text("${percentage.toStringAsFixed(0)}%",
                                style: GoogleFonts.orbitron(
                                    color: statusColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 220,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: (percentage / 100).clamp(0.0, 1.0),
                              color: statusColor,
                              backgroundColor: Colors.white10,
                              minHeight: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- CAROUSEL ---
                  Expanded(
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.75, initialPage: 1000),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return cards[index % cards.length];
                      },
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

  // Helper Widget (Unchanged from your previous preferences)
  Widget _buildMiniCard({
    required String title,
    required String subtitle,
    required Color color,
    required String recommendation,
    String? warning,
    int score = 0,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              Text("$score pts",
                  style: GoogleFonts.orbitron(
                      color: color, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (score / 100).clamp(0.0, 1.0),
              backgroundColor: Colors.black45,
              color: color,
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 10),
          Text(subtitle,
              style: const TextStyle(
                  color: Colors.white38, fontSize: 11, height: 1.35)),
          if (warning != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(warning,
                  style: const TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
            ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    color: Colors.amberAccent, size: 14),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(recommendation,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11, height: 1.4)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


Widget _buildComponentCard(String label, String imagePath, Color glowColor,
      {required double size,
      bool isCenter = false,
      double iconScale = 0.5,
      Offset imageOffset = Offset.zero,
      Offset textOffset = Offset.zero,
      required VoidCallback onTap}) {
    
    // 1. CHECK IF EQUIPPED
    bool isEquipped = false;
    if (label == "CPU") isEquipped = _equippedCpu != null;
    else if (label == "MOTHER\nBOARD") isEquipped = _equippedMotherboard != null;
    else if (label == "RAM") isEquipped = _equippedRam != null;
    else if (label == "GPU") isEquipped = _equippedGpu != null;
    else if (label == "STORAGE") isEquipped = _equippedStorage != null;
    else if (label == "PSU") isEquipped = _equippedPsu != null;
    else if (label == "COOLER") isEquipped = _equippedCooler != null;

    // 2. GET SIGNATURE TEXT (Using the helper I gave you earlier)
    String displayText = isEquipped ? _getShortSignature(label) : label;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: BreathingCard(
          isSelected: selectedSlot == label,
          // Keep Red/Cyan Theme
          glowColor: isEquipped ? glowColor : (selectedSlot == label ? Colors.white : Colors.white24), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --- ICON AREA (Top) ---
              Container(
                height: size * 0.60, // Gives icon a bit more space
                width: size,
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: imageOffset,
                  child: Image.asset(
                    imagePath,
                    // If equipped, slightly larger to look "active", but NO FADING
                    width: size * (isEquipped ? 0.75 : iconScale),
                    height: size * (isEquipped ? 0.75 : iconScale),
                    fit: BoxFit.contain,
                    // We DO NOT change opacity or color here. It stays original.
                  ),
                ),
              ),
              
              // --- TEXT AREA (Bottom) ---
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter, // Pushes text up slightly towards icon
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Transform.translate(
                    offset: textOffset,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        displayText, // Shows "5600X" or "RTX 3060"
                        textAlign: TextAlign.center,
                        maxLines: 1, 
                        softWrap: false, 
                        style: GoogleFonts.orbitron(
                          // If equipped: Bright White. If empty: Standard Grey.
                          color: isEquipped ? Colors.white : (selectedSlot == label ? Colors.white : Colors.white70),
                          // ✅ MINIMIZED TEXT SIZE (Was 0.18, now 0.13)
                          fontSize: size * (isEquipped ? 0.13 : 0.11), 
                          fontWeight: FontWeight.bold,
                          letterSpacing: isEquipped ? 0.5 : 0.0,
                          shadows: isEquipped ? [
                             Shadow(color: glowColor, blurRadius: 10), // Text Glows with Border Color
                             const Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2) // Drop Shadow for readability
                          ] : [],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // --- NEW HELPER FOR THE INVENTORY LIST ---
Widget _buildInventoryList(Color themeColor) {
   if (selectedSlot == "CPU") {
    return InventoryList(
      slotType: "CPU",
      items: _currentCpuList,
      equippedItem: _equippedCpu,
      currentMobo: _equippedMotherboard,
      
      // ✅ CRITICAL FIX: Pass the Cooler here! 
      // This allows the Reverse Check (Cooler -> CPU) to work.
      currentCooler: _equippedCooler, 
      
      themeColor: themeColor,
      onEquip: (item) => _equipComponent(item),
      onPreview: (item) => setState(() {
        _previewCpu = item;
        _previewMotherboard = null;
        _previewRam = null;
        _previewCooler = null; 
        _previewGpu = null; _previewStorage = null; _previewPsu = null;
      }),
    );
  }

  // 2. MOTHERBOARD LIST (Also needs to know about the Cooler!)
  if (selectedSlot == "MOTHER\nBOARD") {
    return InventoryList(
      slotType: "MOTHER\nBOARD",
      items: _currentMoboList,
      equippedItem: _equippedMotherboard,
      currentCpu: _equippedCpu,
      currentRam: _equippedRam,
      currentStorage: _equippedStorage,
      
      // ✅ CRITICAL FIX: Pass the Cooler here too!
      currentCooler: _equippedCooler, 
      
      themeColor: themeColor,
      onEquip: (item) => _equipMotherboard(item),
      onPreview: (item) => setState(() {
        _previewMotherboard = item;
        _previewCpu = null; _previewRam = null; _previewCooler = null;
        _previewGpu = null; _previewStorage = null; _previewPsu = null;
      }),
    );
  }

    if (selectedSlot == "RAM") {
      return InventoryList(
        slotType: "RAM",
        items: _currentRamList,
        equippedItem: _equippedRam,
        currentMobo: _equippedMotherboard,
        themeColor: themeColor,
        onEquip: (item) => setState(() => _equippedRam = item),
        // ✅ CLEAR OTHERS ON PREVIEW
        onPreview: (item) => setState(() {
          _previewRam = item;
          _previewCpu = null;
          _previewMotherboard = null;
        }),
      );
    }

    if (selectedSlot == "GPU") {
      return InventoryList(
        slotType: "GPU",
        items: _currentGpuList,
        equippedItem: _equippedGpu,
        themeColor: themeColor, // Will be Red for GPU
        onEquip: (item) => setState(() => _equippedGpu = item),
        onPreview: (item) => setState(() {
          _previewGpu = item;
          // Clear others
          _previewCpu = null;
          _previewMotherboard = null;
          _previewRam = null;
        }),
      );
    }

    // ✅ NEW: STORAGE SELECTION (Inside _buildInventoryList)
    if (selectedSlot == "STORAGE") {
  return InventoryList(
    slotType: "STORAGE",
    items: _currentStorageList,
    equippedItem: _equippedStorage,
    currentMobo: _equippedMotherboard,
    themeColor: themeColor,
    onEquip: (item) => setState(() => _equippedStorage = item),
    onPreview: (item) => setState(() {
      _previewStorage = item; // ✅ Sets the storage preview
      // Clear all others to prevent UI overlap
      _previewCpu = null;
      _previewMotherboard = null;
      _previewRam = null;
      _previewGpu = null;
    }),
  );
}

if (selectedSlot == "PSU") {
  return InventoryList(
    slotType: "PSU",
    items: _currentPsuList,
    equippedItem: _equippedPsu,
    themeColor: themeColor,
    onEquip: (item) => setState(() => _equippedPsu = item),
    onPreview: (item) => setState(() {
      _previewPsu = item;
      _previewCpu = null;
      _previewMotherboard = null;
      _previewRam = null;
      _previewGpu = null;
      _previewStorage = null;
    }),
  );
}
   if (selectedSlot == "COOLER") {
  return InventoryList(
    slotType: "COOLER",
    items: _currentCoolerList,
    equippedItem: _equippedCooler,
    currentMobo: _equippedMotherboard,
    currentCpu: _equippedCpu, 
    themeColor: themeColor,
    onEquip: (item) => setState(() => _equippedCooler = item),
    onPreview: (item) => setState(() {
      _previewCooler = item;
      // Clear others
      _previewCpu = null; _previewMotherboard = null; _previewRam = null;
      _previewGpu = null; _previewStorage = null; _previewPsu = null;
    }),
  );
}

    return Container();
  }

// ✅ HELPER: Creates the "Spec Rows" (Base Clock etc.)
 Widget _buildSpecRow(IconData icon, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3), width: 1), 
      ),
      child: Row(
        // We add this so if the text wraps to 2 lines, the icon and label stay at the top instead of centering
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Icon(icon, color: color, size: 18), 
          const SizedBox(width: 12),
          Text(label, style: GoogleFonts.roboto(color: Colors.grey, fontSize: 12)),
          
          const SizedBox(width: 16), // Replaces the Spacer() to give a fixed gap
          
          // ✅ FIX: Wrapped the value in Expanded. This tells it to take up the remaining space, 
          // push to the right, and safely wrap to the next line if it's too long!
          Expanded(
            child: Text(
              value, 
              textAlign: TextAlign.right, // Keeps it glued to the right wall
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({required String title, required String subtitle, required VoidCallback onTap, required Color color}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12), // Spacing
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // Faint colored background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.bar_chart, color: color, size: 24), // Chart Icon
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle, style: GoogleFonts.roboto(color: Colors.white70, fontSize: 11)),
            ],
          ),
          const Spacer(),
          Icon(Icons.arrow_forward_ios, color: color, size: 18), // Arrow indicating action
        ],
      ),
    ),
  );
}


Widget _buildDiagnosticCard(String title, String val, double progress, Color color) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.03),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            Text(val, style: GoogleFonts.orbitron(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.white10,
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    ),
  );
}

 
 // ✅ FULL HEIGHT DETAIL VIEW (Drill-Down)
  Widget _buildDetailPanel() {
    // 1. DETERMINE WHAT WE ARE LOOKING AT
    final bool isCpu = _previewCpu != null;
    final bool isMobo = _previewMotherboard != null;
    final bool isRam = _previewRam != null;
    final bool isGpu = _previewGpu != null;
    final bool isStorage = _previewStorage != null;
    final bool isPsu = _previewPsu != null;
    final bool isCooler = _previewCooler != null;

    // Set the theme color
    final Color themeColor = isCooler 
        ? neonPurple 
        : ((isGpu || isStorage || isPsu) ? neonRed : neonCyan);

    String name = "";
    num price = 0;

    if (isCpu) { name = _previewCpu!.name; price = _previewCpu!.price; } 
    else if (isMobo) { name = _previewMotherboard!.name; price = _previewMotherboard!.price; }
    else if (isRam) { name = _previewRam!.name; price = _previewRam!.price; }
    else if (isGpu) { name = _previewGpu!.name; price = _previewGpu!.price; }
    else if (isStorage) { name = _previewStorage!.name; price = _previewStorage!.price; }
    else if (isPsu) { name = _previewPsu!.name; price = _previewPsu!.price; }
    else if (isCooler) { name = _previewCooler!.name; price = _previewCooler!.price; }

    bool isCompatible = true;
    if (isCpu) isCompatible = HeuristicEngine.checkCompatibility(cpu: _previewCpu, mobo: _equippedMotherboard, cooler: _equippedCooler);
    else if (isMobo) isCompatible = HeuristicEngine.checkCompatibility(mobo: _previewMotherboard, cpu: _equippedCpu, ram: _equippedRam, storage: _equippedStorage, cooler: _equippedCooler);
    else if (isRam) isCompatible = HeuristicEngine.checkCompatibility(ram: _previewRam, mobo: _equippedMotherboard);
    else if (isStorage) isCompatible = HeuristicEngine.checkCompatibility(storage: _previewStorage, mobo: _equippedMotherboard);
    else if (isCooler) isCompatible = HeuristicEngine.checkCoolerCompatibility(cooler: _previewCooler, mobo: _equippedMotherboard, cpu: _equippedCpu);

    bool isEquipped = false;
    if (isCpu) isEquipped = _equippedCpu != null && _equippedCpu!.name == name;
    else if (isMobo) isEquipped = _equippedMotherboard != null && _equippedMotherboard!.name == name;
    else if (isRam) isEquipped = _equippedRam != null && _equippedRam!.name == name;
    else if (isGpu) isEquipped = _equippedGpu != null && _equippedGpu!.name == name;
    else if (isStorage) isEquipped = _equippedStorage != null && _equippedStorage!.name == name;
    else if (isPsu) isEquipped = _equippedPsu?.name == name;
    else if (isCooler) isEquipped = _equippedCooler?.name == name;

    final Color buttonActiveColor = isEquipped ? neonRed : (isCompatible ? neonCyan : Colors.white24);

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A12).withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: themeColor.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          // --- HEADER ---
          Row(
            children: [
              Container(
                width: 45, height: 45,
                decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: themeColor, width: 1.5),
                ),
                child: Icon(
                  isCpu ? Icons.memory : 
                  (isMobo ? Icons.developer_board : 
                  (isRam ? Icons.storage : 
                  (isStorage ? Icons.save : 
                  (isPsu ? Icons.power : 
                  (isCooler ? Icons.ac_unit : Icons.videogame_asset))))),
                  size: 24, 
                  color: themeColor
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.orbitron(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                    Text("₹${price.toStringAsFixed(0)}", 
                      style: GoogleFonts.roboto(fontSize: 12, color: themeColor)
                    ),
                  ],
                ),
              ),
              
              InkWell(
                onTap: () => setState(() { 
                  if (_showPerformanceStats) {
                    _showPerformanceStats = false;
                    return;
                  }
                  _previewCpu = null; _previewMotherboard = null; _previewRam = null; 
                  _previewGpu = null; _previewStorage = null; _previewPsu = null;
                  _previewCooler = null; 
                }),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.arrow_back, color: Colors.white54, size: 22),
                ),
              ),
            ],
          ),

          const Divider(color: Colors.white12, height: 20),

          // --- CONTENT AREA (Swaps between Stats and List) ---
          Expanded(
            child: _showPerformanceStats && (isCpu || isGpu)
              ? Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        primary: false, 
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: isCpu 
                             ? CpuPerformanceCard(cpu: _previewCpu!) 
                             : GpuPerformanceCard(gpu: _previewGpu!), 
                        ),
                      ),
                    ),
                  ],
                )
              : 
              // ✅ SAFELY ADDED RAWSCROLLBAR BACK WITH EXCLUSIVE CONTROLLER
              RawScrollbar(
                controller: _detailScrollController, // 🔒 LOCKED TO THIS CONTROLLER
                thumbColor: themeColor.withOpacity(0.5),
                radius: const Radius.circular(20),
                thickness: 4,
                thumbVisibility: true, // 👀 Visible again!
                child: SingleChildScrollView(
                  controller: _detailScrollController, // 🔒 LOCKED TO THIS CONTROLLER
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      if (isCpu || isGpu)
                        _buildActionTile(
                          title: "Performance Analysis",
                          subtitle: isCpu ? "Gaming & Workstation Scores" : "3DMark Benchmark Power",
                          color: isCpu ? neonCyan : neonRed,
                          onTap: () => setState(() => _showPerformanceStats = true),
                        ),

                      if (isCpu) ...[
                          _buildSpecRow(FontAwesomeIcons.microchip, "Brand", _previewCpu!.brand, themeColor),
                          _buildSpecRow(FontAwesomeIcons.gaugeHigh, "Base Clock", "${_previewCpu!.baseClock} GHz", themeColor),
                          _buildSpecRow(FontAwesomeIcons.microchip, "Cores", "${_previewCpu!.coreCount}", themeColor),
                          _buildSpecRow(Icons.layers, "Threads", "${_previewCpu!.threads}", themeColor),
                          _buildSpecRow(Icons.memory, "Socket", _previewCpu!.socket, themeColor),
                          _buildSpecRow(Icons.graphic_eq, "Graphics", _previewCpu!.integratedGraphics, themeColor),
                          _buildSpecRow(Icons.thermostat, "TDP", "${_previewCpu!.tdp}W", themeColor),
                      ] else if (isMobo) ...[
                          _buildSpecRow(Icons.memory, "Socket", _previewMotherboard!.socket, themeColor),
                          _buildSpecRow(Icons.aspect_ratio, "Form Factor", _previewMotherboard!.formFactor, themeColor),
                          _buildSpecRow(Icons.developer_board, "Memory", _previewMotherboard!.memoryType, themeColor),
                          _buildSpecRow(Icons.sd_storage, "Max RAM", "${_previewMotherboard!.maxRam} GB", themeColor),
                          _buildSpecRow(Icons.radar, "RAM Slots", "${_previewMotherboard!.memorySlots} Slots", themeColor),
                          _buildSpecRow(Icons.wifi, "WiFi", _previewMotherboard!.hasWifi ? _previewMotherboard!.wifiVersion ?? "WiFi 6" : "No", themeColor),
                          _buildSpecRow(Icons.save, "M.2 Slots", "${_previewMotherboard!.m2Slots}", themeColor),
                          _buildSpecRow(Icons.speed, "PCIe Gen", "Gen ${_previewMotherboard!.pcieGen}", themeColor),
                      ] else if (isRam) ...[
                          _buildSpecRow(Icons.storage, "Type", _previewRam!.type, themeColor),
                          _buildSpecRow(Icons.speed, "Speed", "${_previewRam!.speed} MHz", themeColor),
                          _buildSpecRow(Icons.data_usage, "Capacity", "${_previewRam!.capacity} GB", themeColor),
                          _buildSpecRow(Icons.view_module, "Modules", "${_previewRam!.modules} Sticks", themeColor),
                          _buildSpecRow(Icons.color_lens, "Style", _previewRam!.color, themeColor),
                      ] else if (isGpu) ...[
                          _buildSpecRow(Icons.videogame_asset, "VRAM", "${_previewGpu!.vram} GB", themeColor),
                          _buildSpecRow(Icons.memory, "Type", _previewGpu!.memoryType, themeColor),
                          _buildSpecRow(Icons.grid_4x4, "Cores", "${_previewGpu!.cores}", themeColor),
                          _buildSpecRow(Icons.compare_arrows, "Bus Width", "${_previewGpu!.busWidth}-bit", themeColor),
                          _buildSpecRow(Icons.speed, "PCIe Gen", "Gen ${_previewGpu!.pcieGen}", themeColor),
                          _buildSpecRow(Icons.speed, "Clock", "${_previewGpu!.clock} MHz", themeColor),
                          _buildSpecRow(Icons.speed, "FrameGen", "${_previewGpu!.upscaling}", themeColor),
                          _buildSpecRow(Icons.bolt, "TDP", "${_previewGpu!.tdp} W", themeColor),
                      ] else if (isStorage) ...[
                          _buildSpecRow(Icons.type_specimen, "Type", _previewStorage!.type, themeColor),
                          _buildSpecRow(Icons.folder_zip, "Format", _previewStorage!.format, themeColor),
                          _buildSpecRow(Icons.storage, "Capacity", "${_previewStorage!.capacity} GB", themeColor),
                          _buildSpecRow(Icons.download, "Read Speed", "${_previewStorage!.readSpeed} MB/s", themeColor),
                          _buildSpecRow(Icons.upload, "Write Speed", "${_previewStorage!.writeSpeed} MB/s", themeColor),
                          _buildSpecRow(Icons.speed, "PCIe Gen", _previewStorage!.pcieGen == 0 ? "SATA" : "Gen ${_previewStorage!.pcieGen}", themeColor),
                      ] else if (isPsu) ...[
                          _buildSpecRow(Icons.bolt, "Wattage", "${_previewPsu!.wattage} W", themeColor),
                          _buildSpecRow(Icons.high_quality, "Efficiency", _previewPsu!.efficiency, themeColor),
                          _buildSpecRow(Icons.settings_input_component, "Modular", _previewPsu!.isModular ? "Fully Modular" : "Fixed Cables", themeColor),
                          _buildSpecRow(Icons.branding_watermark, "Brand", _previewPsu!.brand, themeColor),
                      ] else if (isCooler) ...[ 
                          _buildSpecRow(Icons.mode_fan_off, "Type", _previewCooler!.type, themeColor),
                          _buildSpecRow(Icons.cyclone, "Fan Count", "${_previewCooler!.fanCount}", themeColor),
                          _buildSpecRow(Icons.aspect_ratio, "Fan Size", "${_previewCooler!.fanSize}mm", themeColor),
                          _buildSpecRow(Icons.memory, "Sockets", _previewCooler!.supportedSockets.join(", "), themeColor),
                          _buildSpecRow(Icons.thermostat, "Cooling Power", "${_previewCooler!.computedTdp}W", themeColor),
                          _buildSpecRow(Icons.lightbulb, "RGB", _previewCooler!.hasRGB ? "Yes" : "No", themeColor),
                      ],

                      const SizedBox(height: 30),

                      // --- EQUIP BUTTON ---
                      GestureDetector(
                        onTap: () {
                          if (!isCompatible && !isEquipped) {
                            HapticFeedback.vibrate();
                            return; 
                          }
                          if (isCpu) _equipComponent(isEquipped ? null : _previewCpu);
                          else if (isMobo) _equipMotherboard(isEquipped ? null : _previewMotherboard);
                          else if (isRam) setState(() => _equippedRam = isEquipped ? null : _previewRam);
                          else if (isGpu) setState(() => _equippedGpu = isEquipped ? null : _previewGpu);
                          else if (isStorage) setState(() => _equippedStorage = isEquipped ? null : _previewStorage);
                          else if (isPsu) setState(() => _equippedPsu = isEquipped ? null : _previewPsu);
                          else if (isCooler) setState(() => _equippedCooler = isEquipped ? null : _previewCooler);
                        },
                        child: Opacity(
                          opacity: (isCompatible || isEquipped) ? 1.0 : 0.5,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: buttonActiveColor.withOpacity(0.1), 
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: buttonActiveColor, width: 1.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isEquipped ? Icons.delete_outline : (isCompatible ? Icons.build_circle_outlined : Icons.block), 
                                  color: buttonActiveColor, 
                                  size: 20
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  isEquipped ? "REMOVE COMPONENT" : (isCompatible ? "EQUIP COMPONENT" : "INCOMPATIBLE"),
                                  style: GoogleFonts.orbitron(
                                    color: (isCompatible || isEquipped) ? Colors.white : Colors.white38, 
                                    fontSize: 13, 
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  // ✅ FIX 3: LOGIC - Don't close menu, just update state
  void _equipComponent(Cpu? component) {
    setState(() {
      _equippedCpu = component; // If null is passed, it unequips
      // We REMOVED _closeMenu() here so the menu stays open!
    });
    if (component != null) {
      print("Equipped CPU: ${component.name}");
    } else {
      print("Unequipped CPU");
    }
  }

  void _equipMotherboard(Motherboard? mobo) {
    setState(() {
      _equippedMotherboard = mobo;
    });
    // Optional: Add Haptic here if you want
  }


void _handlePowerButton() {
    // 1. CALL THE MASTER FUNCTION
    final result = BootLogic.runBootSequence(
      cpu: _equippedCpu,
      gpu: _equippedGpu,
      mobo: _equippedMotherboard,
      ram: _equippedRam,
      storage: _equippedStorage,
      psu: _equippedPsu,
      cooler: _equippedCooler,
    );

   // 2. STOP THE BOOT IF INCOMPLETE 
    if (result.status == BootStatus.incomplete) {
      // ✅ We swapped the SnackBar for our custom centered Dialog
      _showIncompleteDialog(result.title, result.message);
      return; // Stop here, don't navigate!
    }

    // 3. LAUNCH THE VIDEO SCREEN
    // 3. LAUNCH THE VIDEO SCREEN
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BootSequenceScreen(
          bootResult: result, 
          cpu: _equippedCpu,
          gpu: _equippedGpu,
          mobo: _equippedMotherboard,
          ram: _equippedRam,
          psu: _equippedPsu,
          storage: _equippedStorage,
          cooler: _equippedCooler,
        ),
      ),
    ).then((_) {
      // ✅ REFRESH THE WALLPAPER AS SOON AS THEY RETURN TO THE SIMULATOR
      _loadWallpaper();
    });
  }

// --- Helper: Centered Incomplete Build Dialog ---
  void _showIncompleteDialog(String title, String message) {
    showDialog(
      context: context,
      // This darkens the background but keeps the simulator fully visible behind it
      barrierColor: Colors.black.withOpacity(0.6), 
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent, // We are drawing our own box
        elevation: 0,
        child: Container(
          width: 320, // Keeps it small and compact
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black, // Solid black center
            border: Border.all(color: neonRed, width: 1.5), // Matches your error theme
            boxShadow: [
              BoxShadow(color: neonRed.withOpacity(0.15), blurRadius: 20)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Hugs the content tightly
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.build_circle_outlined, color: neonRed, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    title.toUpperCase(),
                    style: GoogleFonts.shareTechMono(color: neonRed, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: Colors.white24, height: 1),
              ),
              
              // MESSAGE
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.shareTechMono(color: Colors.white70, fontSize: 13, height: 1.5),
              ),
              
              const SizedBox(height: 25),
              
              // RETURN BUTTON
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: neonRed.withOpacity(0.08),
                    border: Border.all(color: neonRed.withOpacity(0.5)),
                  ),
                  child: Text(
                    "RESUME BUILD",
                    style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  // --- Helper 1: Crash/Error Dialog ---
  void _showCrashDialog(String title, String msg, Color color) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        content: Text(msg, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Fix Build", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // --- Helper 2: Warning Dialog (Allows Override) ---
  void _showWarningDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(title, style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
        content: Text(msg, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel", style: TextStyle(color: Colors.white38)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Force Boot -> Leads to BSOD or Glitch (Implement later)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("⚠️ System unstable... Booting anyway..."), backgroundColor: Colors.orange),
              );
            },
            child: const Text("Boot Anyway", style: TextStyle(color: Colors.orangeAccent)),
          )
        ],
      ),
    );
  }

}

class HudPanelPainter extends CustomPainter {
  final Color color;
  final bool isLeft;

  HudPanelPainter({required this.color, required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF10101C)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);

    final path = Path();

    if (isLeft) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 2);
      path.lineTo(size.width - 25, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(25, size.height);
    }
    path.close();

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BreathingCard extends StatefulWidget {
  final bool isSelected;
  final Color glowColor;
  final Widget child;

  const BreathingCard({
    super.key,
    required this.isSelected,
    required this.glowColor,
    required this.child,
  });

  @override
  State<BreathingCard> createState() => _BreathingCardState();
}

class _BreathingCardState extends State<BreathingCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _controller.forward().then((_) {
      _controller.repeat(reverse: true);
    });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _glowAnimation = Tween<double>(begin: 8.0, end: 26.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSelected) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: widget.glowColor.withOpacity(0.5), width: 0.8),
          color: Colors.black.withOpacity(0.75),
          boxShadow: [
            BoxShadow(
              color: widget.glowColor.withOpacity(0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.9),
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor,
                  blurRadius: _glowAnimation.value,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}



