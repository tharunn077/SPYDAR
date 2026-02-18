import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart'; 
import '../../../models/component_model.dart';
import '../../../logic/heuristic_engine.dart';
import 'sci_fi_dialog.dart';

class InventoryList extends StatefulWidget {
  final String slotType;
  final List<dynamic> items;
  final dynamic equippedItem;
  
  // Passed Context Items
  final Cpu? currentCpu;
  final Motherboard? currentMobo;
  final Ram? currentRam;
  final Storage? currentStorage;
  final Cooler? currentCooler;

  final Function(dynamic) onEquip;
  final Function(dynamic) onPreview;
  final Color themeColor;

  const InventoryList({
    super.key,
    required this.slotType,
    required this.items,
    required this.equippedItem,
    required this.onEquip,
    required this.onPreview,
    required this.themeColor,
    this.currentCpu,
    this.currentMobo,
    this.currentRam,
    this.currentStorage,
    this.currentCooler,
  });

  @override
  State<InventoryList> createState() => _InventoryListState();
}

class _InventoryListState extends State<InventoryList> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    
    // 1. OPTIMIZE FOR SFX
    _audioPlayer.setPlayerMode(PlayerMode.lowLatency); 
    
    // 2. CRITICAL: PRE-LOAD THE FILE NOW!
    // This puts the sound in RAM. If you don't do this, it lags on tap.
    _audioPlayer.setSource(AssetSource('thwip.wav')); 
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); 
    super.dispose();
  }

  void _playThwipSound() async {
    // 1. Force the player to stop (This resets the position to 0:00)
    await _audioPlayer.stop(); 
    
    // 2. Now Play (It will start fresh from the beginning)
    // We use play() again to ensure it triggers correctly even if completed
    await _audioPlayer.play(AssetSource('thwip.wav'), volume: 0.3);
  }
  
  // ... rest of your build code ...

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: widget.themeColor.withOpacity(0.5),
      radius: const Radius.circular(20),
      thickness: 4,
      thumbVisibility: true,
      interactive: true, 
      child: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.only(right: 12, bottom: 20),
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];

          String name = "Unknown";
          num price = 0;
          String specs = "";
          IconData icon = Icons.help;

          // --- 1. DATA CASTING ---
          if (item is Cpu) {
            name = item.name;
            price = item.price;
            specs = "${item.coreCount} Cores | ${item.tdp}W";
            icon = Icons.memory;
          } else if (item is Motherboard) {
            name = item.name;
            price = item.price;
            specs = "Socket: ${item.socket} | ${item.memoryType}";
            icon = Icons.developer_board;
          } else if (item is Ram) {
            name = item.name;
            price = item.price;
            icon = Icons.storage;
            specs = "${item.capacity}GB | ${item.speed} MHz";
          } else if (item is Gpu) {
            name = item.name;
            price = item.price;
            icon = Icons.videogame_asset;
            specs = "${item.vram}GB ${item.memoryType}";
          } else if (item is Storage) {
            name = item.name;
            price = item.price;
            icon = item.format == "M.2" ? Icons.sd_storage : Icons.save;
            String cap = item.capacity >= 1000 
                ? "${(item.capacity / 1000).toStringAsFixed(0)}TB" 
                : "${item.capacity}GB";
            specs = "$cap ${item.type} | ${item.readSpeed} MB/s";
          } else if (item is Psu) {
            name = item.name;
            price = item.price;
            icon = Icons.power;
            specs = "${item.wattage}W | ${item.efficiency}";
          } else if (item is Cooler) {
            name = item.name;
            price = item.price;
            icon = Icons.ac_unit; 
            specs = "${item.type} | ${item.fanCount} Fan${item.fanCount > 1 ? 's' : ''}";
          }

          bool isEquipped = widget.equippedItem != null && widget.equippedItem.name == name;

          // --- 2. LOGIC ENGINE CHECK ---
          bool isCompatible = true;

          if (widget.slotType == "CPU") {
            isCompatible = HeuristicEngine.checkCompatibility(
                cpu: item, 
                mobo: widget.currentMobo, 
                cooler: widget.currentCooler 
            );
          } 
          else if (widget.slotType == "MOTHER\nBOARD") {
            isCompatible = HeuristicEngine.checkCompatibility(
                cpu: widget.currentCpu, 
                mobo: item, 
                ram: widget.currentRam, 
                storage: widget.currentStorage,
                cooler: widget.currentCooler 
            );
          } 
          else if (widget.slotType == "RAM") {
            isCompatible = HeuristicEngine.checkCompatibility(ram: item, mobo: widget.currentMobo);
          } 
          else if (widget.slotType == "STORAGE") {
            isCompatible = HeuristicEngine.checkCompatibility(storage: item, mobo: widget.currentMobo);
          } 
          else if (widget.slotType == "COOLER") {
            isCompatible = HeuristicEngine.checkCompatibility(
              cooler: item, 
              mobo: widget.currentMobo, 
              cpu: widget.currentCpu
            );
          }

          // --- 3. BUILD UI ---
          return Stack(
            children: [
              // 1. THE COMPONENT CARD
              Opacity(
                opacity: isCompatible ? 1.0 : 0.4,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isEquipped
                        ? widget.themeColor.withOpacity(0.15)
                        : (isCompatible ? Colors.white.withOpacity(0.05) : Colors.red.withOpacity(0.05)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: isEquipped
                            ? widget.themeColor
                            : (isCompatible ? Colors.white12 : Colors.red.withOpacity(0.3)),
                        width: isEquipped ? 2 : 1),
                  ),
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    leading: Icon(isCompatible ? icon : Icons.block,
                        color: isEquipped ? widget.themeColor : (isCompatible ? Colors.white70 : Colors.red)),
                    title: Text(name, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 11)),
                    subtitle: isEquipped
                        ? Text("INSTALLED",
                            style: TextStyle(color: widget.themeColor, fontSize: 9, fontWeight: FontWeight.bold))
                        : Text(isCompatible ? specs : "⚠️ Incompatible",
                            style: TextStyle(color: isCompatible ? Colors.white54 : Colors.redAccent, fontSize: 9)),
                    
                    // ✅ UPDATED ONTAP WITH LOW LATENCY SOUND
                    onTap: () {
                      HapticFeedback.selectionClick();

                      // --- ERROR DIALOG HANDLING ---
                      if (!isCompatible) {
                        String error = "";
                        
                        if (widget.slotType == "CPU") {
                          error = HeuristicEngine.getErrorMessage(cpu: item, mobo: widget.currentMobo, cooler: widget.currentCooler);
                        } else if (widget.slotType == "MOTHER\nBOARD") {
                          error = HeuristicEngine.getErrorMessage(
                              cpu: widget.currentCpu, mobo: item, ram: widget.currentRam, storage: widget.currentStorage, cooler: widget.currentCooler);
                        } else if (widget.slotType == "RAM") {
                          error = HeuristicEngine.getErrorMessage(ram: item, mobo: widget.currentMobo);
                        } else if (widget.slotType == "STORAGE") {
                          error = HeuristicEngine.getErrorMessage(storage: item, mobo: widget.currentMobo);
                        } else if (widget.slotType == "COOLER") {
                          error = HeuristicEngine.getErrorMessage(
                            cooler: item, 
                            mobo: widget.currentMobo, 
                            cpu: widget.currentCpu
                          );
                        }
                        
                        SciFiDialog.show(context, "INCOMPATIBLE COMPONENT", error);
                        return;
                      }

                      // ✅ INSTANT SOUND TRIGGER
                      if (!isEquipped) {
                        _playThwipSound();
                      }

                      widget.onEquip(isEquipped ? null : item);
                    },
                    onLongPress: () {
                      HapticFeedback.heavyImpact();
                      widget.onPreview(item);
                    },
                  ),
                ),
              ),

              // 2. THE SPIDERWEB CORNER (SOLID WHITE FOR CONTRAST)
              if (isEquipped)
                Positioned(
                  top: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Image.asset(
                      'assets/spiderwebcorner.png',
                      width: 80,  
                      height: 58,
                      color: Colors.white, // ✅ SOLID WHITE (Maximum Contrast)
                      fit: BoxFit.fill, 
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}