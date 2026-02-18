import '../../../logic/heuristic_engine.dart';
import '../models/component_model.dart';

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
  // This takes raw inputs and returns the Final Verdict
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
    // If any core component is missing, stop immediately.
    if (cpu == null || mobo == null || ram == null || storage == null || psu == null) {
      return BootResult(
        status: BootStatus.incomplete,
        title: "Build Incomplete",
        message: "You must install CPU, Motherboard, RAM, Storage, and PSU before booting.",
      );
    }

    // 2. CALCULATE BOTTLENECK (Using Heuristic Engine)
    // We do this here so SimulatorScreen doesn't have to know about it
    final report = HeuristicEngine.calculateFullBottleneck(
      cpu: cpu,
      gpu: gpu,
      mobo: mobo,
      cooler: cooler,
      storage: storage,
      ram: ram,
    );
    final double calculatedBottleneck = report["percentage"];

    // 3. RUN HEALTH CHECK
    // Now pass the non-nullable values to the specific checks
    return _checkSystemHealth(
      cpu: cpu,
      gpu: gpu,
      psu: psu,
      bottleneckPercentage: calculatedBottleneck,
      // We calculate watts internally now
      totalWatts: HeuristicEngine.calculateTotalWattage(
        cpu: cpu, mobo: mobo, ram: ram, storage: storage, gpu: gpu, cooler: cooler
      ),
    );
  }

  // Internal helper (Private) - Does the specific crash logic
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
}
