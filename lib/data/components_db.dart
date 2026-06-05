import '../models/component_model.dart';

class ComponentsDB {
  static final List<Cpu> cpus = [
    // ==========================================
    // INTEL - LEGACY / BOTTLENECK TRIGGERS (LGA 1151)
    // ==========================================
    Cpu(id: 'cpu_001', name: 'Core i3-6100', brand: 'Intel', price: 2500, socket: 'LGA1151', coreCount: 2, threads: 4, baseClock: 3.7, tdp: 51, integratedGraphics: 'HD 530', hasIntegratedGraphics: true, singleCoreScore: 850, multiCoreScore: 2200, isX3D: false),
    Cpu(id: 'cpu_002', name: 'Core i5-6500', brand: 'Intel', price: 3500, socket: 'LGA1151', coreCount: 4, threads: 4, baseClock: 3.2, tdp: 65, integratedGraphics: 'HD 530', hasIntegratedGraphics: true, singleCoreScore: 900, multiCoreScore: 2800, isX3D: false),
    Cpu(id: 'cpu_003', name: 'Core i7-6700K', brand: 'Intel', price: 7500, socket: 'LGA1151', coreCount: 4, threads: 8, baseClock: 4.0, tdp: 91, integratedGraphics: 'HD 530', hasIntegratedGraphics: true, singleCoreScore: 1050, multiCoreScore: 3600, isX3D: false),
    Cpu(id: 'cpu_004', name: 'Core i3-8100', brand: 'Intel', price: 4000, socket: 'LGA1151', coreCount: 4, threads: 4, baseClock: 3.6, tdp: 65, integratedGraphics: 'UHD 630', hasIntegratedGraphics: true, singleCoreScore: 1000, multiCoreScore: 3000, isX3D: false),
    Cpu(id: 'cpu_005', name: 'Core i5-8400', brand: 'Intel', price: 5500, socket: 'LGA1151', coreCount: 6, threads: 6, baseClock: 2.8, tdp: 65, integratedGraphics: 'UHD 630', hasIntegratedGraphics: true, singleCoreScore: 1050, multiCoreScore: 4200, isX3D: false),
    Cpu(id: 'cpu_006', name: 'Core i7-8700K', brand: 'Intel', price: 9500, socket: 'LGA1151', coreCount: 6, threads: 12, baseClock: 3.7, tdp: 95, integratedGraphics: 'UHD 630', hasIntegratedGraphics: true, singleCoreScore: 1250, multiCoreScore: 5800, isX3D: false),
    Cpu(id: 'cpu_007', name: 'Core i9-9900K', brand: 'Intel', price: 16500, socket: 'LGA1151', coreCount: 8, threads: 16, baseClock: 3.6, tdp: 95, integratedGraphics: 'UHD 630', hasIntegratedGraphics: true, singleCoreScore: 1350, multiCoreScore: 7800, isX3D: false),

    // ==========================================
    // INTEL - OLDER MAINSTREAM (LGA 1200)
    // ==========================================
    Cpu(id: 'cpu_008', name: 'Core i3-10100F', brand: 'Intel', price: 5500, socket: 'LGA1200', coreCount: 4, threads: 8, baseClock: 3.6, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1100, multiCoreScore: 4500, isX3D: false),
    Cpu(id: 'cpu_009', name: 'Core i5-10400F', brand: 'Intel', price: 8500, socket: 'LGA1200', coreCount: 6, threads: 12, baseClock: 2.9, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1150, multiCoreScore: 5600, isX3D: false),
    Cpu(id: 'cpu_010', name: 'Core i7-10700K', brand: 'Intel', price: 18500, socket: 'LGA1200', coreCount: 8, threads: 16, baseClock: 3.8, tdp: 125, integratedGraphics: 'UHD 630', hasIntegratedGraphics: true, singleCoreScore: 1300, multiCoreScore: 7500, isX3D: false),
    Cpu(id: 'cpu_011', name: 'Core i9-10900K', brand: 'Intel', price: 25000, socket: 'LGA1200', coreCount: 10, threads: 20, baseClock: 3.7, tdp: 125, integratedGraphics: 'UHD 630', hasIntegratedGraphics: true, singleCoreScore: 1400, multiCoreScore: 9200, isX3D: false),
    Cpu(id: 'cpu_012', name: 'Core i5-11400F', brand: 'Intel', price: 9800, socket: 'LGA1200', coreCount: 6, threads: 12, baseClock: 2.6, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1450, multiCoreScore: 6800, isX3D: false),
    Cpu(id: 'cpu_013', name: 'Core i7-11700K', brand: 'Intel', price: 21500, socket: 'LGA1200', coreCount: 8, threads: 16, baseClock: 3.6, tdp: 125, integratedGraphics: 'UHD 750', hasIntegratedGraphics: true, singleCoreScore: 1600, multiCoreScore: 8800, isX3D: false),
    Cpu(id: 'cpu_014', name: 'Core i9-11900K', brand: 'Intel', price: 28000, socket: 'LGA1200', coreCount: 8, threads: 16, baseClock: 3.5, tdp: 125, integratedGraphics: 'UHD 750', hasIntegratedGraphics: true, singleCoreScore: 1700, multiCoreScore: 9500, isX3D: false),

    // ==========================================
    // INTEL - MODERN MAINSTREAM & ENTHUSIAST (LGA 1700)
    // ==========================================
    Cpu(id: 'cpu_015', name: 'Celeron G6900', brand: 'Intel', price: 4500, socket: 'LGA1700', coreCount: 2, threads: 2, baseClock: 3.4, tdp: 46, integratedGraphics: 'UHD 710', hasIntegratedGraphics: true, singleCoreScore: 1200, multiCoreScore: 2300, isX3D: false), // Huge bottleneck
    Cpu(id: 'cpu_016', name: 'Pentium Gold G7400', brand: 'Intel', price: 6500, socket: 'LGA1700', coreCount: 2, threads: 4, baseClock: 3.7, tdp: 46, integratedGraphics: 'UHD 710', hasIntegratedGraphics: true, singleCoreScore: 1350, multiCoreScore: 3200, isX3D: false),
    Cpu(id: 'cpu_017', name: 'Core i3-12100F', brand: 'Intel', price: 8200, socket: 'LGA1700', coreCount: 4, threads: 8, baseClock: 3.3, tdp: 58, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1650, multiCoreScore: 6500, isX3D: false),
    Cpu(id: 'cpu_018', name: 'Core i5-12400F', brand: 'Intel', price: 12500, socket: 'LGA1700', coreCount: 6, threads: 12, baseClock: 2.5, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1800, multiCoreScore: 8500, isX3D: false),
    Cpu(id: 'cpu_019', name: 'Core i5-12600K', brand: 'Intel', price: 19500, socket: 'LGA1700', coreCount: 10, threads: 16, baseClock: 3.7, tdp: 125, integratedGraphics: 'UHD 770', hasIntegratedGraphics: true, singleCoreScore: 1950, multiCoreScore: 11500, isX3D: false),
    Cpu(id: 'cpu_020', name: 'Core i7-12700K', brand: 'Intel', price: 28500, socket: 'LGA1700', coreCount: 12, threads: 20, baseClock: 3.6, tdp: 190, integratedGraphics: 'UHD 770', hasIntegratedGraphics: true, singleCoreScore: 2050, multiCoreScore: 14500, isX3D: false),
    Cpu(id: 'cpu_021', name: 'Core i9-12900K', brand: 'Intel', price: 38000, socket: 'LGA1700', coreCount: 16, threads: 24, baseClock: 3.2, tdp: 241, integratedGraphics: 'UHD 770', hasIntegratedGraphics: true, singleCoreScore: 2150, multiCoreScore: 17500, isX3D: false),
    Cpu(id: 'cpu_022', name: 'Core i3-13100F', brand: 'Intel', price: 9500, socket: 'LGA1700', coreCount: 4, threads: 8, baseClock: 3.4, tdp: 58, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1850, multiCoreScore: 7200, isX3D: false),
    Cpu(id: 'cpu_023', name: 'Core i5-13400F', brand: 'Intel', price: 18500, socket: 'LGA1700', coreCount: 10, threads: 16, baseClock: 2.5, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 2294, multiCoreScore: 10400, isX3D: false),
    Cpu(id: 'cpu_024', name: 'Core i5-13600K', brand: 'Intel', price: 26500, socket: 'LGA1700', coreCount: 14, threads: 20, baseClock: 3.5, tdp: 181, integratedGraphics: 'UHD 770', hasIntegratedGraphics: true, singleCoreScore: 2500, multiCoreScore: 15500, isX3D: false),
    Cpu(id: 'cpu_025', name: 'Core i7-13700K', brand: 'Intel', price: 37500, socket: 'LGA1700', coreCount: 16, threads: 24, baseClock: 3.4, tdp: 253, integratedGraphics: 'UHD 770', hasIntegratedGraphics: true, singleCoreScore: 2800, multiCoreScore: 19000, isX3D: false),
    Cpu(id: 'cpu_026', name: 'Core i9-13900K', brand: 'Intel', price: 49000, socket: 'LGA1700', coreCount: 24, threads: 32, baseClock: 3.0, tdp: 253, integratedGraphics: 'UHD 770', hasIntegratedGraphics: true, singleCoreScore: 2950, multiCoreScore: 23500, isX3D: false),
    Cpu(id: 'cpu_027', name: 'Core i5-14400F', brand: 'Intel', price: 19500, socket: 'LGA1700', coreCount: 10, threads: 16, baseClock: 2.5, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 2350, multiCoreScore: 10800, isX3D: false),
    Cpu(id: 'cpu_028', name: 'Core i5-14600K', brand: 'Intel', price: 28500, socket: 'LGA1700', coreCount: 14, threads: 20, baseClock: 3.5, tdp: 181, integratedGraphics: 'UHD 770', hasIntegratedGraphics: true, singleCoreScore: 2600, multiCoreScore: 16000, isX3D: false),
    Cpu(id: 'cpu_029', name: 'Core i7-14700K', brand: 'Intel', price: 39500, socket: 'LGA1700', coreCount: 20, threads: 28, baseClock: 3.4, tdp: 253, integratedGraphics: 'UHD 770', hasIntegratedGraphics: true, singleCoreScore: 2900, multiCoreScore: 20500, isX3D: false),
    Cpu(id: 'cpu_030', name: 'Core i9-14900K', brand: 'Intel', price: 54999, socket: 'LGA1700', coreCount: 24, threads: 32, baseClock: 3.2, tdp: 253, integratedGraphics: 'UHD 770', hasIntegratedGraphics: true, singleCoreScore: 3053, multiCoreScore: 24500, isX3D: false),

    // ==========================================
    // AMD - LEGACY / BOTTLENECK TRIGGERS (AM4)
    // ==========================================
    Cpu(id: 'cpu_031', name: 'Athlon 3000G', brand: 'AMD', price: 4500, socket: 'AM4', coreCount: 2, threads: 4, baseClock: 3.5, tdp: 35, integratedGraphics: 'Vega 3', hasIntegratedGraphics: true, singleCoreScore: 800, multiCoreScore: 2000, isX3D: false),
    Cpu(id: 'cpu_032', name: 'Ryzen 3 1200', brand: 'AMD', price: 3500, socket: 'AM4', coreCount: 4, threads: 4, baseClock: 3.1, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 850, multiCoreScore: 2500, isX3D: false),
    Cpu(id: 'cpu_033', name: 'Ryzen 5 1600', brand: 'AMD', price: 5000, socket: 'AM4', coreCount: 6, threads: 12, baseClock: 3.2, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 950, multiCoreScore: 4200, isX3D: false),
    Cpu(id: 'cpu_034', name: 'Ryzen 7 1800X', brand: 'AMD', price: 8500, socket: 'AM4', coreCount: 8, threads: 16, baseClock: 3.6, tdp: 95, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1050, multiCoreScore: 5800, isX3D: false),
    Cpu(id: 'cpu_035', name: 'Ryzen 3 3100', brand: 'AMD', price: 6500, socket: 'AM4', coreCount: 4, threads: 8, baseClock: 3.6, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1150, multiCoreScore: 4400, isX3D: false),
    Cpu(id: 'cpu_036', name: 'Ryzen 5 3600', brand: 'AMD', price: 8000, socket: 'AM4', coreCount: 6, threads: 12, baseClock: 3.6, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1300, multiCoreScore: 5800, isX3D: false),
    Cpu(id: 'cpu_037', name: 'Ryzen 7 3700X', brand: 'AMD', price: 12500, socket: 'AM4', coreCount: 8, threads: 16, baseClock: 3.6, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1350, multiCoreScore: 7800, isX3D: false),
    Cpu(id: 'cpu_038', name: 'Ryzen 9 3900X', brand: 'AMD', price: 21000, socket: 'AM4', coreCount: 12, threads: 24, baseClock: 3.8, tdp: 105, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1400, multiCoreScore: 10500, isX3D: false),
    Cpu(id: 'cpu_039', name: 'Ryzen 5 5500', brand: 'AMD', price: 9500, socket: 'AM4', coreCount: 6, threads: 12, baseClock: 3.6, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 1800, multiCoreScore: 7200, isX3D: false),
    Cpu(id: 'cpu_040', name: 'Ryzen 5 5600X', brand: 'AMD', price: 15499, socket: 'AM4', coreCount: 6, threads: 12, baseClock: 3.7, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 2100, multiCoreScore: 8200, isX3D: false),
    Cpu(id: 'cpu_041', name: 'Ryzen 7 5700X', brand: 'AMD', price: 18500, socket: 'AM4', coreCount: 8, threads: 16, baseClock: 3.4, tdp: 65, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 2150, multiCoreScore: 10500, isX3D: false),
    Cpu(id: 'cpu_042', name: 'Ryzen 7 5800X3D', brand: 'AMD', price: 28000, socket: 'AM4', coreCount: 8, threads: 16, baseClock: 3.4, tdp: 105, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 2200, multiCoreScore: 11000, isX3D: true),
    Cpu(id: 'cpu_043', name: 'Ryzen 9 5900X', brand: 'AMD', price: 32000, socket: 'AM4', coreCount: 12, threads: 24, baseClock: 3.7, tdp: 105, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 2250, multiCoreScore: 14500, isX3D: false),
    Cpu(id: 'cpu_044', name: 'Ryzen 9 5950X', brand: 'AMD', price: 42000, socket: 'AM4', coreCount: 16, threads: 32, baseClock: 3.4, tdp: 105, integratedGraphics: 'None', hasIntegratedGraphics: false, singleCoreScore: 2300, multiCoreScore: 18000, isX3D: false),

    // ==========================================
    // AMD - MODERN MAINSTREAM & ENTHUSIAST (AM5)
    // ==========================================
    Cpu(id: 'cpu_045', name: 'Ryzen 5 7600', brand: 'AMD', price: 18000, socket: 'AM5', coreCount: 6, threads: 12, baseClock: 3.8, tdp: 65, integratedGraphics: 'Radeon', hasIntegratedGraphics: true, singleCoreScore: 2750, multiCoreScore: 12000, isX3D: false),
    Cpu(id: 'cpu_046', name: 'Ryzen 5 7600X', brand: 'AMD', price: 19499, socket: 'AM5', coreCount: 6, threads: 12, baseClock: 4.7, tdp: 105, integratedGraphics: 'Radeon', hasIntegratedGraphics: true, singleCoreScore: 2950, multiCoreScore: 13500, isX3D: false),
    Cpu(id: 'cpu_047', name: 'Ryzen 7 7800X3D', brand: 'AMD', price: 36999, socket: 'AM5', coreCount: 8, threads: 16, baseClock: 4.2, tdp: 120, integratedGraphics: 'Radeon', hasIntegratedGraphics: true, singleCoreScore: 2723, multiCoreScore: 15000, isX3D: true),
    Cpu(id: 'cpu_048', name: 'Ryzen 9 7900X', brand: 'AMD', price: 42000, socket: 'AM5', coreCount: 12, threads: 24, baseClock: 4.7, tdp: 170, integratedGraphics: 'Radeon', hasIntegratedGraphics: true, singleCoreScore: 3000, multiCoreScore: 19500, isX3D: false),
    Cpu(id: 'cpu_049', name: 'Ryzen 9 7950X', brand: 'AMD', price: 52000, socket: 'AM5', coreCount: 16, threads: 32, baseClock: 4.5, tdp: 170, integratedGraphics: 'Radeon', hasIntegratedGraphics: true, singleCoreScore: 3100, multiCoreScore: 23000, isX3D: false),
    Cpu(id: 'cpu_050', name: 'Ryzen 9 9950X3D', brand: 'AMD', price: 69999, socket: 'AM5', coreCount: 16, threads: 32, baseClock: 4.3, tdp: 170, integratedGraphics: 'Radeon', hasIntegratedGraphics: true, singleCoreScore: 3395, multiCoreScore: 22550, isX3D: true),
  ];

// ==========================================
  // 2. MOTHERBOARDS (Curated 80/20 Pareto List)
  // ==========================================
  static List<Motherboard> motherboards = [
    
    // ------------------------------------------
    // INTEL - LEGACY (LGA 1151)
    // ------------------------------------------
    Motherboard(name: "Gigabyte H110M-S2", brand: "Gigabyte", price: 3500, socket: "LGA1151", formFactor: "mATX", memoryType: "DDR4", maxRam: 32, m2Slots: 0, memorySlots: 2, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "MSI B250M PRO-VD", brand: "MSI", price: 4200, socket: "LGA1151", formFactor: "mATX", memoryType: "DDR4", maxRam: 32, m2Slots: 1, memorySlots: 2, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "ASUS Prime B365M-A", brand: "ASUS", price: 5800, socket: "LGA1151", formFactor: "mATX", memoryType: "DDR4", maxRam: 64, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "MSI Z390-A PRO", brand: "MSI", price: 10500, socket: "LGA1151", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "ASUS ROG Maximus XI Hero", brand: "ASUS", price: 22000, socket: "LGA1151", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: true, pcieGen: 3, wifiVersion: "Wi-Fi 5"),

    // ------------------------------------------
    // INTEL - OLDER MAINSTREAM (LGA 1200)
    // ------------------------------------------
    Motherboard(name: "MSI H410M-A PRO", brand: "MSI", price: 5200, socket: "LGA1200", formFactor: "mATX", memoryType: "DDR4", maxRam: 64, m2Slots: 1, memorySlots: 2, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "Gigabyte B460M DS3H", brand: "Gigabyte", price: 7500, socket: "LGA1200", formFactor: "mATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "ASUS Prime B560-PLUS", brand: "ASUS", price: 9800, socket: "LGA1200", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "MSI MAG Z490 TOMAHAWK", brand: "MSI", price: 15500, socket: "LGA1200", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "Gigabyte Z590 AORUS ELITE", brand: "Gigabyte", price: 18000, socket: "LGA1200", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 3, memorySlots: 4, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "ASUS ROG Strix Z590-E Gaming", brand: "ASUS", price: 28000, socket: "LGA1200", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 4, memorySlots: 4, hasWifi: true, pcieGen: 4, wifiVersion: "Wi-Fi 6"),

    // ------------------------------------------
    // INTEL - MODERN MAINSTREAM (LGA 1700 - DDR4)
    // ------------------------------------------
    Motherboard(name: "Gigabyte H610M S2H DDR4", brand: "Gigabyte", price: 6800, socket: "LGA1700", formFactor: "mATX", memoryType: "DDR4", maxRam: 64, m2Slots: 1, memorySlots: 2, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "ASUS Prime H610M-E D4", brand: "ASUS", price: 7200, socket: "LGA1700", formFactor: "mATX", memoryType: "DDR4", maxRam: 64, m2Slots: 1, memorySlots: 2, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "MSI PRO B660M-A DDR4", brand: "MSI", price: 11500, socket: "LGA1700", formFactor: "mATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "Gigabyte B760M DS3H DDR4", brand: "Gigabyte", price: 12000, socket: "LGA1700", formFactor: "mATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "ASUS TUF Gaming Z690-PLUS D4", brand: "ASUS", price: 22000, socket: "LGA1700", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 4, memorySlots: 4, hasWifi: true, pcieGen: 5, wifiVersion: "Wi-Fi 6"),
    
    // ------------------------------------------
    // INTEL - MODERN ENTHUSIAST (LGA 1700 - DDR5)
    // ------------------------------------------
    Motherboard(name: "MSI PRO B760-P WIFI", brand: "MSI", price: 14500, socket: "LGA1700", formFactor: "ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 2, memorySlots: 4, hasWifi: true, pcieGen: 4, wifiVersion: "Wi-Fi 6E"),
    Motherboard(name: "Gigabyte B760 AORUS ELITE AX", brand: "Gigabyte", price: 16800, socket: "LGA1700", formFactor: "ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 3, memorySlots: 4, hasWifi: true, pcieGen: 4, wifiVersion: "Wi-Fi 6E"),
    Motherboard(name: "ASUS Prime Z790-P WIFI", brand: "ASUS", price: 21000, socket: "LGA1700", formFactor: "ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 3, memorySlots: 4, hasWifi: true, pcieGen: 5, wifiVersion: "Wi-Fi 6"),
    Motherboard(name: "MSI MAG Z790 TOMAHAWK WIFI", brand: "MSI", price: 26500, socket: "LGA1700", formFactor: "ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 4, memorySlots: 4, hasWifi: true, pcieGen: 5, wifiVersion: "Wi-Fi 6E"),
    Motherboard(name: "Gigabyte Z790 AORUS MASTER", brand: "Gigabyte", price: 45000, socket: "LGA1700", formFactor: "E-ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 5, memorySlots: 4, hasWifi: true, pcieGen: 5, wifiVersion: "Wi-Fi 6E"),
    Motherboard(name: "ASUS ROG Maximus Z790 Hero", brand: "ASUS", price: 62000, socket: "LGA1700", formFactor: "ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 5, memorySlots: 4, hasWifi: true, pcieGen: 5, wifiVersion: "Wi-Fi 6E"),

    // ------------------------------------------
    // AMD - LEGACY & BUDGET (AM4)
    // ------------------------------------------
    Motherboard(name: "ASRock A320M-HDV R4.0", brand: "ASRock", price: 3800, socket: "AM4", formFactor: "mATX", memoryType: "DDR4", maxRam: 32, m2Slots: 1, memorySlots: 2, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "Gigabyte GA-A320M-S2H", brand: "Gigabyte", price: 4100, socket: "AM4", formFactor: "mATX", memoryType: "DDR4", maxRam: 32, m2Slots: 1, memorySlots: 2, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "MSI A520M-A PRO", brand: "MSI", price: 4800, socket: "AM4", formFactor: "mATX", memoryType: "DDR4", maxRam: 64, m2Slots: 1, memorySlots: 2, hasWifi: false, pcieGen: 3, wifiVersion: null),
    
    // ------------------------------------------
    // AMD - THE MAINSTREAM KINGS (AM4)
    // ------------------------------------------
    Motherboard(name: "Gigabyte B450M DS3H V2", brand: "Gigabyte", price: 5800, socket: "AM4", formFactor: "mATX", memoryType: "DDR4", maxRam: 128, m2Slots: 1, memorySlots: 4, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "MSI B450 TOMAHAWK MAX", brand: "MSI", price: 8500, socket: "AM4", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 1, memorySlots: 4, hasWifi: false, pcieGen: 3, wifiVersion: null),
    Motherboard(name: "ASUS Prime B550M-A", brand: "ASUS", price: 9200, socket: "AM4", formFactor: "mATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "MSI B550M PRO-VDH WIFI", brand: "MSI", price: 10500, socket: "AM4", formFactor: "mATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: true, pcieGen: 4, wifiVersion: "Wi-Fi 5"),
    Motherboard(name: "Gigabyte B550 AORUS ELITE", brand: "Gigabyte", price: 13500, socket: "AM4", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "ASUS ROG Strix B550-F Gaming", brand: "ASUS", price: 16800, socket: "AM4", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: true, pcieGen: 4, wifiVersion: "Wi-Fi 6"),
    
    // ------------------------------------------
    // AMD - OLDER ENTHUSIAST (AM4)
    // ------------------------------------------
    Motherboard(name: "MSI MPG X570 GAMING PLUS", brand: "MSI", price: 15000, socket: "AM4", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "ASUS TUF GAMING X570-PLUS (WI-FI)", brand: "ASUS", price: 18500, socket: "AM4", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 2, memorySlots: 4, hasWifi: true, pcieGen: 4, wifiVersion: "Wi-Fi 5"),
    Motherboard(name: "Gigabyte X570 AORUS MASTER", brand: "Gigabyte", price: 32000, socket: "AM4", formFactor: "ATX", memoryType: "DDR4", maxRam: 128, m2Slots: 3, memorySlots: 4, hasWifi: true, pcieGen: 4, wifiVersion: "Wi-Fi 6"),

    // ------------------------------------------
    // AMD - MODERN NEXT-GEN (AM5 - DDR5 Only)
    // ------------------------------------------
    Motherboard(name: "Gigabyte A620M S2H", brand: "Gigabyte", price: 7800, socket: "AM5", formFactor: "mATX", memoryType: "DDR5", maxRam: 96, m2Slots: 1, memorySlots: 2, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "MSI PRO A620M-E", brand: "MSI", price: 8200, socket: "AM5", formFactor: "mATX", memoryType: "DDR5", maxRam: 96, m2Slots: 1, memorySlots: 2, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "ASRock B650M-HDV/M.2", brand: "ASRock", price: 11000, socket: "AM5", formFactor: "mATX", memoryType: "DDR5", maxRam: 96, m2Slots: 2, memorySlots: 2, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "Gigabyte B650M DS3H", brand: "Gigabyte", price: 13500, socket: "AM5", formFactor: "mATX", memoryType: "DDR5", maxRam: 192, m2Slots: 2, memorySlots: 4, hasWifi: false, pcieGen: 4, wifiVersion: null),
    Motherboard(name: "MSI B650 GAMING PLUS WIFI", brand: "MSI", price: 16500, socket: "AM5", formFactor: "ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 2, memorySlots: 4, hasWifi: true, pcieGen: 4, wifiVersion: "Wi-Fi 6E"),
    Motherboard(name: "ASUS TUF GAMING B650-PLUS WIFI", brand: "ASUS", price: 19000, socket: "AM5", formFactor: "ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 3, memorySlots: 4, hasWifi: true, pcieGen: 4, wifiVersion: "Wi-Fi 6"),
    Motherboard(name: "MSI MAG X670E TOMAHAWK WIFI", brand: "MSI", price: 28000, socket: "AM5", formFactor: "ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 4, memorySlots: 4, hasWifi: true, pcieGen: 5, wifiVersion: "Wi-Fi 6E"),
    Motherboard(name: "ASUS ROG STRIX X670E-E GAMING", brand: "ASUS", price: 42000, socket: "AM5", formFactor: "ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 4, memorySlots: 4, hasWifi: true, pcieGen: 5, wifiVersion: "Wi-Fi 6E"),
    Motherboard(name: "Gigabyte X870E AORUS MASTER", brand: "Gigabyte", price: 48000, socket: "AM5", formFactor: "E-ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 4, memorySlots: 4, hasWifi: true, pcieGen: 5, wifiVersion: "Wi-Fi 7"),
    Motherboard(name: "ASUS ROG CROSSHAIR X670E EXTREME", brand: "ASUS", price: 85000, socket: "AM5", formFactor: "E-ATX", memoryType: "DDR5", maxRam: 192, m2Slots: 5, memorySlots: 4, hasWifi: true, pcieGen: 5, wifiVersion: "Wi-Fi 6E"),
  ];
  
// ==========================================
  // 3. RAM (Memory - Mixed DDR4/DDR5 & Module Counts)
  // ==========================================
  static List<Ram> ramSticks = [
    // ------------------------------------------
    // DDR4 - ENTRY LEVEL & BOTTLENECKS (1x4GB / 1x8GB)
    // ------------------------------------------
    Ram(name: "Adata Premier 4GB (1x4)", brand: "Adata", price: 1100, type: "DDR4", capacity: 4, speed: 2400, modules: 1, color: "Green"), // Severe Bottleneck
    Ram(name: "Crucial Basics 4GB (1x4)", brand: "Crucial", price: 1200, type: "DDR4", capacity: 4, speed: 2666, modules: 1, color: "Green"),
    Ram(name: "HyperX Fury 8GB (1x8)", brand: "HyperX", price: 2100, type: "DDR4", capacity: 8, speed: 2666, modules: 1, color: "Black"), // Mild Bottleneck
    Ram(name: "Corsair Vengeance LPX 8GB (1x8)", brand: "Corsair", price: 2300, type: "DDR4", capacity: 8, speed: 3200, modules: 1, color: "Black"),
    Ram(name: "G.Skill Ripjaws V 8GB (1x8)", brand: "G.Skill", price: 2400, type: "DDR4", capacity: 8, speed: 3200, modules: 1, color: "Red"),

    // ------------------------------------------
    // DDR4 - THE 80/20 MAINSTREAM KINGS (2x8GB = 16GB)
    // ------------------------------------------
    Ram(name: "TeamGroup T-Force Vulcan 16GB (2x8)", brand: "TeamGroup", price: 3500, type: "DDR4", capacity: 16, speed: 3000, modules: 2, color: "Red"),
    Ram(name: "Corsair Vengeance LPX 16GB (2x8)", brand: "Corsair", price: 3800, type: "DDR4", capacity: 16, speed: 3200, modules: 2, color: "Black"),
    Ram(name: "Crucial Ballistix 16GB (2x8)", brand: "Crucial", price: 3900, type: "DDR4", capacity: 16, speed: 3200, modules: 2, color: "White"),
    Ram(name: "G.Skill Ripjaws V 16GB (2x8)", brand: "G.Skill", price: 4200, type: "DDR4", capacity: 16, speed: 3600, modules: 2, color: "Black"),
    Ram(name: "Kingston FURY Beast 16GB (2x8)", brand: "Kingston", price: 4300, type: "DDR4", capacity: 16, speed: 3600, modules: 2, color: "Black"),
    Ram(name: "Corsair Vengeance RGB Pro 16GB (2x8)", brand: "Corsair", price: 5200, type: "DDR4", capacity: 16, speed: 3200, modules: 2, color: "RGB"),
    Ram(name: "G.Skill Trident Z RGB 16GB (2x8)", brand: "G.Skill", price: 5800, type: "DDR4", capacity: 16, speed: 3600, modules: 2, color: "RGB"),
    Ram(name: "Adata XPG Spectrix D41 16GB (2x8)", brand: "Adata", price: 4800, type: "DDR4", capacity: 16, speed: 3200, modules: 2, color: "RGB"),

    // ------------------------------------------
    // DDR4 - HIGH END & CONTENT CREATION (32GB / 64GB / 128GB)
    // ------------------------------------------
    Ram(name: "Corsair Vengeance LPX 32GB (2x16)", brand: "Corsair", price: 6800, type: "DDR4", capacity: 32, speed: 3200, modules: 2, color: "Black"),
    Ram(name: "G.Skill Ripjaws V 32GB (2x16)", brand: "G.Skill", price: 7200, type: "DDR4", capacity: 32, speed: 3600, modules: 2, color: "Black"),
    Ram(name: "Kingston FURY Beast 32GB (2x16)", brand: "Kingston", price: 7500, type: "DDR4", capacity: 32, speed: 3200, modules: 2, color: "Black"),
    Ram(name: "Corsair Vengeance RGB Pro 32GB (2x16)", brand: "Corsair", price: 8500, type: "DDR4", capacity: 32, speed: 3600, modules: 2, color: "RGB"),
    Ram(name: "G.Skill Trident Z Neo 32GB (2x16)", brand: "G.Skill", price: 9500, type: "DDR4", capacity: 32, speed: 3600, modules: 2, color: "RGB"),
    Ram(name: "Corsair Vengeance LPX 64GB (2x32)", brand: "Corsair", price: 13500, type: "DDR4", capacity: 64, speed: 3200, modules: 2, color: "Black"),
    Ram(name: "G.Skill Ripjaws V 64GB (2x32)", brand: "G.Skill", price: 14200, type: "DDR4", capacity: 64, speed: 3600, modules: 2, color: "Black"),
    Ram(name: "Corsair Vengeance RGB Pro 64GB (4x16)", brand: "Corsair", price: 16800, type: "DDR4", capacity: 64, speed: 3600, modules: 4, color: "RGB"), // Fills 4 Slots!
    Ram(name: "G.Skill Trident Z Neo 64GB (4x16)", brand: "G.Skill", price: 18500, type: "DDR4", capacity: 64, speed: 3600, modules: 4, color: "RGB"), // Fills 4 Slots!
    Ram(name: "Corsair Vengeance LPX 128GB (4x32)", brand: "Corsair", price: 28000, type: "DDR4", capacity: 128, speed: 3200, modules: 4, color: "Black"), // Maxes out boards

    // ------------------------------------------
    // DDR5 - ENTRY LEVEL (8GB / 16GB Single Sticks)
    // ------------------------------------------
    Ram(name: "Crucial Basics 8GB (1x8) DDR5", brand: "Crucial", price: 2500, type: "DDR5", capacity: 8, speed: 4800, modules: 1, color: "Green"), // DDR5 Bottleneck
    Ram(name: "Kingston FURY Beast 8GB (1x8)", brand: "Kingston", price: 2800, type: "DDR5", capacity: 8, speed: 4800, modules: 1, color: "Black"),
    Ram(name: "Crucial RAM 16GB (1x16) DDR5", brand: "Crucial", price: 4200, type: "DDR5", capacity: 16, speed: 4800, modules: 1, color: "Black"),

    // ------------------------------------------
    // DDR5 - MAINSTREAM SWEET SPOT (16GB / 32GB)
    // ------------------------------------------
    Ram(name: "Corsair Vengeance 16GB (2x8)", brand: "Corsair", price: 5200, type: "DDR5", capacity: 16, speed: 4800, modules: 2, color: "Black"),
    Ram(name: "Kingston FURY Beast 16GB (2x8)", brand: "Kingston", price: 5600, type: "DDR5", capacity: 16, speed: 5200, modules: 2, color: "Black"),
    Ram(name: "Corsair Vengeance 32GB (2x16)", brand: "Corsair", price: 9500, type: "DDR5", capacity: 32, speed: 5600, modules: 2, color: "Black"),
    Ram(name: "G.Skill Flare X5 32GB (2x16)", brand: "G.Skill", price: 9800, type: "DDR5", capacity: 32, speed: 6000, modules: 2, color: "Black"),
    Ram(name: "Kingston FURY Beast 32GB (2x16)", brand: "Kingston", price: 10200, type: "DDR5", capacity: 32, speed: 6000, modules: 2, color: "Black"),
    Ram(name: "TeamGroup T-Force Delta 32GB (2x16)", brand: "TeamGroup", price: 10800, type: "DDR5", capacity: 32, speed: 6000, modules: 2, color: "RGB"),
    Ram(name: "Corsair Vengeance RGB 32GB (2x16)", brand: "Corsair", price: 11500, type: "DDR5", capacity: 32, speed: 6000, modules: 2, color: "RGB"),
    Ram(name: "Adata XPG Lancer RGB 32GB (2x16)", brand: "Adata", price: 11000, type: "DDR5", capacity: 32, speed: 6000, modules: 2, color: "RGB"),
    Ram(name: "G.Skill Trident Z5 Neo 32GB (2x16)", brand: "G.Skill", price: 12500, type: "DDR5", capacity: 32, speed: 6000, modules: 2, color: "Black"),
    Ram(name: "Corsair Dominator Platinum 32GB (2x16)", brand: "Corsair", price: 14500, type: "DDR5", capacity: 32, speed: 6200, modules: 2, color: "RGB"),
    Ram(name: "G.Skill Trident Z5 RGB 32GB (2x16)", brand: "G.Skill", price: 13800, type: "DDR5", capacity: 32, speed: 6400, modules: 2, color: "RGB"),

    // ------------------------------------------
    // DDR5 - ENTHUSIAST & GOD TIER (64GB / 96GB / 192GB)
    // ------------------------------------------
    Ram(name: "Corsair Vengeance 64GB (2x32)", brand: "Corsair", price: 18500, type: "DDR5", capacity: 64, speed: 5600, modules: 2, color: "Black"),
    Ram(name: "G.Skill Ripjaws S5 64GB (2x32)", brand: "G.Skill", price: 19200, type: "DDR5", capacity: 64, speed: 6000, modules: 2, color: "Black"),
    Ram(name: "Kingston FURY Beast 64GB (2x32)", brand: "Kingston", price: 19800, type: "DDR5", capacity: 64, speed: 6000, modules: 2, color: "Black"),
    Ram(name: "Corsair Vengeance RGB 64GB (2x32)", brand: "Corsair", price: 21500, type: "DDR5", capacity: 64, speed: 6000, modules: 2, color: "RGB"),
    Ram(name: "G.Skill Trident Z5 RGB 64GB (2x32)", brand: "G.Skill", price: 23000, type: "DDR5", capacity: 64, speed: 6400, modules: 2, color: "RGB"),
    Ram(name: "Corsair Dominator Titanium 64GB (2x32)", brand: "Corsair", price: 28500, type: "DDR5", capacity: 64, speed: 7200, modules: 2, color: "RGB"), // Extremely high speed
    Ram(name: "Corsair Vengeance 96GB (2x48)", brand: "Corsair", price: 31000, type: "DDR5", capacity: 96, speed: 6400, modules: 2, color: "Black"), // High Density 48GB sticks
    Ram(name: "Kingston FURY Renegade 96GB (2x48)", brand: "Kingston", price: 34000, type: "DDR5", capacity: 96, speed: 6400, modules: 2, color: "Silver"),
    Ram(name: "G.Skill Trident Z5 RGB 96GB (2x48)", brand: "G.Skill", price: 36500, type: "DDR5", capacity: 96, speed: 6800, modules: 2, color: "RGB"),
    Ram(name: "Corsair Vengeance 128GB (4x32)", brand: "Corsair", price: 38000, type: "DDR5", capacity: 128, speed: 5600, modules: 4, color: "Black"), // Fills 4 Slots
    Ram(name: "G.Skill Trident Z5 192GB (4x48)", brand: "G.Skill", price: 65000, type: "DDR5", capacity: 192, speed: 5200, modules: 4, color: "RGB"), // Ultimate workstation RAM
  ];

// ==========================================
  // 4. GPUs (Legacy, Mainstream, and God-Tier)
  // ==========================================
  static List<Gpu> gpus = [
    // ------------------------------------------
    // NVIDIA - LEGACY & BUDGET (GTX 10/16 Series)
    // ------------------------------------------
    Gpu(id: 'gpu_001', name: "NVIDIA GT 1030", brand: "NVIDIA", price: 6500, vram: 2, clock: 1468, tdp: 30, cores: 384, memoryType: "GDDR5", busWidth: 64, pcieGen: "3.0", timeSpyScore: 1200, upscaling: "None"),
    Gpu(id: 'gpu_002', name: "NVIDIA GTX 1050 Ti", brand: "NVIDIA", price: 10500, vram: 4, clock: 1392, tdp: 75, cores: 768, memoryType: "GDDR5", busWidth: 128, pcieGen: "3.0", timeSpyScore: 2400, upscaling: "None"),
    Gpu(id: 'gpu_003', name: "NVIDIA GTX 1060 6GB", brand: "NVIDIA", price: 14000, vram: 6, clock: 1708, tdp: 120, cores: 1280, memoryType: "GDDR5", busWidth: 192, pcieGen: "3.0", timeSpyScore: 4200, upscaling: "None"),
    Gpu(id: 'gpu_004', name: "NVIDIA GTX 1070", brand: "NVIDIA", price: 18000, vram: 8, clock: 1683, tdp: 150, cores: 1920, memoryType: "GDDR5", busWidth: 256, pcieGen: "3.0", timeSpyScore: 6000, upscaling: "None"),
    Gpu(id: 'gpu_005', name: "NVIDIA GTX 1080 Ti", brand: "NVIDIA", price: 28000, vram: 11, clock: 1582, tdp: 250, cores: 3584, memoryType: "GDDR5X", busWidth: 352, pcieGen: "3.0", timeSpyScore: 9500, upscaling: "None"),
    Gpu(id: 'gpu_006', name: "NVIDIA GTX 1650", brand: "NVIDIA", price: 12500, vram: 4, clock: 1590, tdp: 75, cores: 896, memoryType: "GDDR6", busWidth: 128, pcieGen: "3.0", timeSpyScore: 3500, upscaling: "None"),
    Gpu(id: 'gpu_007', name: "NVIDIA GTX 1660 SUPER", brand: "NVIDIA", price: 18500, vram: 6, clock: 1785, tdp: 125, cores: 1408, memoryType: "GDDR6", busWidth: 192, pcieGen: "3.0", timeSpyScore: 6100, upscaling: "None"),

    // ------------------------------------------
    // AMD - LEGACY & BUDGET (RX 500 / 5000 Series)
    // ------------------------------------------
    Gpu(id: 'gpu_008', name: "AMD Radeon RX 570", brand: "AMD", price: 9000, vram: 4, clock: 1244, tdp: 150, cores: 2048, memoryType: "GDDR5", busWidth: 256, pcieGen: "3.0", timeSpyScore: 3800, upscaling: "FSR 1"),
    Gpu(id: 'gpu_009', name: "AMD Radeon RX 580", brand: "AMD", price: 11500, vram: 8, clock: 1340, tdp: 185, cores: 2304, memoryType: "GDDR5", busWidth: 256, pcieGen: "3.0", timeSpyScore: 4300, upscaling: "FSR 1"),
    Gpu(id: 'gpu_010', name: "AMD Radeon RX 5500 XT", brand: "AMD", price: 14500, vram: 8, clock: 1845, tdp: 130, cores: 1408, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 5000, upscaling: "FSR 1"),
    Gpu(id: 'gpu_011', name: "AMD Radeon RX 5700 XT", brand: "AMD", price: 22000, vram: 8, clock: 1905, tdp: 225, cores: 2560, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 9200, upscaling: "FSR 1"),

    // ------------------------------------------
    // NVIDIA - OLDER MAINSTREAM (RTX 20/30 Series)
    // ------------------------------------------
    Gpu(id: 'gpu_012', name: "NVIDIA RTX 2060", brand: "NVIDIA", price: 21000, vram: 6, clock: 1680, tdp: 160, cores: 1920, memoryType: "GDDR6", busWidth: 192, pcieGen: "3.0", timeSpyScore: 7500, upscaling: "DLSS 2.0"),
    Gpu(id: 'gpu_013', name: "NVIDIA RTX 2070 SUPER", brand: "NVIDIA", price: 32000, vram: 8, clock: 1770, tdp: 215, cores: 2560, memoryType: "GDDR6", busWidth: 256, pcieGen: "3.0", timeSpyScore: 10200, upscaling: "DLSS 2.0"),
    Gpu(id: 'gpu_014', name: "NVIDIA RTX 3050", brand: "NVIDIA", price: 22500, vram: 8, clock: 1780, tdp: 130, cores: 2560, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 6200, upscaling: "DLSS 2.0"),
    Gpu(id: 'gpu_015', name: "NVIDIA RTX 3060 8GB", brand: "NVIDIA", price: 24000, vram: 8, clock: 1777, tdp: 170, cores: 3584, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 7400, upscaling: "DLSS 2.0"),
    Gpu(id: 'gpu_016', name: "NVIDIA RTX 3060 12GB", brand: "NVIDIA", price: 26500, vram: 12, clock: 1777, tdp: 170, cores: 3584, memoryType: "GDDR6", busWidth: 192, pcieGen: "4.0", timeSpyScore: 8800, upscaling: "DLSS 2.0"),
    Gpu(id: 'gpu_017', name: "NVIDIA RTX 3060 Ti", brand: "NVIDIA", price: 31000, vram: 8, clock: 1665, tdp: 200, cores: 4864, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 11500, upscaling: "DLSS 2.0"),
    Gpu(id: 'gpu_018', name: "NVIDIA RTX 3070", brand: "NVIDIA", price: 38000, vram: 8, clock: 1730, tdp: 220, cores: 5888, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 13800, upscaling: "DLSS 2.0"),
    Gpu(id: 'gpu_019', name: "NVIDIA RTX 3080 10GB", brand: "NVIDIA", price: 55000, vram: 10, clock: 1710, tdp: 320, cores: 8704, memoryType: "GDDR6X", busWidth: 320, pcieGen: "4.0", timeSpyScore: 17500, upscaling: "DLSS 2.0"),
    Gpu(id: 'gpu_020', name: "NVIDIA RTX 3090", brand: "NVIDIA", price: 95000, vram: 24, clock: 1695, tdp: 350, cores: 10496, memoryType: "GDDR6X", busWidth: 384, pcieGen: "4.0", timeSpyScore: 20000, upscaling: "DLSS 2.0"), // Extreme power draw

    // ------------------------------------------
    // AMD - OLDER MAINSTREAM (RX 6000 Series)
    // ------------------------------------------
    Gpu(id: 'gpu_021', name: "AMD Radeon RX 6400", brand: "AMD", price: 12000, vram: 4, clock: 2321, tdp: 53, cores: 768, memoryType: "GDDR6", busWidth: 64, pcieGen: "4.0", timeSpyScore: 3500, upscaling: "FSR 2.0"),
    Gpu(id: 'gpu_022', name: "AMD Radeon RX 6500 XT", brand: "AMD", price: 14500, vram: 4, clock: 2815, tdp: 107, cores: 1024, memoryType: "GDDR6", busWidth: 64, pcieGen: "4.0", timeSpyScore: 4800, upscaling: "FSR 2.0"), // Bottlenecks on Gen3 boards
    Gpu(id: 'gpu_023', name: "AMD Radeon RX 6600", brand: "AMD", price: 20000, vram: 8, clock: 2490, tdp: 132, cores: 1792, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 8100, upscaling: "FSR 2.1"),
    Gpu(id: 'gpu_024', name: "AMD Radeon RX 6600 XT", brand: "AMD", price: 24000, vram: 8, clock: 2589, tdp: 160, cores: 2048, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 9600, upscaling: "FSR 2.1"),
    Gpu(id: 'gpu_025', name: "AMD Radeon RX 6700 XT", brand: "AMD", price: 31000, vram: 12, clock: 2581, tdp: 230, cores: 2560, memoryType: "GDDR6", busWidth: 192, pcieGen: "4.0", timeSpyScore: 12500, upscaling: "FSR 2.1"),
    Gpu(id: 'gpu_026', name: "AMD Radeon RX 6800", brand: "AMD", price: 42000, vram: 16, clock: 2105, tdp: 250, cores: 3840, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 15500, upscaling: "FSR 2.1"),
    Gpu(id: 'gpu_027', name: "AMD Radeon RX 6800 XT", brand: "AMD", price: 52000, vram: 16, clock: 2250, tdp: 300, cores: 4608, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 18500, upscaling: "FSR 2.1"),
    Gpu(id: 'gpu_028', name: "AMD Radeon RX 6900 XT", brand: "AMD", price: 75000, vram: 16, clock: 2250, tdp: 300, cores: 5120, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 20500, upscaling: "FSR 2.1"),

    // ------------------------------------------
    // INTEL ARC - MAINSTREAM (Alchemist)
    // ------------------------------------------
    Gpu(id: 'gpu_029', name: "Intel Arc A380", brand: "Intel", price: 11500, vram: 6, clock: 2000, tdp: 75, cores: 1024, memoryType: "GDDR6", busWidth: 96, pcieGen: "4.0", timeSpyScore: 4500, upscaling: "XeSS"),
    Gpu(id: 'gpu_030', name: "Intel Arc A750", brand: "Intel", price: 21000, vram: 8, clock: 2050, tdp: 225, cores: 3584, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 11500, upscaling: "XeSS"),
    Gpu(id: 'gpu_031', name: "Intel Arc A770", brand: "Intel", price: 26000, vram: 16, clock: 2100, tdp: 225, cores: 4096, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 13000, upscaling: "XeSS"),

    // ------------------------------------------
    // NVIDIA - MODERN MAINSTREAM & ENTHUSIAST (RTX 40 Series)
    // ------------------------------------------
    Gpu(id: 'gpu_032', name: "NVIDIA RTX 4060", brand: "NVIDIA", price: 29500, vram: 8, clock: 2460, tdp: 115, cores: 3072, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 10500, upscaling: "DLSS 3.0"), // Frame Gen
    Gpu(id: 'gpu_033', name: "NVIDIA RTX 4060 Ti 8GB", brand: "NVIDIA", price: 38000, vram: 8, clock: 2535, tdp: 160, cores: 4352, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 13500, upscaling: "DLSS 3.0"),
    Gpu(id: 'gpu_034', name: "NVIDIA RTX 4060 Ti 16GB", brand: "NVIDIA", price: 44000, vram: 16, clock: 2535, tdp: 165, cores: 4352, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 13600, upscaling: "DLSS 3.0"),
    Gpu(id: 'gpu_035', name: "NVIDIA RTX 4070", brand: "NVIDIA", price: 55000, vram: 12, clock: 2475, tdp: 200, cores: 5888, memoryType: "GDDR6X", busWidth: 192, pcieGen: "4.0", timeSpyScore: 18000, upscaling: "DLSS 3.0"),
    Gpu(id: 'gpu_036', name: "NVIDIA RTX 4070 SUPER", brand: "NVIDIA", price: 59000, vram: 12, clock: 2475, tdp: 220, cores: 7168, memoryType: "GDDR6X", busWidth: 192, pcieGen: "4.0", timeSpyScore: 21000, upscaling: "DLSS 3.0"),
    Gpu(id: 'gpu_037', name: "NVIDIA RTX 4070 Ti SUPER", brand: "NVIDIA", price: 78000, vram: 16, clock: 2610, tdp: 285, cores: 8448, memoryType: "GDDR6X", busWidth: 256, pcieGen: "4.0", timeSpyScore: 24500, upscaling: "DLSS 3.0"),
    Gpu(id: 'gpu_038', name: "NVIDIA RTX 4080 SUPER", brand: "NVIDIA", price: 98000, vram: 16, clock: 2550, tdp: 320, cores: 10240, memoryType: "GDDR6X", busWidth: 256, pcieGen: "4.0", timeSpyScore: 28300, upscaling: "DLSS 3.5"),
    Gpu(id: 'gpu_039', name: "NVIDIA RTX 4090", brand: "NVIDIA", price: 185000, vram: 24, clock: 2520, tdp: 450, cores: 16384, memoryType: "GDDR6X", busWidth: 384, pcieGen: "4.0", timeSpyScore: 36300, upscaling: "DLSS 3.5"), // The ultimate power hog

    // ------------------------------------------
    // AMD - MODERN MAINSTREAM & ENTHUSIAST (RX 7000 Series)
    // ------------------------------------------
    Gpu(id: 'gpu_040', name: "AMD Radeon RX 7600", brand: "AMD", price: 26000, vram: 8, clock: 2655, tdp: 165, cores: 2048, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 10800, upscaling: "FSR 3.0"),
    Gpu(id: 'gpu_041', name: "AMD Radeon RX 7600 XT", brand: "AMD", price: 31000, vram: 16, clock: 2755, tdp: 190, cores: 2048, memoryType: "GDDR6", busWidth: 128, pcieGen: "4.0", timeSpyScore: 11200, upscaling: "FSR 3.0"),
    Gpu(id: 'gpu_042', name: "AMD Radeon RX 7700 XT", brand: "AMD", price: 42000, vram: 12, clock: 2544, tdp: 245, cores: 3456, memoryType: "GDDR6", busWidth: 192, pcieGen: "4.0", timeSpyScore: 17000, upscaling: "FSR 3.0"),
    Gpu(id: 'gpu_043', name: "AMD Radeon RX 7800 XT", brand: "AMD", price: 51000, vram: 16, clock: 2430, tdp: 263, cores: 3840, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 19500, upscaling: "FSR 3.0"),
    Gpu(id: 'gpu_044', name: "AMD Radeon RX 7900 GRE", brand: "AMD", price: 56000, vram: 16, clock: 2245, tdp: 260, cores: 5120, memoryType: "GDDR6", busWidth: 256, pcieGen: "4.0", timeSpyScore: 21500, upscaling: "FSR 3.0"),
    Gpu(id: 'gpu_045', name: "AMD Radeon RX 7900 XT", brand: "AMD", price: 74000, vram: 20, clock: 2400, tdp: 315, cores: 5376, memoryType: "GDDR6", busWidth: 320, pcieGen: "4.0", timeSpyScore: 26000, upscaling: "FSR 3.0"),
    Gpu(id: 'gpu_046', name: "AMD Radeon RX 7900 XTX", brand: "AMD", price: 95000, vram: 24, clock: 2500, tdp: 355, cores: 6144, memoryType: "GDDR6", busWidth: 384, pcieGen: "4.0", timeSpyScore: 29500, upscaling: "FSR 3.0"),

    // ------------------------------------------
    // THE FUTURE (Hypothetical Next-Gen for 2026 Simulation)
    // ------------------------------------------
    Gpu(id: 'gpu_047', name: "NVIDIA RTX 5060", brand: "NVIDIA", price: 35000, vram: 8, clock: 2600, tdp: 115, cores: 3584, memoryType: "GDDR7", busWidth: 128, pcieGen: "5.0", timeSpyScore: 13500, upscaling: "DLSS 4.0"),
    Gpu(id: 'gpu_048', name: "NVIDIA RTX 5070", brand: "NVIDIA", price: 62000, vram: 12, clock: 2650, tdp: 220, cores: 7168, memoryType: "GDDR7", busWidth: 192, pcieGen: "5.0", timeSpyScore: 24000, upscaling: "DLSS 4.0"),
    Gpu(id: 'gpu_049', name: "NVIDIA RTX 5090", brand: "NVIDIA", price: 210000, vram: 32, clock: 2900, tdp: 600, cores: 21760, memoryType: "GDDR7", busWidth: 512, pcieGen: "5.0", timeSpyScore: 58000, upscaling: "DLSS 4.0"),
    Gpu(id: 'gpu_050', name: "AMD Radeon RX 8800 XT", brand: "AMD", price: 55000, vram: 16, clock: 2800, tdp: 250, cores: 4096, memoryType: "GDDR6", busWidth: 256, pcieGen: "5.0", timeSpyScore: 23500, upscaling: "FSR 4.0"),
  ];

// ==========================================
  // 5. STORAGE (HDDs, SATA SSDs, NVMe Gen 3/4/5)
  // ==========================================
  static List<Storage> storageItems = [
    // ------------------------------------------
    // MECHANICAL HDDs (Mass Storage / Massive Bottlenecks)
    // ------------------------------------------
    Storage(name: "WD Blue 1TB (7200RPM)", brand: "WD", type: "HDD", format: "3.5 inch", capacity: 1000, price: 3500, readSpeed: 150, writeSpeed: 150, pcieGen: 0),
    Storage(name: "Seagate BarraCuda 2TB (7200RPM)", brand: "Seagate", type: "HDD", format: "3.5 inch", capacity: 2000, price: 4800, readSpeed: 190, writeSpeed: 190, pcieGen: 0),
    Storage(name: "WD Blue 4TB (5400RPM)", brand: "WD", type: "HDD", format: "3.5 inch", capacity: 4000, price: 7800, readSpeed: 130, writeSpeed: 130, pcieGen: 0), // Slow drive
    Storage(name: "Seagate IronWolf 8TB (7200RPM)", brand: "Seagate", type: "HDD", format: "3.5 inch", capacity: 8000, price: 18500, readSpeed: 210, writeSpeed: 210, pcieGen: 0),
    Storage(name: "WD Black 10TB", brand: "WD", type: "HDD", format: "3.5 inch", capacity: 10000, price: 28000, readSpeed: 250, writeSpeed: 250, pcieGen: 0),

    // ------------------------------------------
    // SATA SSDs (The Reliable "Bricks" - Faster than HDD, slower than NVMe)
    // ------------------------------------------
    Storage(name: "Kingston A400 240GB", brand: "Kingston", type: "SATA SSD", format: "2.5 inch", capacity: 240, price: 1600, readSpeed: 500, writeSpeed: 350, pcieGen: 0),
    Storage(name: "Crucial BX500 500GB", brand: "Crucial", type: "SATA SSD", format: "2.5 inch", capacity: 500, price: 2800, readSpeed: 540, writeSpeed: 500, pcieGen: 0),
    Storage(name: "Samsung 870 EVO 500GB", brand: "Samsung", type: "SATA SSD", format: "2.5 inch", capacity: 500, price: 4200, readSpeed: 560, writeSpeed: 530, pcieGen: 0),
    Storage(name: "WD Blue SA510 1TB", brand: "WD", type: "SATA SSD", format: "2.5 inch", capacity: 1000, price: 5800, readSpeed: 560, writeSpeed: 520, pcieGen: 0),
    Storage(name: "Crucial MX500 1TB", brand: "Crucial", type: "SATA SSD", format: "2.5 inch", capacity: 1000, price: 6200, readSpeed: 560, writeSpeed: 510, pcieGen: 0),
    Storage(name: "Samsung 870 EVO 2TB", brand: "Samsung", type: "SATA SSD", format: "2.5 inch", capacity: 2000, price: 12500, readSpeed: 560, writeSpeed: 530, pcieGen: 0),
    Storage(name: "Samsung 870 QVO 4TB", brand: "Samsung", type: "SATA SSD", format: "2.5 inch", capacity: 4000, price: 22000, readSpeed: 560, writeSpeed: 530, pcieGen: 0),

    // ------------------------------------------
    // NVMe Gen 3 (Older Motherboard Sweet Spot)
    // ------------------------------------------
    Storage(name: "Crucial P3 500GB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 500, price: 3200, readSpeed: 3500, writeSpeed: 1900, pcieGen: 3),
    Storage(name: "WD Blue SN570 500GB", brand: "WD", type: "NVMe SSD", format: "M.2", capacity: 500, price: 3500, readSpeed: 3500, writeSpeed: 2300, pcieGen: 3),
    Storage(name: "Samsung 970 EVO Plus 500GB", brand: "Samsung", type: "NVMe SSD", format: "M.2", capacity: 500, price: 4800, readSpeed: 3500, writeSpeed: 3200, pcieGen: 3),
    Storage(name: "Crucial P3 1TB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 5500, readSpeed: 3500, writeSpeed: 3000, pcieGen: 3),
    Storage(name: "Kingston NV2 1TB", brand: "Kingston", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 5600, readSpeed: 3500, writeSpeed: 2100, pcieGen: 3),
    Storage(name: "WD Blue SN570 1TB", brand: "WD", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 6000, readSpeed: 3500, writeSpeed: 3000, pcieGen: 3),
    Storage(name: "Samsung 970 EVO Plus 1TB", brand: "Samsung", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 7800, readSpeed: 3500, writeSpeed: 3300, pcieGen: 3),
    Storage(name: "Crucial P3 2TB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 10500, readSpeed: 3500, writeSpeed: 3000, pcieGen: 3),
    Storage(name: "Samsung 970 EVO Plus 2TB", brand: "Samsung", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 14500, readSpeed: 3500, writeSpeed: 3300, pcieGen: 3),

    // ------------------------------------------
    // NVMe Gen 4 (The Current 80/20 Mainstream Kings)
    // ------------------------------------------
    Storage(name: "Crucial P3 Plus 500GB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 500, price: 4200, readSpeed: 4700, writeSpeed: 1900, pcieGen: 4),
    Storage(name: "WD Black SN770 500GB", brand: "WD", type: "NVMe SSD", format: "M.2", capacity: 500, price: 4800, readSpeed: 5000, writeSpeed: 4000, pcieGen: 4),
    Storage(name: "Kingston KC3000 500GB", brand: "Kingston", type: "NVMe SSD", format: "M.2", capacity: 500, price: 5500, readSpeed: 7000, writeSpeed: 3900, pcieGen: 4),
    Storage(name: "Crucial P3 Plus 1TB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 6800, readSpeed: 5000, writeSpeed: 3600, pcieGen: 4),
    Storage(name: "WD Black SN770 1TB", brand: "WD", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 7200, readSpeed: 5150, writeSpeed: 4900, pcieGen: 4),
    Storage(name: "Corsair MP600 PRO XT 1TB", brand: "Corsair", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 8500, readSpeed: 7100, writeSpeed: 5800, pcieGen: 4),
    Storage(name: "Samsung 980 PRO 1TB", brand: "Samsung", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 9000, readSpeed: 7000, writeSpeed: 5000, pcieGen: 4),
    Storage(name: "WD Black SN850X 1TB", brand: "WD", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 9500, readSpeed: 7300, writeSpeed: 6300, pcieGen: 4),
    Storage(name: "Samsung 990 PRO 1TB", brand: "Samsung", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 11500, readSpeed: 7450, writeSpeed: 6900, pcieGen: 4),
    Storage(name: "Crucial P5 Plus 2TB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 13500, readSpeed: 6600, writeSpeed: 5000, pcieGen: 4),
    Storage(name: "WD Black SN850X 2TB", brand: "WD", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 16500, readSpeed: 7300, writeSpeed: 6600, pcieGen: 4),
    Storage(name: "Samsung 990 PRO 2TB", brand: "Samsung", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 18500, readSpeed: 7450, writeSpeed: 6900, pcieGen: 4),
    Storage(name: "WD Black SN850X 4TB", brand: "WD", type: "NVMe SSD", format: "M.2", capacity: 4000, price: 32000, readSpeed: 7300, writeSpeed: 6600, pcieGen: 4),
    Storage(name: "Samsung 990 PRO 4TB", brand: "Samsung", type: "NVMe SSD", format: "M.2", capacity: 4000, price: 36000, readSpeed: 7450, writeSpeed: 6900, pcieGen: 4),

    // ------------------------------------------
    // NVMe Gen 5 (Enthusiast / Next-Gen - Triggers Gen4 Motherboard Bottlenecks)
    // ------------------------------------------
    Storage(name: "Crucial T700 1TB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 16500, readSpeed: 11700, writeSpeed: 9500, pcieGen: 5),
    Storage(name: "Corsair MP700 1TB", brand: "Corsair", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 17500, readSpeed: 10000, writeSpeed: 9500, pcieGen: 5),
    Storage(name: "Crucial T705 1TB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 1000, price: 21000, readSpeed: 13600, writeSpeed: 10200, pcieGen: 5),
    Storage(name: "Gigabyte AORUS Gen5 2TB", brand: "Gigabyte", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 28000, readSpeed: 10000, writeSpeed: 9500, pcieGen: 5),
    Storage(name: "TeamGroup Cardea Z540 2TB", brand: "TeamGroup", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 29500, readSpeed: 12400, writeSpeed: 11800, pcieGen: 5),
    Storage(name: "Crucial T700 2TB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 31000, readSpeed: 12400, writeSpeed: 11800, pcieGen: 5),
    Storage(name: "Corsair MP700 PRO 2TB", brand: "Corsair", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 33000, readSpeed: 12400, writeSpeed: 11800, pcieGen: 5),
    Storage(name: "Crucial T705 2TB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 2000, price: 36000, readSpeed: 14500, writeSpeed: 12700, pcieGen: 5),
    Storage(name: "Crucial T705 4TB", brand: "Crucial", type: "NVMe SSD", format: "M.2", capacity: 4000, price: 65000, readSpeed: 14500, writeSpeed: 12700, pcieGen: 5),
  ];
  
// ==========================================
  // 6. POWER SUPPLIES (PSUs) - From Office Bricks to Nuclear Reactors
  // ==========================================
  static List<Psu> psus = [
    // ------------------------------------------
    // THE "FIRE HAZARDS" (Sub-450W / Unrated) - Will crash high-end builds
    // ------------------------------------------
    Psu(name: "Generic Office PSU 350W", brand: "Generic", price: 800, wattage: 350, efficiency: "None", isModular: false),
    Psu(name: "Zebronics ZEB-450W", brand: "Zebronics", price: 1100, wattage: 450, efficiency: "None", isModular: false),
    Psu(name: "Ant Esports VS500L 500W", brand: "Ant Esports", price: 1700, wattage: 500, efficiency: "None", isModular: false),
    Psu(name: "Frontech 450W", brand: "Frontech", price: 950, wattage: 450, efficiency: "None", isModular: false),
    
    // ------------------------------------------
    // BUDGET ENTRY LEVEL (450W - 550W / 80+ White & Bronze)
    // ------------------------------------------
    Psu(name: "Corsair CV450 450W", brand: "Corsair", price: 3100, wattage: 450, efficiency: "80+ Bronze", isModular: false),
    Psu(name: "EVGA 500 W1 500W", brand: "EVGA", price: 3400, wattage: 500, efficiency: "80+ White", isModular: false),
    Psu(name: "Cooler Master MWE 450", brand: "Cooler Master", price: 3200, wattage: 450, efficiency: "80+ White", isModular: false),
    Psu(name: "Thermaltake Litepower 550W", brand: "Thermaltake", price: 3500, wattage: 550, efficiency: "None", isModular: false),
    Psu(name: "Corsair CV550 550W", brand: "Corsair", price: 4200, wattage: 550, efficiency: "80+ Bronze", isModular: false),
    Psu(name: "Gigabyte P550B 550W", brand: "Gigabyte", price: 3800, wattage: 550, efficiency: "80+ Bronze", isModular: false),
    Psu(name: "DeepCool PK550D 550W", brand: "DeepCool", price: 4000, wattage: 550, efficiency: "80+ Bronze", isModular: false),

    // ------------------------------------------
    // THE MAINSTREAM SWEET SPOT (600W - 750W / 80+ Bronze & Gold)
    // ------------------------------------------
    Psu(name: "EVGA 600 BR 600W", brand: "EVGA", price: 4600, wattage: 600, efficiency: "80+ Bronze", isModular: false),
    Psu(name: "Cooler Master MWE 650 V2", brand: "Cooler Master", price: 5400, wattage: 650, efficiency: "80+ Bronze", isModular: false),
    Psu(name: "Corsair CV650 650W", brand: "Corsair", price: 5600, wattage: 650, efficiency: "80+ Bronze", isModular: false),
    Psu(name: "DeepCool PM650D 650W", brand: "DeepCool", price: 5800, wattage: 650, efficiency: "80+ Gold", isModular: false),
    Psu(name: "MSI MAG A650BN 650W", brand: "MSI", price: 5200, wattage: 650, efficiency: "80+ Bronze", isModular: false),
    Psu(name: "Corsair RM650 650W", brand: "Corsair", price: 7500, wattage: 650, efficiency: "80+ Gold", isModular: true),
    
    Psu(name: "Cooler Master MWE 750 Gold", brand: "Cooler Master", price: 7800, wattage: 750, efficiency: "80+ Gold", isModular: true),
    Psu(name: "DeepCool PM750D 750W", brand: "DeepCool", price: 6800, wattage: 750, efficiency: "80+ Gold", isModular: false),
    Psu(name: "Gigabyte P750GM 750W", brand: "Gigabyte", price: 7200, wattage: 750, efficiency: "80+ Gold", isModular: true),
    Psu(name: "MSI MPG A750GF 750W", brand: "MSI", price: 8500, wattage: 750, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Corsair RM750e 750W", brand: "Corsair", price: 9200, wattage: 750, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Seasonic FOCUS GX-750", brand: "Seasonic", price: 10500, wattage: 750, efficiency: "80+ Gold", isModular: true),

    // ------------------------------------------
    // HIGH END (850W - 1000W / 80+ Gold & Platinum)
    // ------------------------------------------
    Psu(name: "Thermaltake Toughpower 850W", brand: "Thermaltake", price: 9500, wattage: 850, efficiency: "80+ Gold", isModular: true),
    Psu(name: "MSI MPG A850G 850W", brand: "MSI", price: 10500, wattage: 850, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Corsair RM850e 850W", brand: "Corsair", price: 11000, wattage: 850, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Corsair RM850x 850W", brand: "Corsair", price: 12500, wattage: 850, efficiency: "80+ Gold", isModular: true), // Premium capacitors
    Psu(name: "Seasonic FOCUS GX-850", brand: "Seasonic", price: 12800, wattage: 850, efficiency: "80+ Gold", isModular: true),
    Psu(name: "ASUS ROG Strix 850W", brand: "ASUS", price: 14000, wattage: 850, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Be Quiet! Straight Power 850W", brand: "Be Quiet!", price: 13500, wattage: 850, efficiency: "80+ Platinum", isModular: true),
    
    Psu(name: "DeepCool PQ1000M 1000W", brand: "DeepCool", price: 13500, wattage: 1000, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Gigabyte UD1000GM 1000W", brand: "Gigabyte", price: 14000, wattage: 1000, efficiency: "80+ Gold", isModular: true),
    Psu(name: "MSI MPG A1000G 1000W", brand: "MSI", price: 16500, wattage: 1000, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Corsair RM1000e 1000W", brand: "Corsair", price: 16800, wattage: 1000, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Corsair RM1000x 1000W", brand: "Corsair", price: 18500, wattage: 1000, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Seasonic Vertex GX-1000", brand: "Seasonic", price: 19500, wattage: 1000, efficiency: "80+ Gold", isModular: true),
    Psu(name: "ASUS ROG Strix 1000W", brand: "ASUS", price: 21000, wattage: 1000, efficiency: "80+ Gold", isModular: true),
    Psu(name: "FSP Hydro PTM PRO 1000W", brand: "FSP", price: 22500, wattage: 1000, efficiency: "80+ Platinum", isModular: true),

    // ------------------------------------------
    // ENTHUSIAST & GOD TIER (1200W+ / Platinum & Titanium)
    // ------------------------------------------
    Psu(name: "Thermaltake Toughpower GF3 1200W", brand: "Thermaltake", price: 19500, wattage: 1200, efficiency: "80+ Gold", isModular: true),
    Psu(name: "Corsair HX1200 1200W", brand: "Corsair", price: 24500, wattage: 1200, efficiency: "80+ Platinum", isModular: true),
    Psu(name: "Seasonic PRIME PX-1200", brand: "Seasonic", price: 26000, wattage: 1200, efficiency: "80+ Platinum", isModular: true),
    Psu(name: "ASUS ROG Thor 1200P", brand: "ASUS", price: 29000, wattage: 1200, efficiency: "80+ Platinum", isModular: true), // Has OLED screen in real life
    Psu(name: "MSI MEG Ai1300P 1300W", brand: "MSI", price: 28500, wattage: 1300, efficiency: "80+ Platinum", isModular: true),
    Psu(name: "SilverStone Hela 1300R", brand: "SilverStone", price: 27000, wattage: 1300, efficiency: "80+ Platinum", isModular: true),
    
    Psu(name: "Corsair AX1600i 1600W", brand: "Corsair", price: 45000, wattage: 1600, efficiency: "80+ Titanium", isModular: true), // The absolute king of PSUs
    Psu(name: "Seasonic PRIME TX-1600", brand: "Seasonic", price: 48000, wattage: 1600, efficiency: "80+ Titanium", isModular: true),
    Psu(name: "ASUS ROG Thor 1600T", brand: "ASUS", price: 55000, wattage: 1600, efficiency: "80+ Titanium", isModular: true),
  ];

// ==========================================
  // 7. COOLERS (Air & Liquid - For Thermal & Socket Testing)
  // ==========================================
  static List<Cooler> coolers = [
    // ------------------------------------------
    // THE THROTTLING KINGS (Stock & Low-Profile)
    // ------------------------------------------
    Cooler(name: "Intel Laminar RM1 (Stock)", brand: "Intel", price: 0, type: "Air", fanSize: 92, fanCount: 1, hasRGB: false, supportedSockets: ["LGA1700"]),
    Cooler(name: "Intel Stock Cooler (Legacy)", brand: "Intel", price: 0, type: "Air", fanSize: 92, fanCount: 1, hasRGB: false, supportedSockets: ["LGA1151", "LGA1200"]),
    Cooler(name: "AMD Wraith Stealth (Stock)", brand: "AMD", price: 0, type: "Air", fanSize: 92, fanCount: 1, hasRGB: false, supportedSockets: ["AM4", "AM5"]),
    Cooler(name: "AMD Wraith Prism RGB", brand: "AMD", price: 1500, type: "Air", fanSize: 92, fanCount: 1, hasRGB: true, supportedSockets: ["AM4", "AM5"]),
    Cooler(name: "Noctua NH-L9i Low Profile", brand: "Noctua", price: 4200, type: "Air", fanSize: 92, fanCount: 1, hasRGB: false, supportedSockets: ["LGA1151", "LGA1200", "LGA1700"]),

    // ------------------------------------------
    // MAINSTREAM AIR (The 80/20 Sweet Spot - Single Tower)
    // ------------------------------------------
    Cooler(name: "Cooler Master Hyper 212", brand: "Cooler Master", price: 3200, type: "Air", fanSize: 120, fanCount: 1, hasRGB: false, supportedSockets: ["LGA1151", "LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "Cooler Master Hyper 212 RGB", brand: "Cooler Master", price: 3800, type: "Air", fanSize: 120, fanCount: 1, hasRGB: true, supportedSockets: ["LGA1151", "LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "DeepCool AK400", brand: "DeepCool", price: 2500, type: "Air", fanSize: 120, fanCount: 1, hasRGB: false, supportedSockets: ["LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "DeepCool AK400 Digital", brand: "DeepCool", price: 3500, type: "Air", fanSize: 120, fanCount: 1, hasRGB: true, supportedSockets: ["LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "Thermalright Assassin X 120", brand: "Thermalright", price: 1800, type: "Air", fanSize: 120, fanCount: 1, hasRGB: false, supportedSockets: ["LGA1700", "AM4", "AM5"]),
    Cooler(name: "Be Quiet! Pure Rock 2", brand: "Be Quiet!", price: 3600, type: "Air", fanSize: 120, fanCount: 1, hasRGB: false, supportedSockets: ["LGA1151", "LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "Vetroo V5", brand: "Vetroo", price: 2800, type: "Air", fanSize: 120, fanCount: 1, hasRGB: true, supportedSockets: ["LGA1200", "LGA1700", "AM4"]), // Intentionally missing AM5

    // ------------------------------------------
    // HIGH-END AIR (Dual Tower - Workstation Grade)
    // ------------------------------------------
    Cooler(name: "DeepCool AK620", brand: "DeepCool", price: 5800, type: "Dual Tower Air", fanSize: 120, fanCount: 2, hasRGB: false, supportedSockets: ["LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "Thermalright Peerless Assassin 120", brand: "Thermalright", price: 4200, type: "Dual Tower Air", fanSize: 120, fanCount: 2, hasRGB: false, supportedSockets: ["LGA1700", "AM4", "AM5"]),
    Cooler(name: "Noctua NH-D15 chromax.black", brand: "Noctua", price: 10500, type: "Dual Tower Air", fanSize: 140, fanCount: 2, hasRGB: false, supportedSockets: ["LGA1151", "LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "Be Quiet! Dark Rock Pro 4", brand: "Be Quiet!", price: 8500, type: "Dual Tower Air", fanSize: 135, fanCount: 2, hasRGB: false, supportedSockets: ["LGA1151", "LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "Scythe Fuma 3", brand: "Scythe", price: 5500, type: "Dual Tower Air", fanSize: 120, fanCount: 2, hasRGB: false, supportedSockets: ["LGA1700", "AM4", "AM5"]),

    // ------------------------------------------
    // ENTRY LIQUID COOLING (240mm AIO)
    // ------------------------------------------
    Cooler(name: "Cooler Master MasterLiquid ML240L V2", brand: "Cooler Master", price: 6500, type: "240mm AIO", fanSize: 120, fanCount: 2, hasRGB: true, supportedSockets: ["LGA1151", "LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "DeepCool LE520", brand: "DeepCool", price: 7200, type: "240mm AIO", fanSize: 120, fanCount: 2, hasRGB: true, supportedSockets: ["LGA1700", "AM4", "AM5"]),
    Cooler(name: "NZXT Kraken 240", brand: "NZXT", price: 12500, type: "240mm AIO", fanSize: 120, fanCount: 2, hasRGB: true, supportedSockets: ["LGA1700", "LGA1200", "AM4", "AM5"]),
    Cooler(name: "Corsair iCUE H100i Elite Capellix", brand: "Corsair", price: 13800, type: "240mm AIO", fanSize: 120, fanCount: 2, hasRGB: true, supportedSockets: ["LGA1151", "LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "Arctic Liquid Freezer II 240", brand: "Arctic", price: 9500, type: "240mm AIO", fanSize: 120, fanCount: 2, hasRGB: false, supportedSockets: ["LGA1200", "LGA1700", "AM4", "AM5"]),

    // ------------------------------------------
    // HIGH-END LIQUID COOLING (280mm AIO)
    // ------------------------------------------
    Cooler(name: "NZXT Kraken 280", brand: "NZXT", price: 14500, type: "280mm AIO", fanSize: 140, fanCount: 2, hasRGB: true, supportedSockets: ["LGA1700", "LGA1200", "AM4", "AM5"]),
    Cooler(name: "Corsair iCUE H115i RGB Elite", brand: "Corsair", price: 15200, type: "280mm AIO", fanSize: 140, fanCount: 2, hasRGB: true, supportedSockets: ["LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "Arctic Liquid Freezer II 280", brand: "Arctic", price: 11000, type: "280mm AIO", fanSize: 140, fanCount: 2, hasRGB: false, supportedSockets: ["LGA1700", "AM4", "AM5"]),
    Cooler(name: "Be Quiet! Pure Loop 280mm", brand: "Be Quiet!", price: 12500, type: "280mm AIO", fanSize: 140, fanCount: 2, hasRGB: false, supportedSockets: ["LGA1200", "LGA1700", "AM4", "AM5"]),

    // ------------------------------------------
    // EXTREME LIQUID COOLING (360mm AIO - For the i9s and R9s)
    // ------------------------------------------
    Cooler(name: "DeepCool LS720 360mm", brand: "DeepCool", price: 11500, type: "360mm AIO", fanSize: 120, fanCount: 3, hasRGB: true, supportedSockets: ["LGA1700", "AM4", "AM5"]),
    Cooler(name: "Cooler Master MasterLiquid PL360 Flux", brand: "Cooler Master", price: 14500, type: "360mm AIO", fanSize: 120, fanCount: 3, hasRGB: true, supportedSockets: ["LGA1200", "LGA1700", "AM4", "AM5"]),
    Cooler(name: "NZXT Kraken Elite 360", brand: "NZXT", price: 24000, type: "360mm AIO", fanSize: 120, fanCount: 3, hasRGB: true, supportedSockets: ["LGA1700", "AM4", "AM5"]),
    Cooler(name: "Corsair iCUE H150i Elite LCD XT", brand: "Corsair", price: 26500, type: "360mm AIO", fanSize: 120, fanCount: 3, hasRGB: true, supportedSockets: ["LGA1700", "AM4", "AM5"]),
    Cooler(name: "Arctic Liquid Freezer III 360", brand: "Arctic", price: 13500, type: "360mm AIO", fanSize: 120, fanCount: 3, hasRGB: false, supportedSockets: ["LGA1700", "AM5"]), // Modern brackets only
    Cooler(name: "Lian Li Galahad II Trinity 360", brand: "Lian Li", price: 16000, type: "360mm AIO", fanSize: 120, fanCount: 3, hasRGB: true, supportedSockets: ["LGA1700", "AM4", "AM5"]),
    Cooler(name: "ASUS ROG Ryujin III 360", brand: "ASUS", price: 32000, type: "360mm AIO", fanSize: 120, fanCount: 3, hasRGB: true, supportedSockets: ["LGA1700", "AM5"]),

    // ------------------------------------------
    // GOD-TIER LIQUID COOLING (420mm AIO)
    // ------------------------------------------
    Cooler(name: "Arctic Liquid Freezer II 420", brand: "Arctic", price: 15500, type: "420mm AIO", fanSize: 140, fanCount: 3, hasRGB: false, supportedSockets: ["LGA1700", "AM4", "AM5"]),
    Cooler(name: "Corsair iCUE H170i Elite LCD", brand: "Corsair", price: 29500, type: "420mm AIO", fanSize: 140, fanCount: 3, hasRGB: true, supportedSockets: ["LGA1700", "AM4", "AM5"]),
  ];

}