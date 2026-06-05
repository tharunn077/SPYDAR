import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'simulator/simulator_screen.dart'; 
import 'games/maps.dart'; 
import 'simulator/os_screen.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  static const Color neonCyan = Color(0xFF00F3FF);
  static const Color neonRed = Color(0xFFFF003C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Pure pitch black void
      body: Stack(
        children: [
          // 1. THE NEURAL MESH 
          const Positioned.fill(
            child: NeuralMeshBackground(
              cyanColor: neonCyan,
              redColor: neonRed,
              particleCount: 40, 
              connectionDistance: 110.0, 
            ),
          ),

          // 2. THE UI DECK
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. LEFT: Main Action - CYAN
                _buildBrutalistCard(
                  context, 
                  title: "NEW SIMULATION", 
                  subtitle: "INITIALIZE HARDWARE",
                 // Delete the imageAsset line and use this instead:
icon: Icons.handyman_outlined, // ✅ Using your custom image!
                  color: neonCyan,
                  width: 320,
                  height: 320,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SimulatorScreen())),
                ),

                const SizedBox(width: 40),

                // 2. RIGHT: Secondary Options - RED
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBrutalistCard(
                      context, 
                      title: "SPYDAR OS", 
                      subtitle: "SYSTEM TERMINAL",
                      icon: Icons.code, 
                      color: neonRed, 
                      width: 280,
                      height: 145,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const OsScreen())),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    _buildBrutalistCard(
                      context, 
                      title: "GAMING HUB", 
                      subtitle: "INTO THE MULTIVERSE",
                      icon: Icons.gamepad_outlined, 
                      color: neonRed, 
                      width: 280,
                      height: 145,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const MapSelectionScreen())),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- THE BRUTALIST WIDGET ---
  Widget _buildBrutalistCard(BuildContext context, {
    required String title, 
    required String subtitle,
    IconData? icon, 
    String? imageAsset, 
    required Color color, 
    required double width,
    required double height,
    required VoidCallback onTap
  }) {
    final BorderRadius cardRadius = BorderRadius.circular(16);

    return InkWell(
      onTap: onTap,
      splashColor: color.withOpacity(0.2),
      highlightColor: Colors.transparent,
      borderRadius: cardRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. The Offset Wireframe
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: cardRadius, 
                  border: Border.all(color: color.withOpacity(0.4), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: cardRadius,
                  child: CustomPaint(painter: StripePainter(color: color.withOpacity(0.1))),
                ),
              ),
            ),

            // 2. The Main Solid Box 
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.black, 
                borderRadius: cardRadius, 
                border: Border.all(color: color, width: 2),
              ),
              child: ClipRRect(
                borderRadius: cardRadius,
                child: Stack(
                  children: [
                    // INTERNAL NEURAL MESH
                    Positioned.fill(
                      child: NeuralMeshBackground(
                        cyanColor: color, 
                        redColor: color, 
                        particleCount: 10, 
                        connectionDistance: 50.0, 
                      ),
                    ),
                    
                    // Main Text & Icon Content
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        mainAxisAlignment: MainAxisAlignment.end, 
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(top: height > 200 ? 20.0 : 0.0),
                              child: imageAsset != null 
                                ? Image.asset(
                                    imageAsset, 
                                    width: height > 200 ? 80 : 40, 
                                    height: height > 200 ? 80 : 40, 
                                    // ✅ FIXED: BoxFit.contain stops it from stretching
                                    fit: BoxFit.contain, 
                                    // ✅ FIXED: Setting the color here forces Flutter to ONLY tint the opaque pixels (BlendMode.srcIn)
                                    color: color, 
                                  )
                                : Icon(
                                    icon, 
                                    size: height > 200 ? 95 : 38, 
                                    color: color
                                  ),
                            ),
                          ),
                          
                          const Spacer(),
                          
                          Text(
                            subtitle, 
                            style: GoogleFonts.shareTechMono(
                              color: Colors.white54, 
                              fontSize: 12, 
                              letterSpacing: 2
                            )
                          ),
                          const SizedBox(height: 5),
                          
                          Text(
                            title, 
                            style: GoogleFonts.orbitron(
                              color: Colors.white, 
                              fontSize: height > 200 ? 24 : 18, 
                              fontWeight: FontWeight.w900, 
                              letterSpacing: 2
                            )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // 3. Decorative corner square
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6), 
                    bottomRight: Radius.circular(14), 
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ======================================================================
// THE NEURAL MESH PLEXUS ENGINE 
// ======================================================================
class NeuralMeshBackground extends StatefulWidget {
  final Color cyanColor;
  final Color redColor;
  final int particleCount; 
  final double connectionDistance; 

  const NeuralMeshBackground({
    super.key, 
    required this.cyanColor, 
    required this.redColor,
    this.particleCount = 60, 
    this.connectionDistance = 150.0,
  });

  @override
  State<NeuralMeshBackground> createState() => _NeuralMeshBackgroundState();
}

class _NeuralMeshBackgroundState extends State<NeuralMeshBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<MeshNode> _nodes = [];
  final math.Random _random = math.Random();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  void _initNodes(Size size) {
    if (_isInitialized) return;
    bool isSingleColor = widget.cyanColor == widget.redColor;

    for (int i = 0; i < widget.particleCount; i++) { 
      bool isLeft = _random.nextBool(); 
      double xPos = isSingleColor 
          ? _random.nextDouble() * size.width 
          : (isLeft ? _random.nextDouble() * (size.width / 2) : (size.width / 2) + (_random.nextDouble() * (size.width / 2)));

      _nodes.add(
        MeshNode(
          color: isLeft || isSingleColor ? widget.cyanColor : widget.redColor,
          x: xPos,
          y: _random.nextDouble() * size.height,
          vx: (_random.nextDouble() - 0.5) * 1.5,
          vy: (_random.nextDouble() - 0.5) * 1.5,
        ),
      );
    }
    _isInitialized = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 0 && constraints.maxHeight > 0) {
          _initNodes(Size(constraints.maxWidth, constraints.maxHeight));
        }
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size.infinite,
              painter: MeshPainter(
                nodes: _nodes, 
                connectionDist: widget.connectionDistance
              ),
            );
          },
        );
      }
    );
  }
}

class MeshNode {
  final Color color;
  double x, y, vx, vy;
  MeshNode({required this.color, required this.x, required this.y, required this.vx, required this.vy});
}

class MeshPainter extends CustomPainter {
  final List<MeshNode> nodes;
  final double connectionDist;

  MeshPainter({required this.nodes, required this.connectionDist});

  @override
  void paint(Canvas canvas, Size size) {
    for (var node in nodes) {
      node.x += node.vx;
      node.y += node.vy;

      if (node.x <= 0 || node.x >= size.width) node.vx *= -1;
      if (node.y <= 0 || node.y >= size.height) node.vy *= -1;
    }

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        double dx = nodes[i].x - nodes[j].x;
        double dy = nodes[i].y - nodes[j].y;
        double distance = math.sqrt(dx * dx + dy * dy);

        if (distance < connectionDist) {
          double opacity = 1.0 - (distance / connectionDist);
          
          final linePaint = Paint()
            ..color = nodes[i].color.withOpacity(opacity * 0.4) 
            ..strokeWidth = 1.0
            ..style = PaintingStyle.stroke;

          canvas.drawLine(Offset(nodes[i].x, nodes[i].y), Offset(nodes[j].x, nodes[j].y), linePaint);
        }
      }
    }

    for (var node in nodes) {
      final nodePaint = Paint()
        ..color = node.color.withOpacity(0.8)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(node.x, node.y), 1.5, nodePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// --- Paints diagonal lines inside the offset shadow ---
class StripePainter extends CustomPainter {
  final Color color;
  StripePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    for (double i = -size.height; i < size.width; i += 10) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}