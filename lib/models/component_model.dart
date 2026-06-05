import 'dart:math'; // Required for pow()

class Cpu {
  final String id;
  final String name;
  final String brand; // 'Intel' or 'AMD'
  final double price;
  final String socket; // e.g., 'AM4', 'LGA1700'
  final int coreCount;
  final int threads;
  final double baseClock;
  final String integratedGraphics; // e.g., "Intel UHD 770"
  final bool hasIntegratedGraphics;
  final int singleCoreScore; // The real number from cpubenchmark.net
  final int multiCoreScore;
  final bool isX3D;        // Set to true if it has 3D V-Cache
  final int tdp; // Power consumption in Watts
  final String? imagePath; // Nullable: if null, we show an Icon instead

  Cpu({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.socket,
    required this.coreCount,
    required this.threads,
    required this.baseClock,
    required this.hasIntegratedGraphics,
    required this.integratedGraphics,
    required this.singleCoreScore,
    required this.multiCoreScore,
    required this.isX3D,
    required this.tdp,
    this.imagePath,
  });

 int get workstationScore {
    // Ceiling: 24,000 (Based on Ryzen 9 9950X3D / Ultra 9 limits)
    const int maxReferenceScore = 24000; 
    
    double calculatedScore = (multiCoreScore / maxReferenceScore) * 100;
    
    if (calculatedScore > 100) return 100;
    return calculatedScore.round();
  }

  // --- 2. GAMING SCORE (Red Bar) ---
  // Uses Single-Core Speed + X3D Engineering Multiplier.
  int get gamingScore {
    // Ceiling: 4000 (Based on 9950X3D Boosted Score ~3900)
    const int maxReferenceScore = 4000; 
    
    double multiplier;
    if (isX3D) {
      // 1.15x Boost adds the "Invisible" performance of 3D V-Cache
      // that Geekbench fails to measure.
      multiplier = 1.15; 
    } else {
      // Standard chips rely on raw Single-Core IPC & Frequency.
      multiplier = 1.0; 
    }

    double effectiveScore = singleCoreScore * multiplier;
    
    double calculatedScore = (effectiveScore / maxReferenceScore) * 100;

    if (calculatedScore > 100) return 100;
    return calculatedScore.round();
  }
}


class Motherboard {
  final String name;
  final String brand;
  final double price;
  final String socket;
  final String formFactor;
  final String memoryType; // "DDR4" or "DDR5"
  final int maxRam;
  final int memorySlots;
  final int m2Slots;
  final bool hasWifi;
  // ✅ NEW FIELD
  final int pcieGen; // e.g. 3, 4, 5
   final String? wifiVersion;

  Motherboard({
    required this.name,
    required this.brand,
    required this.price,
    required this.socket,
    required this.formFactor,
    required this.memoryType,
    required this.maxRam,
    required this.memorySlots,
    required this.m2Slots,
    required this.hasWifi,
    required this.pcieGen,
    this.wifiVersion
  });
}
class Ram {
  final String name;
  final String brand;
  final double price;
  final String type; // "DDR4" or "DDR5" <--- CRITICAL
  final int capacity; // e.g. 16 (GB)
  final int speed; // e.g. 3200 (MHz)
  final int modules; // e.g. 2 (for 2x8GB kit)
  final String color; // "Black", "RGB", "White"

  Ram({
    required this.name,
    required this.brand,
    required this.price,
    required this.type,
    required this.capacity,
    required this.speed,
    required this.modules,
    required this.color,
  });
  
  // Helper to display nicely (e.g. "16GB DDR4-3200")
  String get specs => "${capacity}GB $type-$speed";
}

class Gpu {
  final String id; // Added for unique identification
  final String name;
  final String brand;
  final int price; // Changed to int to match your data (e.g., 22000)
  final int vram;
  final int clock;
  final int tdp;
  final int cores;
  final String memoryType;
  final int busWidth;
  final String pcieGen;
  final String upscaling;
  
  // ✅ THE NEW CRITICAL FIELD
  final int timeSpyScore; 

  const Gpu({
    required this.id, // Don't forget to update data list with ids like 'gpu_001'
    required this.name,
    required this.brand,
    required this.price,
    required this.vram,
    required this.clock,
    required this.tdp,
    required this.cores,
    required this.memoryType,
    required this.busWidth,
    required this.pcieGen,
    required this.timeSpyScore,
    required this.upscaling
  });

  int get performanceScore {
    // 1. Set Ceiling to Current Gen (RTX 4090 is ~36,500)
    const double maxReferenceScore = 40000; 
    
    // 2. Get Raw Ratio (0.0 to 1.0)
    double rawRatio = (timeSpyScore / maxReferenceScore).clamp(0.0, 1.0);

    // 3. Apply "Gaming Curve" (Power of 0.6)
    // This boosts the low end without breaking the high end.
    // Math: 0.15 becomes 0.32 | 0.90 becomes 0.94
    double curvedScore = pow(rawRatio, 0.6).toDouble();

    return (curvedScore * 100).round();
  }
}

class Storage {
  final String name;
  final String brand;
  final String type;      // "SSD", "NVMe SSD", or "HDD"
  final String format;    // "M.2" or "SATA"
  final int capacity;     
  final double price;
  final int readSpeed;    // MB/s
  final int writeSpeed;   // ✅ NEW: MB/s
  final int pcieGen;      // 0 for SATA, 3, 4, or 5 for NVMe

  Storage({
    required this.name,
    required this.brand,
    required this.type,
    required this.format,
    required this.capacity,
    required this.price,
    required this.readSpeed,
    required this.writeSpeed,
    required this.pcieGen,
  });
}

class Psu {
  final String name;
  final String brand;
  final double price;
  final int wattage;      // e.g., 650, 750, 850
  final String efficiency; // e.g., "80+ Gold", "80+ Bronze"
  final bool isModular;    // Fully, Semi, or Non-Modular

  Psu({
    required this.name,
    required this.brand,
    required this.price,
    required this.wattage,
    required this.efficiency,
    required this.isModular, 
  });
}

class Cooler {
  final String name;
  final String brand;
  final double price;
  final String type; // "Air" or "Liquid AIO"
  final int fanSize; // 120, 140, 90
  final int fanCount; // 1, 2, or 3
  final bool hasRGB;
  final List<String> supportedSockets; // ["LGA1700", "AM5"]

  Cooler({
    required this.name,
    required this.brand,
    required this.price,
    required this.type,
    required this.fanSize,
    required this.fanCount,
    required this.hasRGB,
    required this.supportedSockets,
  });

  // ✅ THE "SMART FORMULA"
  // Calculates Max TDP based on physical surface area & efficiency
  int get computedTdp {
    // 1. Raw Surface Area (The "Bucket Size")
    int baseScore = fanSize * fanCount;

    // 2. Efficiency Multiplier (The "Material Speed")
    double multiplier = 1.0;

    if (type.contains("Liquid")) {
      multiplier = 1.25; // Water moves heat 25% better
    } else if (fanSize < 100) {
      multiplier = 0.7; // Small stock coolers are weak
    } else {
      multiplier = 1.15; // Copper heat pipes are efficient
    }

    // 3. Return Watts
    return (baseScore * multiplier).round();
  }



}

