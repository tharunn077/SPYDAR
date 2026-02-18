import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; 
import 'dart:async'; 
import '../../../models/component_model.dart';
import '../benchmark/benchmark_screen.dart';
import 'dart:convert'; // For JSON
import 'package:shared_preferences/shared_preferences.dart'; // For Saving
import '../saved_builds/saved_list_screen.dart'; // Link to the Garage Screen
import 'dart:math'; // <--- Add this line
import '../apps/labs_screen.dart'; // Make sure path is correct

class OsScreen extends StatefulWidget {
  final Cpu cpu;
  final Gpu? gpu;
  final Ram ram;
  final Motherboard mobo;
  final Psu psu;
  final Storage storage;
  final Cooler cooler;

  const OsScreen({
    super.key,
    required this.cpu,
    required this.gpu,
    required this.ram,
    required this.mobo,
    required this.psu,
    required this.storage,
    required this.cooler,
  });

  @override
  State<OsScreen> createState() => _OsScreenState();
}

class _OsScreenState extends State<OsScreen> {
  static const Color neonCyan = Color(0xFF00F3FF);
  static const Color neonRed = Color(0xFFFF003C);
  static const Color bgDark = Color(0xFF050505);

  String? _activeWindow; 
  bool _isStartMenuOpen = false;
  String _currentWallpaper = 'assets/web.png'; 
  final List<String> _wallpapers = ['assets/web.png', 'assets/grid.png', 'assets/city.png'];

  late Timer _timer;
  String _timeString = "12:00 PM"; 

  @override
  void initState() {
    super.initState();
    _updateTime(); 
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (!mounted) return;
    final DateTime now = DateTime.now();
    final int hour12 = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final String minute = now.minute.toString().padLeft(2, '0');
    final String period = now.hour >= 12 ? 'PM' : 'AM';
    setState(() {
      _timeString = "$hour12:$minute $period";
    });
  }

  double get totalCost => widget.cpu.price + (widget.gpu?.price ?? 0) + widget.ram.price + widget.mobo.price + widget.psu.price + widget.storage.price + widget.cooler.price;
Future<void> _showSaveDialog() async {
    TextEditingController nameController = TextEditingController();
    
    // --- LOGIC: GENERATE "PC 1, PC 2..." ---
    final prefs = await SharedPreferences.getInstance();
    String? existingData = prefs.getString('saved_rigs');
    List<dynamic> currentList = existingData != null ? json.decode(existingData) : [];
    int nextNumber = currentList.length + 1;
    nameController.text = "PC $nextNumber"; 

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false, // User must click Abort or Authorize
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: SingleChildScrollView( // Prevents keyboard overflow error
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111), 
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: neonCyan.withOpacity(0.6), width: 2),
                  boxShadow: [BoxShadow(color: neonCyan.withOpacity(0.2), blurRadius: 20)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ---
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "NEXUS UPLOAD", 
                          style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    Text(
                      "Assign a Node ID to anchor rig.", 
                      style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)
                    ),
                    
                    const SizedBox(height: 25),

                    // --- INPUT FIELD (FIXED) ---
                    TextField(
                      controller: nameController,
                      // NO AUTOFOCUS - Keyboard waits for you
                      autofocus: false, 
                      style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, letterSpacing: 1.5),
                      cursorColor: neonCyan,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: neonCyan, width: 2),
                        ),
                        hintText: "TYPE NAME...",
                        hintStyle: GoogleFonts.shareTechMono(color: Colors.white24),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- BUTTONS ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // NEON RED ABORT
                        TextButton(
                          onPressed: () => Navigator.pop(context), 
                          style: TextButton.styleFrom(foregroundColor: neonRed),
                          child: Text("ABORT", style: GoogleFonts.shareTechMono(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        
                        const SizedBox(width: 15),
                        
                        // AUTHORIZE BUTTON
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: neonCyan.withOpacity(0.1), 
                            side: const BorderSide(color: neonCyan),
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          onPressed: () {
                            _saveToStorage(nameController.text);
                            Navigator.pop(context);
                          },
                          child: Text("AUTHORIZE", style: GoogleFonts.orbitron(color: neonCyan, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  // --- 2. THE ACTUAL SAVE LOGIC ---
  Future<void> _saveToStorage(String name) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Create the Build Object
    Map<String, dynamic> newBuild = {
      'name': name,
      'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      'cpu': widget.cpu.name,
      'gpu': widget.gpu?.name ?? "Integrated",
      'ram': widget.ram.name,
      'cooler': widget.cooler.name,
      'psu': widget.psu.name,
      'cost': totalCost.toStringAsFixed(0),
    };

    // Get Existing list
    String? existingData = prefs.getString('saved_rigs');
    List<dynamic> buildList = existingData != null ? json.decode(existingData) : [];
    
    // Add new and Save
    buildList.add(newBuild);
    await prefs.setString('saved_rigs', json.encode(buildList));

    // Show Success Message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black, content: Text("BLUEPRINT '$name' ENCRYPTED.", style: GoogleFonts.shareTechMono(color: neonCyan))));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: GestureDetector(
        onTap: () {
          if (_isStartMenuOpen) setState(() => _isStartMenuOpen = false);
        },
        child: Stack(
          children: [
            // 1. WALLPAPER (Always visible in background)
            Positioned.fill(
              child: Image.asset(_currentWallpaper, fit: BoxFit.cover, errorBuilder: (c, o, s) => Container(color: Colors.black)),
            ),

            // 2. DESKTOP ICONS (Only visible if NO window is open)
            if (_activeWindow == null)
              Positioned(
                top: 30, left: 20, bottom: 60, 
                child: Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Column(
      children: [
        _buildDesktopIcon(Icons.computer, "My Rig", () => _openWindow('specs'), color: neonCyan),
        const SizedBox(height: 15),
        _buildDesktopIcon(Icons.speed, "Benchmark", () => _openWindow('benchmark'), color: neonRed),
        const SizedBox(height: 15),
        
        // NEW: GARAGE ICON
        _buildDesktopIcon(Icons.garage, "Garage", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedBuildsScreen()));
        }, color: Colors.purpleAccent),
        
      ],
    ),
    const SizedBox(width: 15), 
    Column(
      children: [
        
        // UPDATED: SAVE ICON NOW CALLS THE DIALOG
        _buildDesktopIcon(Icons.save, "Save Build", _showSaveDialog, color: neonCyan), 
        const SizedBox(height: 15),
        _buildDesktopIcon(Icons.science, "Labs", () {
  Navigator.push(context, MaterialPageRoute(builder: (context) => const LabsScreen()));
}, color: Colors.greenAccent),
      ],
    ),
  ],
),),

            // 3. MAXIMIZED WINDOW (Fills screen up to taskbar)
            if (_activeWindow != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 50, // Leave space for taskbar
                child: _buildMaximizedWindow(
                  title: _activeWindow == 'specs' ? "SYSTEM SPECIFICATIONS" : "PERFORMANCE BENCHMARK",
                  themeColor: _activeWindow == 'specs' ? neonCyan : neonRed,
                  
                  // <--- UPDATED SECTION STARTS HERE --->
                  content: _activeWindow == 'specs' 
                      ? _buildSpecsContent() 
                      : BenchmarkScreen( // Now correctly calls your new external file
                          cpu: widget.cpu,
                          gpu: widget.gpu,
                          ram: widget.ram,
                          storage: widget.storage,
                        ),),
              ),

            // 4. START MENU
            if (_isStartMenuOpen)
              Positioned(bottom: 55, left: 0, child: _buildStartMenu()),

            // 5. TASKBAR (Always on top)
            Positioned(bottom: 0, left: 0, right: 0, child: _buildTaskbar()),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildMaximizedWindow({required String title, required Color themeColor, required Widget content}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF050505),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),  // Rounded Top Corners
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(color: themeColor.withOpacity(0.1), blurRadius: 20, spreadRadius: 2)
        ],
        image: const DecorationImage(
          image: AssetImage('assets/grid.png'), // If you have it, else remove
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          // APP TITLE BAR (Now Rounded at top)
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only( // Match the container
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(bottom: BorderSide(color: themeColor.withOpacity(0.3))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.hub, color: themeColor, size: 20),
                    const SizedBox(width: 15),
                    Text(title, style: GoogleFonts.orbitron(color: themeColor, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54, size: 24),
                  onPressed: _closeWindow,
                ),
              ],
            ),
          ),
          
          // CONTENT AREA
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: content,
            ),
          ),
        ],
      ),
    );
  }

 // --- SPECS CONTENT (Fixed Layout & Blue Power Meter) ---
  Widget _buildSpecsContent() {
    // 1. Calculate Rank
    String rankName = "ENTRY LEVEL";
    Color rankColor = Colors.grey;
    IconData rankIcon = Icons.circle_outlined;
    
    if (totalCost > 150000) {
      rankName = "GOD TIER";
      rankColor = const Color(0xFFFFD700); // Gold
      rankIcon = Icons.workspace_premium;
    } else if (totalCost > 80000) {
      rankName = "HIGH-PERFORMANCE";
      rankColor = Colors.purpleAccent;
      rankIcon = Icons.verified;
    } else if (totalCost > 40000) {
      rankName = "MID-RANGE";
      rankColor = neonCyan;
      rankIcon = Icons.shield;
    }

    // 2. Estimate Power (Fake logic)
    int psuWattage = widget.psu.wattage;
    int estimatedLoad = (psuWattage * 0.75).toInt(); 

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT COLUMN: Component List (Expanded to take available space)
        Expanded(
          flex: 3,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildProSpecRow(Icons.memory, "CPU PROCESSOR", "${widget.cpu.name} @ ${widget.cpu.baseClock}GHz"),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.developer_board, "MOTHERBOARD", widget.mobo.name),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.storage, "MEMORY (RAM)", widget.ram.name),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.videogame_asset, "GRAPHICS", widget.gpu != null ? "${widget.gpu!.name} (${widget.gpu!.vram}GB)" : "Integrated Graphics"),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.save, "STORAGE DRIVE", widget.storage.name),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.ac_unit, "COOLING", widget.cooler.name),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.power, "POWER SUPPLY", "${widget.psu.name} (${widget.psu.wattage}W)"),
            ],
          ),
        ),
        
        const SizedBox(width: 20), 

        // RIGHT COLUMN: Dashboard (Fixed spacing to prevent overflow)
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align to top
            children: [
              // MODULE 1: SYSTEM RANK
              Container(
                padding: const EdgeInsets.all(12), // Reduced padding slightly
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: rankColor.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(rankIcon, color: rankColor, size: 28),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("SYSTEM RANK", style: GoogleFonts.shareTechMono(color: Colors.white54, fontSize: 12)),
                        Text(rankName, style: GoogleFonts.orbitron(color: rankColor, fontSize: 13, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 12), // Fixed gap

              // MODULE 2: POWER METER (Now Neon Blue Filled)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: neonCyan.withOpacity(0.1), // <--- CYAN FILL
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: neonCyan.withOpacity(0.5)), // <--- CYAN BORDER
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("POWER DRAW", style: GoogleFonts.shareTechMono(color: neonCyan, fontSize: 12)),
                        Text("${estimatedLoad}W / ${psuWattage}W", style: GoogleFonts.roboto(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.75,
                        backgroundColor: Colors.black,
                        color: neonCyan, // Cyan Bar
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12), // Fixed gap

              // MODULE 3: COMPACT PRICE TAG
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                decoration: BoxDecoration(
                  color: neonRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: neonRed.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("TOTAL COST", style: GoogleFonts.shareTechMono(color: neonRed, fontSize: 12)),
                        Text("INCL. TAXES", style: GoogleFonts.shareTechMono(color: Colors.white38, fontSize: 8)),
                      ],
                    ),
                    Text(
                      "₹${totalCost.toStringAsFixed(0)}", 
                      style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

 Widget _buildProSpecRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03), 
        borderRadius: BorderRadius.circular(8), // <--- THE FIX (Was 0 or default)
        border: Border.all(color: Colors.white.withOpacity(0.05)), // Subtle border
      ),
      child: Row(
        children: [
          // Icon Box (Also Rounded)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black, 
              borderRadius: BorderRadius.circular(6), // Slightly tighter radius inside
              border: Border.all(color: neonCyan.withOpacity(0.3))
            ),
            child: Icon(icon, color: neonCyan, size: 20),
          ),
          const SizedBox(width: 15),
          
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label, 
                  style: GoogleFonts.shareTechMono(color: neonCyan.withOpacity(0.7), fontSize: 10, letterSpacing: 1),
                ),
                const SizedBox(height: 4),
                Text(
                  value, 
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTaskbar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.95), border: const Border(top: BorderSide(color: neonCyan, width: 2)), boxShadow: [BoxShadow(color: neonCyan.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, -2))]),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack( 
        children: [
          Align(alignment: Alignment.centerLeft, child: GestureDetector(onTap: _toggleStartMenu, child: Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5), decoration: BoxDecoration(gradient: LinearGradient(colors: _isStartMenuOpen ? [neonCyan.withOpacity(0.4), neonCyan.withOpacity(0.1)] : [neonCyan.withOpacity(0.2), Colors.transparent]), border: Border.all(color: _isStartMenuOpen ? neonCyan : neonCyan.withOpacity(0.5)), borderRadius: BorderRadius.circular(4)), child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.bug_report, color: neonCyan, size: 20), const SizedBox(width: 8), Text("START", style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold))])))),
          Align(alignment: Alignment.center, child: Text("SPYDAR OS", style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 3, shadows: [const Shadow(color: neonCyan, blurRadius: 10), const Shadow(color: neonCyan, blurRadius: 20)]))),
          Align(alignment: Alignment.centerRight, child: Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.wifi, color: neonCyan, size: 16), const SizedBox(width: 15), const Icon(Icons.volume_up, color: neonCyan, size: 16), const SizedBox(width: 15), Text(_timeString, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 12))])),
        ],
      ),
    );
  }

 Widget _buildStartMenu() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(15), // Rounded Top Right
        bottomRight: Radius.circular(15) // Rounded Bottom Right (Floating look)
      ), 
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: 300, 
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A).withOpacity(0.95), 
            border: Border.all(color: neonCyan, width: 1),
            // No Border Radius here needed because ClipRRect handles it, 
            // but strictly we can match it:
            borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Container(width: 4, height: 40, color: neonCyan), const SizedBox(width: 15), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SYSTEM :: ADMIN", style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), Text("STATUS: ONLINE", style: GoogleFonts.shareTechMono(color: neonCyan, fontSize: 12))])]),
              const SizedBox(height: 10),
              const Divider(color: Colors.white24),
              const SizedBox(height: 10),
              Text("[ THEME SELECTOR ]", style: GoogleFonts.shareTechMono(color: Colors.white54)),
              const SizedBox(height: 10),
              Wrap(spacing: 10, children: [_buildWallpaperOption(_wallpapers[0], true), _buildWallpaperOption(_wallpapers[1], true), _buildWallpaperOption(_wallpapers[2], false)]),
              const SizedBox(height: 30),
              GestureDetector(onTap: () => Navigator.pop(context), child: Container(height: 45, width: double.infinity, decoration: BoxDecoration(color: neonRed.withOpacity(0.1), border: Border.all(color: neonRed), boxShadow: [BoxShadow(color: neonRed.withOpacity(0.2), blurRadius: 10)]), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.power_settings_new, color: neonRed, size: 20), const SizedBox(width: 10), Text("SHUTDOWN", style: GoogleFonts.orbitron(color: neonRed, fontSize: 14, fontWeight: FontWeight.bold))]))),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildWallpaperOption(String assetPath, bool isUnlocked) {
    return GestureDetector(
      onTap: () { if (isUnlocked && assetPath.isNotEmpty) _changeWallpaper(assetPath); },
      child: Container(
        width: 60, height: 60, // Bigger thumbnails
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: (_currentWallpaper == assetPath) ? neonCyan : Colors.white12, width: (_currentWallpaper == assetPath) ? 2 : 1),
          image: (isUnlocked && assetPath.isNotEmpty) ? DecorationImage(image: AssetImage(assetPath), fit: BoxFit.cover, opacity: 0.8) : null,
        ),
        child: !isUnlocked ? const Center(child: Icon(Icons.lock_outline, color: Colors.white24)) : null,
      ),
    );
  }

  Widget _buildDesktopIcon(IconData icon, String label, VoidCallback onTap, {required Color color}) {
    return GestureDetector(onTap: onTap, child: Container(width: 80, color: Colors.transparent, child: Column(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3)), boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, spreadRadius: 1)]), child: Icon(icon, color: color, size: 28)), const SizedBox(height: 6), Text(label, textAlign: TextAlign.center, maxLines: 2, style: GoogleFonts.roboto(color: Colors.white, fontSize: 11, shadows: [const Shadow(color: Colors.black, blurRadius: 4)]))])));
  }

  void _openWindow(String windowName) { setState(() { _activeWindow = windowName; _isStartMenuOpen = false; }); }
  void _closeWindow() { setState(() { _activeWindow = null; }); }
  void _toggleStartMenu() { setState(() { _isStartMenuOpen = !_isStartMenuOpen; }); }
  void _changeWallpaper(String assetPath) { setState(() { _currentWallpaper = assetPath; }); }
}