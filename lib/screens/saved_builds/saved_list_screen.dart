import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spydar/screens/simulator/simulator_screen.dart';
import 'dart:convert';

class SavedBuildsScreen extends StatefulWidget {
  final bool isSelectionMode; 
  // ✅ 1. ADD COLOR PARAMETER
  final Color themeColor;

  const SavedBuildsScreen({
    super.key, 
    this.isSelectionMode = false,
    // Default to Cyan (Blue) if not specified (e.g. standard Garage view)
    this.themeColor = const Color(0xFF00FFFF), 
  });

  @override
  State<SavedBuildsScreen> createState() => _SavedBuildsScreenState();
}

class _SavedBuildsScreenState extends State<SavedBuildsScreen> {
  List<Map<String, dynamic>> _savedBuilds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBuilds();
  }

  Future<void> _loadBuilds() async {
    final prefs = await SharedPreferences.getInstance();
    final String? buildsString = prefs.getString('saved_rigs');
    
    if (buildsString != null) {
      setState(() {
       _savedBuilds = List<Map<String, dynamic>>.from(json.decode(buildsString)).reversed.toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteBuild(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedBuilds.removeAt(index);
    });
    await prefs.setString('saved_rigs', json.encode(_savedBuilds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.isSelectionMode ? "SELECT BLUEPRINT" : "THE GARAGE", 
          // ✅ USE THEME COLOR
          style: GoogleFonts.orbitron(color: widget.themeColor, letterSpacing: 2, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        // ✅ USE THEME COLOR FOR BACK BUTTON
        iconTheme: IconThemeData(color: widget.themeColor), 
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: widget.themeColor.withOpacity(0.3), height: 1),
        ),
      ),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator(color: widget.themeColor))
          : _savedBuilds.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _savedBuilds.length,
                  itemBuilder: (context, index) {
                    final build = _savedBuilds[index];
                    return _buildRigCard(build, index);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.garage_outlined, size: 80, color: Colors.white10),
          const SizedBox(height: 20),
          Text("NO SECURE BLUEPRINTS FOUND", style: GoogleFonts.shareTechMono(color: Colors.white24, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildRigCard(Map<String, dynamic> build, int index) {
    // Determine Stripe Color:
    // If Selecting: Use the passed Theme Color (Blue or Red)
    // If Garage: Use Red for stripe (or keep it Theme Color if you prefer)
    Color stripeColor = widget.isSelectionMode ? widget.themeColor : const Color(0xFFFF003C);

    return Center(
      child: GestureDetector(
        onTap: () {
          if (widget.isSelectionMode) {
            Navigator.pop(context, build);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SimulatorScreen(loadedBuild: build),
              ),
            );
          }
        },
        child: Container(
          width: 650, 
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F12), 
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              // ✅ DYNAMIC BORDER COLOR
              color: widget.isSelectionMode ? widget.themeColor.withOpacity(0.3) : Colors.white10
            ),
            boxShadow: [
              BoxShadow(
                // ✅ DYNAMIC SHADOW COLOR
                color: widget.themeColor.withOpacity(0.05), 
                blurRadius: 10, 
                offset: const Offset(0, 4)
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                // ✅ DYNAMIC STRIPE
                Positioned(
                  left: 0, top: 0, bottom: 0,
                  child: Container(
                    width: 3, 
                    color: stripeColor
                  ),
                ),

                // CONTENT
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 12, 12), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- HEADER ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(build['name'] ?? "UNKNOWN NODE", 
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text("CREATED: ${build['date']}", 
                                  style: GoogleFonts.shareTechMono(color: Colors.white30, fontSize: 10)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            // ✅ PRICE IN THEME COLOR
                            child: Text("₹${build['cost']}", 
                              style: GoogleFonts.orbitron(color: widget.themeColor, fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12), 
                      
                      // --- SPECS ---
                      _buildSpecRow(Icons.memory, build['cpu']),
                      const SizedBox(height: 2),
                      _buildSpecRow(Icons.videogame_asset, build['gpu']),
                      
                      // --- DELETE BUTTON ---
                      if (!widget.isSelectionMode)
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 24, 
                            width: 24,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              // Delete button usually stays Red for danger
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFFF003C), size: 20),
                              onPressed: () => _deleteBuild(index),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecRow(IconData icon, String? text) {
    return Row(
      children: [
        // ✅ ICON IN THEME COLOR (slightly dimmed)
        Icon(icon, size: 14, color: widget.themeColor.withOpacity(0.8)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text ?? "N/A", 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(color: Colors.white70, fontSize: 12)
          ),
        ),
      ],
    );
  }
}