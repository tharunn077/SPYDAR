import '../models/component_model.dart';

class HeuristicEngine {
  // Inside HeuristicEngine class

  static Map<String, dynamic> calculateFullBottleneck({
    required Cpu? cpu,
    required Gpu? gpu,
    required Motherboard? mobo,
    required Cooler? cooler,
    required Storage? storage,
    required Ram? ram, 
  }) {
    
    // =========================================================
    // STEP 1: INDEPENDENT CHECKS (Storage & RAM)
    // =========================================================
    
    // --- A) STORAGE CHECK ---
    int storageTileScore = 100;
    double storagePenalty = 0.0;
    bool hasStorageIssue = false;

    if (storage != null && mobo != null) {
      int gap = storage.pcieGen - mobo.pcieGen;
      if (gap >= 2) {
        hasStorageIssue = true;
        storageTileScore = 50;
        storagePenalty = 20.0;
      } else if (gap == 1) {
        hasStorageIssue = true;
        storageTileScore = 75;
        storagePenalty = 10.0;
      }
    }

    // --- B) RAM CHECK ---
    int ramTileScore = 100;    
    double ramPenalty = 0.0;   
    bool hasRamIssue = false;

    if (ram != null) {
      if (ram.capacity < 8) {
        hasRamIssue = true;
        ramTileScore = 40;
        ramPenalty = 25.0; 
      } 
      else if (ram.capacity == 8) {
        hasRamIssue = true;
        ramTileScore = 70;
        ramPenalty = 10.0;
      }
      else if (ram.capacity > 8 && ram.capacity < 16) {
        hasRamIssue = true;
        ramTileScore = 85; 
        ramPenalty = 5.0; 
      }
    }

    // =========================================================
    // STEP 2: CHECK FOR MISSING COMPONENTS
    // =========================================================
    
    // MISSING CPU
    if (cpu == null) {
      return {
        "percentage": (storagePenalty + ramPenalty).clamp(0.0, 100.0),
        "type": "Incomplete",
        "recommendation": "Select a Processor.",
        "thermalPenalty": false,
        "storagePenalty": hasStorageIssue,
        "storageTileScore": storageTileScore,
        
        "ramPenalty": hasRamIssue, 
        "ramTileScore": ramTileScore,
        
        "cpuScore": 0, 
        
        "gpuScore": gpu != null ? gpu.performanceScore : 0, 
      };
    }

    // THERMAL CHECK
    double thermalMultiplier = 1.0;
    bool hasThermalIssue = false;
    if (cooler != null) {
      if (cooler.computedTdp < cpu.tdp) {
        thermalMultiplier = (cooler.computedTdp / cpu.tdp).clamp(0.5, 1.0);
        hasThermalIssue = true;
      }
    } else {
      thermalMultiplier = 0.5; hasThermalIssue = true;
    }

    // MISSING GPU
    if (gpu == null) {
      double incompletePenalty = storagePenalty + ramPenalty;
      if (hasThermalIssue) incompletePenalty += (1.0 - thermalMultiplier) * 100.0;

      return {
        "percentage": incompletePenalty.clamp(0.0, 100.0), 
        "type": "Incomplete",
        "recommendation": hasThermalIssue ? "⚠️ CPU overheating." : "Select a Graphics Card.",
        "thermalPenalty": hasThermalIssue,
        "storagePenalty": hasStorageIssue,
        "storageTileScore": storageTileScore,
        "ramPenalty": hasRamIssue, 
        "ramTileScore": ramTileScore, 
        "cpuScore": (cpu.gamingScore * thermalMultiplier).round(),
        "gpuScore": 0,
      };
    }

    // =========================================================
    // STEP 3: FULL BUILD ANALYSIS
    // =========================================================
    double effectiveCpuPower = cpu.gamingScore * thermalMultiplier;
    double effectiveGpuPower = gpu.performanceScore.toDouble();

    double diff = (effectiveCpuPower - effectiveGpuPower).abs();
    double percentage = 0.0;
    String type = "Balanced";
    String recommendation = "System is perfectly balanced.";

    // 1. Base Calculation
    if (diff > 10) percentage = (diff - 10) / 2.0;
    else if (diff > 0) percentage = diff / 2.0; 

    // 2. Add Penalties
    if (hasThermalIssue) percentage += (1.0 - thermalMultiplier) * 100.0;
    percentage += storagePenalty;
    percentage += ramPenalty; 

    percentage = percentage.clamp(0.0, 100.0);

    // 3. Diagnosis Priorities
    if (percentage > 5) {
      if (hasRamIssue && ramTileScore < 50) {
        type = "RAM Critical";
        recommendation = "System unusable due to insufficient memory.";
      }
      else if (hasStorageIssue && diff < 15 && !hasThermalIssue) {
        type = "Storage Bottleneck";
        recommendation = "Performance limited by Motherboard bandwidth.";
      } 
      else if (effectiveCpuPower < effectiveGpuPower) {
        type = "CPU Bottleneck";
        recommendation = hasThermalIssue ? "CPU thermal throttling." : "Processor is too weak for this GPU.";
      } else {
        type = "GPU Bottleneck";
        recommendation = "Graphics card is limiting performance.";
      }
    }

    return {
      "percentage": percentage,
      "type": type,
      "recommendation": recommendation,
      "thermalPenalty": hasThermalIssue,
      "storagePenalty": hasStorageIssue, 
      "storageTileScore": storageTileScore,
      
      "ramPenalty": hasRamIssue, 
      "ramTileScore": ramTileScore,
      
      "cpuScore": effectiveCpuPower.round(),
      "gpuScore": effectiveGpuPower.round(),
    };
  }
  // ==========================================================
  // 2. COMPATIBILITY CHECKS
  // ==========================================================
  static bool checkCompatibility({
    Cpu? cpu, 
    Motherboard? mobo, 
    Ram? ram, 
    Storage? storage, 
    Cooler? cooler 
  }) {
    if (cpu != null && mobo != null && cpu.socket.toUpperCase() != mobo.socket.toUpperCase()) return false;

    if (ram != null && mobo != null) {
      if (ram.type.toUpperCase() != mobo.memoryType.toUpperCase()) return false;
      if (ram.capacity > mobo.maxRam) return false;
      if (ram.modules > mobo.memorySlots) return false;
    }

    if (storage != null && mobo != null) {
      if (storage.format == "M.2" && mobo.m2Slots == 0) return false;
    }
    
    if (cooler != null && mobo != null) {
      if (!cooler.supportedSockets.any((s) => s.toUpperCase() == mobo.socket.toUpperCase())) return false;
    }

    if (cooler != null && cpu != null) {
      if (!cooler.supportedSockets.any((s) => s.toUpperCase() == cpu.socket.toUpperCase())) return false;
    }

    return true;
  }

  // ==========================================================
  // 3. ERROR MESSAGE GENERATOR
  // ==========================================================
  static String getErrorMessage({
    Cpu? cpu, 
    Motherboard? mobo, 
    Ram? ram, 
    Storage? storage, 
    Cooler? cooler 
  }) {
    if (cpu != null && mobo != null && cpu.socket.toUpperCase() != mobo.socket.toUpperCase()) {
      return "• CPU Socket:   [ ${cpu.socket} ]\n"
             "• Board Socket: [ ${mobo.socket} ]\n\n"
             "Physical installation is impossible.";
    }

    if (ram != null && mobo != null) {
      if (ram.type.toUpperCase() != mobo.memoryType.toUpperCase()) {
        return "• Motherboard: [ ${mobo.memoryType} ]\n"
               "• Selected RAM: [ ${ram.type} ]\n\n"
               "DDR4 and DDR5 slots are physically different.";
      }
      if (ram.capacity > mobo.maxRam) return "• Exceeds Motherboard RAM capacity.";
      if (ram.modules > mobo.memorySlots) return "• Not enough physical RAM slots.";
    }

    if (storage != null && mobo != null) {
      if (storage.format == "M.2" && mobo.m2Slots == 0) {
        return "• Motherboard M.2 Slots: [ 0 ]\n"
               "• M.2 Storage Detected: [ ${storage.name} ]\n\n"
               "This board does not have an M.2 slot.";
      }
    }

    if (cooler != null && mobo != null) {
      if (!cooler.supportedSockets.any((s) => s.toUpperCase() == mobo.socket.toUpperCase())) {
        return "• Motherboard Socket: [ ${mobo.socket} ]\n"
               "• Cooler Supports: [ ${cooler.supportedSockets.join(', ')} ]\n\n"
               "The mounting bracket does not fit this motherboard.";
      }
    }

    if (cooler != null && cpu != null) {
      if (!cooler.supportedSockets.any((s) => s.toUpperCase() == cpu.socket.toUpperCase())) {
         return "• CPU Socket: [ ${cpu.socket} ]\n"
                "• Cooler Supports: [ ${cooler.supportedSockets.join(', ')} ]\n\n"
                "Your installed cooler does not have a mounting bracket for this CPU socket.";
      }
    }

    return "Compatibility Error: Check component specifications.";
  }

  // ==========================================================
  // 4. HELPER: COOLER SPECIFIC CHECK
  // ==========================================================
  static bool checkCoolerCompatibility({required Cooler? cooler, required Motherboard? mobo, required Cpu? cpu}) {
    if (mobo != null && cooler != null) {
       if (!cooler.supportedSockets.any((s) => s.toUpperCase() == mobo.socket.toUpperCase())) return false;
    }
    
    if (cooler != null && cpu != null) {
      if (!cooler.supportedSockets.any((s) => s.toUpperCase() == cpu.socket.toUpperCase())) return false;
    }
    
    return true;
  }

  // ==========================================================
  // 5. WATTAGE CALCULATOR
  // ==========================================================
  static int calculateTotalWattage({
    required Cpu? cpu,
    required Motherboard? mobo,
    required Ram? ram,
    required Storage? storage,
    required Gpu? gpu,
    required Cooler? cooler,
  }) {
    double totalWatts = 0.0;

    if (cpu != null) totalWatts += cpu.tdp;
    if (gpu != null) totalWatts += gpu.tdp;
    if (mobo != null) totalWatts += 70; 
    if (ram != null) totalWatts += (ram.modules * 5);
    if (storage != null) totalWatts += 10;
    if (cooler != null) {
      totalWatts += (cooler.fanCount * 5);
      if (cooler.type.toLowerCase().contains("liquid")) {
        totalWatts += 10; 
      }
    }

    return totalWatts.round();
  }
}