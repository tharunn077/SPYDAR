import '../models/component_model.dart';

class ComponentsDB {
  // This static list acts as our "Database"
 static final List<Cpu> cpus = [
  // 1. Budget King
 // 1. Budget King (AM4)
Cpu(
    id: 'cpu_001',
    name: 'Ryzen 5 5600X',
    brand: 'AMD',
    price: 15499,
    socket: 'AM4',
    coreCount: 6,
    threads: 12,
    baseClock: 3.7,
    tdp: 65,
    integratedGraphics: 'None',
    hasIntegratedGraphics: false,
    singleCoreScore: 2100, // Geekbench 6 Single
    multiCoreScore: 8202,  // Geekbench 6 Multi
    isX3D: false,
  ),

  // 2. Mid-Range Value
  Cpu(
    id: 'cpu_002',
    name: 'Core i5-13400F',
    brand: 'Intel',
    price: 19999,
    socket: 'LGA1700',
    coreCount: 10,
    threads: 16, 
    baseClock: 2.5,
    tdp: 65,
    integratedGraphics: 'None',
    hasIntegratedGraphics: false,
    singleCoreScore: 2294, 
    multiCoreScore: 10400, 
    isX3D: false,
  ),

  // 3. The Previous Gen Gaming King
  Cpu(
    id: 'cpu_003',
    name: 'Ryzen 7 7800X3D',
    brand: 'AMD',
    price: 36999,
    socket: 'AM5',
    coreCount: 8,
    threads: 16,
    baseClock: 4.2,
    tdp: 120,
    integratedGraphics: 'AMD Radeon Graphics (2 Core)',
    hasIntegratedGraphics: true,
    singleCoreScore: 2723, 
    multiCoreScore: 15000, 
    isX3D: true, // Gets 1.15x Gaming Boost
  ),

  // 4. The High-End Standard
  Cpu(
    id: 'cpu_004',
    name: 'Core i9-14900K',
    brand: 'Intel',
    price: 54999,
    socket: 'LGA1700',
    coreCount: 24,
    threads: 32,
    baseClock: 3.2,
    tdp: 125,
    integratedGraphics: 'Intel UHD Graphics 770',
    hasIntegratedGraphics: true,
    singleCoreScore: 3053, 
    multiCoreScore: 21500, 
    isX3D: false,
  ),

  // 5. The NEW Gaming King (2025)
  Cpu(
    id: 'cpu_005',
    name: 'Ryzen 7 9800X3D',
    brand: 'AMD',
    price: 44999,
    socket: 'AM5',
    coreCount: 8,
    threads: 16,
    baseClock: 4.7,
    tdp: 120,
    integratedGraphics: 'AMD Radeon Graphics',
    hasIntegratedGraphics: true,
    singleCoreScore: 3336, 
    multiCoreScore: 18400, 
    isX3D: true, // Gets 1.15x Gaming Boost
  ),

  // 6. The Intel Flagship (Arrow Lake)
  Cpu(
    id: 'cpu_006',
    name: 'Core Ultra 9 285K',
    brand: 'Intel',
    price: 58999,
    socket: 'LGA1851', 
    coreCount: 24, 
    threads: 24,       
    baseClock: 3.7,
    tdp: 125,
    integratedGraphics: 'Intel Graphics',
    hasIntegratedGraphics: true,
    singleCoreScore: 3205, 
    multiCoreScore: 22600, // Massive Workstation Score
    isX3D: false, 
  ),

  // 7. The Ultimate "God Chip"
  Cpu(
    id: 'cpu_007',
    name: 'Ryzen 9 9950X3D',
    brand: 'AMD',
    price: 69999,
    socket: 'AM5',
    coreCount: 16,
    threads: 32,
    baseClock: 4.3,
    tdp: 170,
    integratedGraphics: 'AMD Radeon Graphics',
    hasIntegratedGraphics: true,
    singleCoreScore: 3395, 
    multiCoreScore: 22550, 
    isX3D: true, // 100/100 Gaming Score
  ),
 ];

static List<Motherboard> motherboards = [
    // AM4 (Ryzen 3000/5000)
    Motherboard(
      name: "Gigabyte B550 Gaming X", 
      brand: "Gigabyte", price: 12500, socket: "AM4", formFactor: "ATX", 
      memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, 
      hasWifi: false, pcieGen: 4,
      wifiVersion: null, // ❌ No Wifi
    ),
    
    // LGA1700 (Intel 12/13/14th Gen) - DDR4 Version
    Motherboard(
      name: "MSI Pro B760M-P DDR4", 
      brand: "MSI", price: 11000, socket: "LGA1700", formFactor: "mATX", 
      memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, 
      hasWifi: false, pcieGen: 3,
      wifiVersion: null, // ❌ No Wifi
    ),

    // LGA1700 (Intel 12/13/14th Gen) - DDR5 Version
    Motherboard(
      name: "ASUS ROG Strix B760-F", 
      brand: "ASUS", price: 26000, socket: "LGA1700", formFactor: "ATX", 
      memoryType: "DDR5", maxRam: 192, m2Slots: 3, memorySlots: 4, 
      hasWifi: true, pcieGen: 5,
      wifiVersion: "Wi-Fi 6E", // ✅ High Speed
    ),

    // AM5 (Ryzen 7000/8000)
    Motherboard(
      name: "MSI MPG X670E Carbon", 
      brand: "MSI", price: 45000, socket: "AM5", formFactor: "ATX", 
      memoryType: "DDR5", maxRam: 192, m2Slots: 4, memorySlots: 4, 
      hasWifi: true, pcieGen: 5,
      wifiVersion: "Wi-Fi 7", // ✅ Cutting Edge
    ),

    Motherboard(
      name: "MSI H510M-A PRO (No M.2)", 
      brand: "MSI", price: 5500, socket: "LGA1200", formFactor: "mATX", 
      memoryType: "DDR4", maxRam: 64, m2Slots: 0, memorySlots: 2,
      hasWifi: false, pcieGen: 3,
      wifiVersion: null,
    ),
];

static List<Ram> ramSticks = [
    
    Ram(
      name: "G.Skill Trident Z Neo 32GB (4x8)", 
      brand: "G.Skill", 
      price: 18500, 
      type: "DDR4", 
      capacity: 32, 
      speed: 3600, 
      modules: 4, // ✅ Occupies 4 slots
      color: "RGB"
    ),
    
    // ==========================================
    // 🧪 TESTING UNITS (For Bottleneck Logic)
    // ==========================================

    // 🔴 TEST UNIT: 4GB (Critical Bottleneck)
    // Use this to test the "Red" Tier and OS Penalty
    Ram(
      name: "Adata Premier 4GB (Office)", 
      brand: "Adata", 
      price: 1200, 
      type: "DDR4", 
      capacity: 4,     // <--- Triggers Score 40 (Red)
      speed: 2400, 
      modules: 1, 
      color: "Green"
    ),

    // 🟠 TEST UNIT: 8GB Single Stick (Entry Level)
    // Use this to test the "Orange" Tier
    Ram(
      name: "HyperX Fury 8GB (1x8)", 
      brand: "HyperX", 
      price: 2500, 
      type: "DDR4", 
      capacity: 8,     // <--- Triggers Score 70 (Orange)
      speed: 3200, 
      modules: 1, 
      color: "Black"
    ),

    // 🟡 TEST UNIT: 12GB Mixed Kit (Intermediate)
    // Use this to test the "Yellow" Tier
    // (Simulates a user adding a 4GB stick to an 8GB stick)
    Ram(
      name: "Custom Mixed Kit 12GB (8+4)", 
      brand: "Generic", 
      price: 3500, 
      type: "DDR4", 
      capacity: 12,    // <--- Triggers Score 85 (Yellow)
      speed: 2666, 
      modules: 2, 
      color: "Mixed"
    ),

    // 🟠 TEST UNIT: 8GB DDR5 (Entry Next-Gen)
    // Use this to test DDR5 compatibility with low capacity
    Ram(
      name: "Crucial DDR5 Starter 8GB", 
      brand: "Crucial", 
      price: 3800, 
      type: "DDR5", 
      capacity: 8,     // <--- Triggers Score 70 (Orange)
      speed: 4800, 
      modules: 1, 
      color: "Black"
    ),

    // HIGH END (DDR5)
    Ram(
      name: "Corsair Dominator 64GB (2x32)", 
      brand: "Corsair", 
      price: 42000, 
      type: "DDR5", 
      capacity: 64, 
      speed: 6000, 
      modules: 2, // ✅ High capacity, but only uses 2 slots
      color: "Black"
    ),
    
    // ULTRA END (DDR5 Workstation)
    Ram(
      name: "Kingston Fury 128GB (4x32)", 
      brand: "Kingston", 
      price: 95000, 
      type: "DDR5", 
      capacity: 128, 
      speed: 5600, 
      modules: 4, // ✅ Maxes out most boards
      color: "White"
    ),
    // 1. DDR4 Standard
    Ram(
      name: "Corsair Vengeance LPX",
      brand: "Corsair",
      price: 4500,
      type: "DDR4",  // ✅ Fits B550 (AM4)
      capacity: 16,
      speed: 3200,
      modules: 2,
      color: "Black"
    ),
    
    // 2. DDR4 RGB High Speed
    Ram(
      name: "G.Skill Trident Z Neo",
      brand: "G.Skill",
      price: 8200,
      type: "DDR4", // ✅ Fits B550 (AM4)
      capacity: 32,
      speed: 3600,
      modules: 2,
      color: "RGB"
    ),


    // 3. DDR5 Entry Level
    Ram(
      name: "Crucial Basic DDR5",
      brand: "Crucial",
      price: 7500,
      type: "DDR5", // ❌ Won't fit AM4. Fits LGA1700 (if board is DDR5)
      capacity: 16,
      speed: 4800,
      modules: 1,
      color: "Green"
    ),

    // 4. DDR5 High End
    Ram(
      name: "Corsair Dominator Platinum",
      brand: "Corsair",
      price: 18000,
      type: "DDR5", // ❌ Won't fit AM4
      capacity: 32,
      speed: 6000,
      modules: 2,
      color: "RGB"
    ),
  ];
static List<Gpu> gpus = [
    // --- LOW TIER ---
    Gpu(
      id: 'gpu_3050',
      name: "NVIDIA RTX 3050", 
      brand: "NVIDIA", 
      price: 22000, 
      vram: 8, clock: 1780, tdp: 130, cores: 2560, 
      memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", 
      timeSpyScore: 6200, 
      upscaling: "DLSS 2.0", // ✅ Basic AI Upscaling
    ),
    Gpu(
      id: 'gpu_6600',
      name: "AMD Radeon RX 6600", 
      brand: "AMD", 
      price: 21000, 
      vram: 8, clock: 2490, tdp: 132, cores: 1792, 
      memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", 
      timeSpyScore: 8100, 
      upscaling: "FSR 2.1", // ✅ Software Upscaling
    ),

    // --- MID TIER ---
    Gpu(
      id: 'gpu_4060ti',
      name: "NVIDIA RTX 4060 Ti", 
      brand: "NVIDIA", 
      price: 38000, 
      vram: 8, clock: 2535, tdp: 160, cores: 4352, 
      memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", 
      timeSpyScore: 13500, 
      upscaling: "DLSS 3.0", // ✅ Frame Generation Support
    ),
    Gpu(
      id: 'gpu_7700xt',
      name: "AMD Radeon RX 7700 XT", 
      brand: "AMD", 
      price: 42000, 
      vram: 12, clock: 2544, tdp: 245, cores: 3456, 
      memoryType: "GDDR6", busWidth: 192, pcieGen: "4.0", 
      timeSpyScore: 17000, 
      upscaling: "FSR 3.0", // ✅ Fluid Motion Frames
    ),

    // --- HIGH TIER ---
    Gpu(
      id: 'gpu_4080s',
      name: "NVIDIA RTX 4080 Super", 
      brand: "NVIDIA", 
      price: 95000, 
      vram: 16, clock: 2550, tdp: 320, cores: 10240, 
      memoryType: "GDDR6X", busWidth: 256, pcieGen: "4.0", 
      timeSpyScore: 28300, 
      upscaling: "DLSS 3.5", // ✅ Ray Reconstruction
    ),
    Gpu(
      id: 'gpu_4090',
      name: "NVIDIA RTX 4090", 
      brand: "NVIDIA", 
      price: 175000, 
      vram: 24, clock: 2520, tdp: 450, cores: 16384, 
      memoryType: "GDDR6X", busWidth: 384, pcieGen: "4.0", 
      timeSpyScore: 36300, 
      upscaling: "DLSS 3.5", 
    ),

    // --- THE FUTURE GOD ---
    Gpu(
      id: 'gpu_5090',
      name: "NVIDIA RTX 5090", 
      brand: "NVIDIA", 
      price: 230000, 
      vram: 32, clock: 2900, tdp: 600, cores: 21760, 
      memoryType: "GDDR7", busWidth: 512, pcieGen: "5.0", 
      timeSpyScore: 58000, 
      upscaling: "DLSS 4.0", // ✅ Hypothetical Future Tech
    ),
];


static List<Storage> storageItems = [
    // --- MECHANICAL HARD DRIVES (HDD) ---
    Storage(
      name: "Western Digital Blue 2TB", brand: "WD", type: "HDD", format: "SATA",
      capacity: 2000, price: 4200, readSpeed: 150, writeSpeed: 140, pcieGen: 0
    ),
    Storage(
      name: "Seagate BarraCuda 4TB", brand: "Seagate", type: "HDD", format: "SATA",
      capacity: 4000, price: 8500, readSpeed: 190, writeSpeed: 185, pcieGen: 0
    ),

    // --- SATA SSDs (The "Bricks") ---
    Storage(
      name: "Samsung 870 EVO 500GB", brand: "Samsung", type: "SSD", format: "SATA",
      capacity: 500, price: 4800, readSpeed: 560, writeSpeed: 530, pcieGen: 0
    ),
    Storage(
      name: "Crucial MX500 1TB", brand: "Crucial", type: "SSD", format: "SATA",
      capacity: 1000, price: 6200, readSpeed: 540, writeSpeed: 510, pcieGen: 0
    ),

    // --- NVMe SSDs (The "Sticks") ---
    
    // Gen 3 (Mainstream)
    Storage(
      name: "Kingston NV2 1TB", brand: "Kingston", type: "NVMe SSD", format: "M.2",
      capacity: 1000, price: 5500, readSpeed: 3500, writeSpeed: 2100, pcieGen: 3
    ),
    Storage(
      name: "Samsung 970 EVO Plus 2TB", brand: "Samsung", type: "NVMe SSD", format: "M.2",
      capacity: 2000, price: 14500, readSpeed: 3500, writeSpeed: 3300, pcieGen: 3
    ),

    // Gen 4 (High End)
    Storage(
      name: "WD Black SN850X 1TB", brand: "WD", type: "NVMe SSD", format: "M.2",
      capacity: 1000, price: 9200, readSpeed: 7300, writeSpeed: 6300, pcieGen: 4
    ),
    Storage(
      name: "Samsung 990 Pro 2TB", brand: "Samsung", type: "NVMe SSD", format: "M.2",
      capacity: 2000, price: 18000, readSpeed: 7450, writeSpeed: 6900, pcieGen: 4
    ),

    // Gen 5 (Extreme - Needs Gen 5 Motherboard!)
    Storage(
      name: "Crucial T705 1TB", brand: "Crucial", type: "NVMe SSD", format: "M.2",
      capacity: 1000, price: 22000, readSpeed: 13600, writeSpeed: 10200, pcieGen:5
    ),
    Storage(
      name: "Gigabyte AORUS Gen5 2TB", brand: "Gigabyte", type: "NVMe SSD", format: "M.2",
      capacity: 2000, price: 32000, readSpeed: 12400, writeSpeed: 11800, pcieGen: 5
    ),
  ];

static List<Psu> psus = [
  Psu(name: "Corsair CV450", brand: "Corsair", price: 3200, wattage: 450, efficiency: "80+ Bronze", isModular: false),
  Psu(name: "EVGA 600 W1", brand: "EVGA", price: 4500, wattage: 600, efficiency: "80+ White", isModular: false),
  // ... your existing list or these new ones
  Psu(name: "Cooler Master V750", brand: "Cooler Master", price: 8500, wattage: 750, efficiency: "80+ Gold", isModular: true),
  Psu(name: "Corsair RM850x", brand: "Corsair", price: 11000, wattage: 850, efficiency: "80+ Gold", isModular: true),
  Psu(name: "ROG Thor 1200P", brand: "ASUS", price: 25000, wattage: 1200, efficiency: "80+ Platinum", isModular: true),
];
static List<Cooler> coolers = [
  Cooler(
    name: "Intel Stock Cooler",
    brand: "Intel",
    price: 0,
    type: "Air",
    fanSize: 90, 
    fanCount: 1,
    hasRGB: false,
    supportedSockets: ["LGA1700", "LGA1200"], 
    // Logic: 90 * 1 * 0.7 = ~63W
  ),
  Cooler(
    name: "Hyper 212 Halo",
    brand: "Cooler Master",
    price: 3500,
    type: "Air",
    fanSize: 120, 
    fanCount: 1,
    hasRGB: true,
    supportedSockets: ["LGA1700", "LGA1200", "AM5", "AM4"], 
    // Logic: 120 * 1 * 1.15 = ~138W
  ),
  Cooler(
    name: "DeepCool AK620",
    brand: "DeepCool",
    price: 6500,
    type: "Air (Dual Tower)",
    fanSize: 120, 
    fanCount: 2, 
    hasRGB: false,
    supportedSockets: ["LGA1700", "LGA1200", "AM5", "AM4"],
    // Logic: 240 * 1.15 = ~276W
  ),
  Cooler(
    name: "NZXT Kraken 240",
    brand: "NZXT",
    price: 12000,
    type: "Liquid AIO", 
    fanSize: 120,
    fanCount: 2, 
    hasRGB: true,
    supportedSockets: ["LGA1700", "AM5"],
    // Logic: 240 * 1.25 = ~300W
  ),
  Cooler(
    name: "Corsair H115i Elite", // The one you showed me
    brand: "Corsair",
    price: 14500,
    type: "Liquid AIO",
    fanSize: 140, // Big Fans!
    fanCount: 2, 
    hasRGB: true,
    supportedSockets: ["LGA1700", "AM5", "sTR5", "AM4", "LGA1200"],
    // Logic: 280 * 1.25 = ~350W
  ),
];

}