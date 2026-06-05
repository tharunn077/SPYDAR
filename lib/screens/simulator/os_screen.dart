import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui'; 
import 'dart:async'; 
import '../../../models/component_model.dart';
import '../benchmark/benchmark_screen.dart';
import 'dart:convert'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import '../saved_builds/saved_list_screen.dart'; 
import 'dart:math'; 
import '../apps/labs_screen.dart'; 
import '../games/maps.dart'; 

class OsScreen extends StatefulWidget {
  // ✅ 1. ALL COMPONENTS ARE NOW OPTIONAL (NULLABLE)
  final Cpu? cpu;
  final Gpu? gpu;
  final Ram? ram;
  final Motherboard? mobo;
  final Psu? psu;
  final Storage? storage;
  final Cooler? cooler;

  const OsScreen({
    super.key,
    this.cpu,
    this.gpu,
    this.ram,
    this.mobo,
    this.psu,
    this.storage,
    this.cooler,
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
  
  // ✅ FIX 1: Swapped the 2nd slot to be your new Doc Ock background
  final List<String> _wallpapers = ['assets/web.png', 'assets/doc_ock_bg.png', 'assets/city.png'];

  late Timer _timer;
  String _timeString = "12:00 PM"; 
  
  // ✅ FIX 2: State variable to track the unlock
  bool _isDocOckUnlocked = false;

  bool get _hasBuild => widget.cpu != null;

  @override
  void initState() {
    super.initState();
    _updateTime(); 
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
    _loadUnlocks(); // ✅ FIX 3: Run the check when OS boots
  }

  Future<void> _loadUnlocks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDocOckUnlocked = prefs.getBool('doc_ock_unlocked') ?? false;
      // Loads the saved wallpaper, defaults to web.png if it's their first time playing
      _currentWallpaper = prefs.getString('saved_wallpaper') ?? 'assets/web.png'; 
    });
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

  // ✅ 3. SAFE COST CALCULATION
  double get totalCost => 
      (widget.cpu?.price ?? 0) + 
      (widget.gpu?.price ?? 0) + 
      (widget.ram?.price ?? 0) + 
      (widget.mobo?.price ?? 0) + 
      (widget.psu?.price ?? 0) + 
      (widget.storage?.price ?? 0) + 
      (widget.cooler?.price ?? 0);

  // ✅ 4. THE EMPTY STATE WARNING DIALOG
  void _showEmptyWarning() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0A0A0A),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: neonRed, width: 2), 
          borderRadius: BorderRadius.circular(10)
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: neonRed), 
            const SizedBox(width: 7), 
            Text("SYSTEM EMPTY", style: GoogleFonts.orbitron(color: neonRed, fontWeight: FontWeight.bold))
          ]
        ),
        content: Text(
          "Hardware components not detected.\n\nPlease start a 'New Simulation' or load a blueprint from the Vault to access this module.", 
          style: GoogleFonts.shareTechMono(color: Colors.white70)
        ),
        // 👇 REPLACED THIS SECTION:
       actions: [
          GestureDetector(
            onTap: () => Navigator.pop(ctx),
            child: Container(
              // ✅ Increased horizontal padding from 16 to 36 to make it longer
              // ✅ Increased vertical padding from 8 to 10 for better proportions
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20), 
              margin: const EdgeInsets.only(bottom: 5, right: 5),
              decoration: BoxDecoration(
                color: neonCyan.withOpacity(0.1), // Faint neon fill
                border: Border.all(color: neonCyan.withOpacity(0.8), width: 1), // Minimal crisp border
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(color: neonCyan.withOpacity(0.2), blurRadius: 8) // Subtle glow
                ],
              ),
              child: Text(
                "ACKNOWLEDGE", 
                style: GoogleFonts.orbitron(color: neonCyan, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
              ),
            ),
          )

        ],
      )
    );
  }

  Future<void> _showSaveDialog() async {
    TextEditingController nameController = TextEditingController();
    
    final prefs = await SharedPreferences.getInstance();
    String? existingData = prefs.getString('saved_rigs');
    List<dynamic> currentList = existingData != null ? json.decode(existingData) : [];
    int nextNumber = currentList.length + 1;
    nameController.text = "PC $nextNumber"; 

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: SingleChildScrollView( 
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
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "RIG UPLOAD", 
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
                    TextField(
                      controller: nameController,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context), 
                          style: TextButton.styleFrom(foregroundColor: neonRed),
                          child: Text("ABORT", style: GoogleFonts.shareTechMono(fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 15),
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

  Future<void> _saveToStorage(String name) async {
    final prefs = await SharedPreferences.getInstance();
    
    Map<String, dynamic> newBuild = {
      'name': name,
      'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      'cpu': widget.cpu!.name,
      'gpu': widget.gpu?.name ?? "Integrated",
      'ram': widget.ram!.name,
      'cooler': widget.cooler!.name,
      'psu': widget.psu!.name,
      'cost': totalCost.toStringAsFixed(0),
      'mobo': widget.mobo!.name,
      'storage': widget.storage!.name,
    };

    String? existingData = prefs.getString('saved_rigs');
    List<dynamic> buildList = existingData != null ? json.decode(existingData) : [];
    
    buildList.add(newBuild);
    await prefs.setString('saved_rigs', json.encode(buildList));

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
            // 1. WALLPAPER
            Positioned.fill(
              child: Opacity(
                opacity: 0.8, // ✅ Change this! 0.0 is invisible, 1.0 is full brightness
                child: Image.asset(
                  _currentWallpaper, 
                  fit: BoxFit.cover, 
                  errorBuilder: (c, o, s) => Container(color: Colors.black)
                ),
              ),
            ),

            // 2. DESKTOP ICONS
            if (_activeWindow == null)
              Positioned(
                top: 30, left: 20, bottom: 60, 
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        // ✅ 5. PROTECTED APP ICONS
                        _buildDesktopIcon(Icons.computer, "My Rig", () {
                          if (!_hasBuild) { _showEmptyWarning(); return; }
                          _openWindow('specs');
                        }, color: neonCyan),
                        
                        const SizedBox(height: 15),
                        
                        _buildDesktopIcon(Icons.speed, "SpydarMark", () {
                          if (!_hasBuild) { _showEmptyWarning(); return; }
                          _openWindow('benchmark');
                        }, color: neonRed),
                        
                        const SizedBox(height: 15),
                        
                        // Garage stays accessible so they can look at old builds!
                        _buildDesktopIcon(Icons.lock_clock_outlined, "Vault", () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedBuildsScreen()));
                        }, color: Colors.purpleAccent),
                        
                      ],
                    ),
                    const SizedBox(width: 15), 
                    Column(
                      children: [
                        _buildDesktopIcon(Icons.save, "Save Build", () {
                          if (!_hasBuild) { _showEmptyWarning(); return; }
                          _showSaveDialog();
                        }, color: neonCyan), 
                        
                        const SizedBox(height: 15),
                        
                        _buildDesktopIcon(Icons.science, "Labs", () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LabsScreen()));
                        }, color: Colors.greenAccent),

                        const SizedBox(height: 15), 
                        
                        _buildDesktopIcon(Icons.gamepad, "Games", () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MapSelectionScreen()));
                        }, color: Colors.orangeAccent),
                      ],
                    ),
                  ],
                ),
              ),

            // 3. MAXIMIZED WINDOW
            if (_activeWindow != null)
              Positioned(
                top: 0, left: 0, right: 0, bottom: 50, 
                child: _buildMaximizedWindow(
                  title: _activeWindow == 'specs' ? "                          SYSTEM SPECIFICATIONS" : "                        PERFORMANCE BENCHMARK",
                  themeColor: _activeWindow == 'specs' ? neonCyan : neonRed,
                  
                  // ✅ 6. FORCED NOT-NULL (!) BECAUSE WE BLOCKED EMPTY ACCESS ABOVE
                  content: _activeWindow == 'specs' 
                      ? _buildSpecsContent() 
                      : BenchmarkScreen( 
                          cpu: widget.cpu!,
                          gpu: widget.gpu,
                          ram: widget.ram!,
                          storage: widget.storage!,
                        ),
                ),
              ),

            // 4. START MENU
            if (_isStartMenuOpen)
              Positioned(bottom: 55, left: 0, child: _buildStartMenu()),

            // 5. TASKBAR
            Positioned(bottom: 0, left: 0, right: 0, child: _buildTaskbar()),
          ],
        ),
      ),
    );
  }

 Widget _buildMaximizedWindow({required String title, required Color themeColor, required Widget content}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF050505),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(color: themeColor.withOpacity(0.1), blurRadius: 20, spreadRadius: 2)
        ],
        image: const DecorationImage(
          image: AssetImage('assets/grid.png'), 
          fit: BoxFit.cover,
          opacity: 0.1,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            // Reduced horizontal padding slightly to account for the IconButton's built-in padding
            padding: const EdgeInsets.symmetric(horizontal: 10), 
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only( 
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(bottom: BorderSide(color: themeColor.withOpacity(0.3))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align everything to the left
              children: [
                // 1. BACK BUTTON ON THE LEFT
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white54, size: 24),
                  onPressed: _closeWindow, // Closes the active window to return to desktop
                ),
                const SizedBox(width: 5), // Small gap
                
                // 2. TITLE (No extra icon)
                Text(
                  title, 
                  style: GoogleFonts.orbitron(color: themeColor, fontSize: 16, letterSpacing: 3, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
          
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

  Widget _buildSpecsContent() {
    String rankName = "ENTRY LEVEL";
    Color rankColor = Colors.grey;
    IconData rankIcon = Icons.circle_outlined;
    
    if (totalCost > 150000) {
      rankName = "GOD TIER";
      rankColor = const Color.fromARGB(255, 236, 8, 8); 
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

    // ✅ Safe default for Wattage
    int psuWattage = widget.psu?.wattage ?? 0;
    int estimatedLoad = (psuWattage * 0.75).toInt(); 

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildProSpecRow(Icons.memory, "CPU PROCESSOR", "${widget.cpu!.name} @ ${widget.cpu!.baseClock}GHz"),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.developer_board, "MOTHERBOARD", widget.mobo!.name),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.storage, "MEMORY (RAM)", widget.ram!.name),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.videogame_asset, "GRAPHICS", widget.gpu != null ? "${widget.gpu!.name} (${widget.gpu!.vram}GB)" : "Integrated Graphics"),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.save, "STORAGE DRIVE", widget.storage!.name),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.ac_unit, "COOLING", widget.cooler!.name),
              const SizedBox(height: 8),
              _buildProSpecRow(Icons.power, "POWER SUPPLY", "${widget.psu!.name} (${widget.psu!.wattage}W)"),
            ],
          ),
        ),
        
        const SizedBox(width: 20), 

        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              Container(
                padding: const EdgeInsets.all(12), 
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

              const SizedBox(height: 12), 

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: neonCyan.withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: neonCyan.withOpacity(0.5)), 
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
                        color: neonCyan, 
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12), 

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
             Wrap(
                spacing: 10, 
                children: [
                  _buildWallpaperOption(_wallpapers[0], true), // Always unlocked
                  // ✅ FIX 5: Slot 2 is now tied directly to the unlock system!
                  _buildWallpaperOption(_wallpapers[1], _isDocOckUnlocked), 
                  _buildWallpaperOption(_wallpapers[2], false) // Still locked
                ]
              ),
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
 void _changeWallpaper(String assetPath) async { 
    setState(() { _currentWallpaper = assetPath; }); 
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_wallpaper', assetPath);
  }
}