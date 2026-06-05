import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/component_model.dart';

// ✅ NEW: Global Memory Cache to remember filters even when menu is closed
class SortStateCache {
  static final Map<String, Map<String, dynamic>> filters = {};
}

class EmbeddedSortMenu extends StatefulWidget {
  final String slotType;
  final List<dynamic> allItems; 
  final Color themeColor;
  final Function(List<dynamic>) onApply; 
  final VoidCallback onClose;            

  const EmbeddedSortMenu({
    super.key,
    required this.slotType,
    required this.allItems,
    required this.themeColor,
    required this.onApply,
    required this.onClose,
  });

  @override
  State<EmbeddedSortMenu> createState() => _EmbeddedSortMenuState();
}

class _EmbeddedSortMenuState extends State<EmbeddedSortMenu> {
  final ScrollController _sortController = ScrollController();

  // --- GENERAL FILTERS ---
  late RangeValues _priceRange;
  double _minPrice = 0;
  double _maxPrice = 100000;
  bool _isInitialized = false;

  // --- CPU FILTERS ---
  List<String> _selectedCpuBrands = [];
  List<String> _selectedSockets = [];
  List<int> _selectedCores = [];
  double _minClock = 0.0;
  double _minTdp = 0.0; 
  double _maxTdpFound = 300.0;

  // --- RAM FILTERS ---
  List<String> _selectedRamTypes = [];
  double _minRamSpeed = 0.0;
  List<int> _selectedCapacities = [];
  List<int> _selectedModules = [];

  // --- MOBO FILTERS ---
  List<String> _selectedMoboBrands = [];
  List<String> _selectedMemoryTypes = [];
  String _wifiPreference = "Any";
  int _minM2Slots = 0;

  // --- GPU FILTERS ---
  List<String> _selectedGpuBrands = [];
  List<int> _selectedVram = [];
  List<String> _selectedUpscaling = [];
  double _minGpuClock = 0.0;
  double _maxGpuClockFound = 3000.0;

  // --- STORAGE FILTERS ---
  List<String> _selectedStorageBrands = [];
  List<String> _selectedStorageTypes = [];
  List<String> _selectedStorageFormats = [];
  List<int> _selectedStoragePcieGens = [];
  List<int> _selectedStorageCapacities = [];
  double _minReadSpeed = 0.0;
  double _maxReadSpeedFound = 15000.0;

  // --- PSU FILTERS ---
  List<String> _selectedPsuBrands = [];
  List<String> _selectedEfficiencies = [];
  String _modularPreference = "Any"; 
  double _minWattage = 0.0;
  double _maxWattageFound = 2000.0;

  // --- COOLER FILTERS ---
  List<String> _selectedCoolerBrands = [];
  List<String> _selectedCoolerTypes = [];
  List<int> _selectedFanSizes = [];
  List<int> _selectedFanCounts = [];
  String _rgbPreference = "Any"; 

  @override
  void initState() {
    super.initState();
    _initializeData();   // Setup defaults & max values
    _restoreFilters();   // Overwrite with memory if exists
  }

  @override
  void dispose() {
    _sortController.dispose();
    super.dispose();
  }

  // ✅ HELPER: Saves all current selections to the Cache
  void _saveFilters() {
    SortStateCache.filters[widget.slotType] = {
      'priceRange': _priceRange,
      'cpuBrands': _selectedCpuBrands,
      'sockets': _selectedSockets,
      'cores': _selectedCores,
      'minClock': _minClock,
      'minTdp': _minTdp,
      'ramTypes': _selectedRamTypes,
      'minRamSpeed': _minRamSpeed,
      'capacities': _selectedCapacities,
      'modules': _selectedModules,
      'moboBrands': _selectedMoboBrands,
      'memoryTypes': _selectedMemoryTypes,
      'wifiPref': _wifiPreference,
      'minM2': _minM2Slots,
      'gpuBrands': _selectedGpuBrands,
      'vram': _selectedVram,
      'upscaling': _selectedUpscaling,
      'minGpuClock': _minGpuClock,
      'storageBrands': _selectedStorageBrands,
      'storageTypes': _selectedStorageTypes,
      'storageFormats': _selectedStorageFormats,
      'storagePcie': _selectedStoragePcieGens,
      'storageCaps': _selectedStorageCapacities,
      'minRead': _minReadSpeed,
      'psuBrands': _selectedPsuBrands,
      'efficiencies': _selectedEfficiencies,
      'modularity': _modularPreference,
      'minWatt': _minWattage,
      'coolerBrands': _selectedCoolerBrands,
      'coolerTypes': _selectedCoolerTypes,
      'fanSizes': _selectedFanSizes,
      'fanCounts': _selectedFanCounts,
      'rgbPref': _rgbPreference,
    };
  }

  // ✅ HELPER: Loads selections from Cache
  void _restoreFilters() {
    final cache = SortStateCache.filters[widget.slotType];
    if (cache != null) {
      setState(() {
        _priceRange = cache['priceRange'] ?? _priceRange;
        _selectedCpuBrands = List<String>.from(cache['cpuBrands'] ?? []);
        _selectedSockets = List<String>.from(cache['sockets'] ?? []);
        _selectedCores = List<int>.from(cache['cores'] ?? []);
        _minClock = cache['minClock'] ?? 0.0;
        _minTdp = cache['minTdp'] ?? 0.0;
        
        _selectedRamTypes = List<String>.from(cache['ramTypes'] ?? []);
        _minRamSpeed = cache['minRamSpeed'] ?? 0.0;
        _selectedCapacities = List<int>.from(cache['capacities'] ?? []);
        _selectedModules = List<int>.from(cache['modules'] ?? []);
        
        _selectedMoboBrands = List<String>.from(cache['moboBrands'] ?? []);
        _selectedMemoryTypes = List<String>.from(cache['memoryTypes'] ?? []);
        _wifiPreference = cache['wifiPref'] ?? "Any";
        _minM2Slots = cache['minM2'] ?? 0;
        
        _selectedGpuBrands = List<String>.from(cache['gpuBrands'] ?? []);
        _selectedVram = List<int>.from(cache['vram'] ?? []);
        _selectedUpscaling = List<String>.from(cache['upscaling'] ?? []);
        _minGpuClock = cache['minGpuClock'] ?? 0.0;
        
        _selectedStorageBrands = List<String>.from(cache['storageBrands'] ?? []);
        _selectedStorageTypes = List<String>.from(cache['storageTypes'] ?? []);
        _selectedStorageFormats = List<String>.from(cache['storageFormats'] ?? []);
        _selectedStoragePcieGens = List<int>.from(cache['storagePcie'] ?? []);
        _selectedStorageCapacities = List<int>.from(cache['storageCaps'] ?? []);
        _minReadSpeed = cache['minRead'] ?? 0.0;
        
        _selectedPsuBrands = List<String>.from(cache['psuBrands'] ?? []);
        _selectedEfficiencies = List<String>.from(cache['efficiencies'] ?? []);
        _modularPreference = cache['modularity'] ?? "Any";
        _minWattage = cache['minWatt'] ?? 0.0;
        
        _selectedCoolerBrands = List<String>.from(cache['coolerBrands'] ?? []);
        _selectedCoolerTypes = List<String>.from(cache['coolerTypes'] ?? []);
        _selectedFanSizes = List<int>.from(cache['fanSizes'] ?? []);
        _selectedFanCounts = List<int>.from(cache['fanCounts'] ?? []);
        _rgbPreference = cache['rgbPref'] ?? "Any";
      });
    }
  }

  // ✅ HELPER: Clear all filters
  void _resetFilters() {
    SortStateCache.filters.remove(widget.slotType);
    setState(() {
      _selectedCpuBrands.clear(); _selectedSockets.clear(); _selectedCores.clear();
      _minClock = 0.0; _minTdp = 0.0;
      
      _selectedRamTypes.clear(); _selectedCapacities.clear(); _selectedModules.clear();
      _minRamSpeed = 0.0;
      
      _selectedMoboBrands.clear(); _selectedMemoryTypes.clear();
      _wifiPreference = "Any"; _minM2Slots = 0;
      
      _selectedGpuBrands.clear(); _selectedVram.clear(); _selectedUpscaling.clear();
      _minGpuClock = 0.0;
      
      _selectedStorageBrands.clear(); _selectedStorageTypes.clear(); _selectedStorageFormats.clear();
      _selectedStoragePcieGens.clear(); _selectedStorageCapacities.clear();
      _minReadSpeed = 0.0;
      
      _selectedPsuBrands.clear(); _selectedEfficiencies.clear();
      _modularPreference = "Any"; _minWattage = 0.0;
      
      _selectedCoolerBrands.clear(); _selectedCoolerTypes.clear(); _selectedFanSizes.clear(); _selectedFanCounts.clear();
      _rgbPreference = "Any";

      _initializeData(); // Resets price bounds dynamically
    });
  }

  void _initializeData() {
    double highestPrice = 1000;

    if (widget.slotType == "CPU") {
      double highestTdp = 65;
      for (var item in widget.allItems.cast<Cpu>()) {
        if (item.price > highestPrice) highestPrice = item.price.toDouble();
        if (item.tdp > highestTdp) highestTdp = item.tdp.toDouble();
      }
      _maxTdpFound = highestTdp;

    } else if (widget.slotType == "GPU") {
      double highestClock = 1500;
      for (var item in widget.allItems.cast<Gpu>()) {
        if (item.price > highestPrice) highestPrice = item.price.toDouble();
        if (item.clock > highestClock) highestClock = item.clock.toDouble();
      }
      _maxGpuClockFound = highestClock;

    } else if (widget.slotType == "STORAGE") {
      double highestRead = 500;
      for (var item in widget.allItems.cast<Storage>()) {
        if (item.price > highestPrice) highestPrice = item.price.toDouble();
        if (item.readSpeed > highestRead) highestRead = item.readSpeed.toDouble();
      }
      _maxReadSpeedFound = highestRead;

    } else if (widget.slotType == "PSU") {
      double highestWatt = 500;
      for (var item in widget.allItems.cast<Psu>()) {
        if (item.price > highestPrice) highestPrice = item.price.toDouble();
        if (item.wattage > highestWatt) highestWatt = item.wattage.toDouble();
      }
      _maxWattageFound = highestWatt;

    } else {
      for (var item in widget.allItems) {
        if (item.price > highestPrice) highestPrice = item.price.toDouble();
      }
    }

    _maxPrice = highestPrice;
    _priceRange = RangeValues(0, _maxPrice);
    _isInitialized = true;
  }

  List<String> get _getSockets => widget.allItems.map((e) => e.socket.toString()).toSet().toList()..sort();
  List<int> get _getCores => widget.allItems.map((e) => (e as Cpu).coreCount).toSet().toList()..sort();
  
  List<String> get _getRamTypes => widget.allItems.map((e) {
    if (e is Ram) return e.type;
    if (e is Motherboard) return e.memoryType;
    return "";
  }).toSet().toList()..sort();
  List<int> get _getCapacities => widget.allItems.map((e) => (e as Ram).capacity).toSet().toList()..sort();
  List<String> get _getBrands => widget.allItems.map((e) => e.brand.toString().toUpperCase()).toSet().toList()..sort();

  List<int> get _getVrams => widget.allItems.map((e) => (e as Gpu).vram).toSet().toList()..sort();
  List<String> get _getUpscalings => widget.allItems.map((e) => (e as Gpu).upscaling).toSet().toList()..sort();

  List<String> get _getStorageTypes => widget.allItems.map((e) => (e as Storage).type).toSet().toList()..sort();
  List<String> get _getStorageFormats => widget.allItems.map((e) => (e as Storage).format).toSet().toList()..sort();
  List<int> get _getStoragePcieGens => widget.allItems.map((e) => (e as Storage).pcieGen).toSet().toList()..sort();
  List<int> get _getStorageCapacities => widget.allItems.map((e) => (e as Storage).capacity).toSet().toList()..sort();

  List<String> get _getEfficiencies => widget.allItems.map((e) => (e as Psu).efficiency).toSet().toList()..sort();

  List<String> get _getCoolerTypes => widget.allItems.map((e) => (e as Cooler).type).toSet().toList()..sort();
  List<int> get _getFanSizes => widget.allItems.map((e) => (e as Cooler).fanSize).toSet().toList()..sort();
  List<int> get _getFanCounts => widget.allItems.map((e) => (e as Cooler).fanCount).toSet().toList()..sort();


  void _applyFilters() {
    _saveFilters(); // ✅ SAVE BEFORE APPLYING
    List<dynamic> filtered = [];

    if (widget.slotType == "CPU") {
      filtered = widget.allItems.cast<Cpu>().where((item) {
        if (item.price < _priceRange.start || item.price > _priceRange.end) return false;
        if (_selectedCpuBrands.isNotEmpty) {
          bool isAmd = item.name.toLowerCase().contains("amd") || item.name.toLowerCase().contains("ryzen");
          bool isIntel = item.name.toLowerCase().contains("intel") || item.name.toLowerCase().contains("core");
          if (_selectedCpuBrands.contains("AMD") && !isAmd && !_selectedCpuBrands.contains("Intel")) return false;
          if (_selectedCpuBrands.contains("Intel") && !isIntel && !_selectedCpuBrands.contains("AMD")) return false;
        }
        if (_selectedSockets.isNotEmpty && !_selectedSockets.contains(item.socket)) return false;
        if (_selectedCores.isNotEmpty && !_selectedCores.contains(item.coreCount)) return false;
        if (item.baseClock < _minClock) return false;
        if (item.tdp < _minTdp) return false; 
        return true;
      }).toList();

    } else if (widget.slotType == "RAM") {
      filtered = widget.allItems.cast<Ram>().where((item) {
        if (item.price < _priceRange.start || item.price > _priceRange.end) return false;
        if (_selectedRamTypes.isNotEmpty && !_selectedRamTypes.contains(item.type)) return false;
        if (_selectedCapacities.isNotEmpty && !_selectedCapacities.contains(item.capacity)) return false;
        if (_selectedModules.isNotEmpty && !_selectedModules.contains(item.modules)) return false;
        if (item.speed < _minRamSpeed) return false;
        return true;
      }).toList();

    } else if (widget.slotType == "MOTHER\nBOARD") {
      filtered = widget.allItems.cast<Motherboard>().where((item) {
        if (item.price < _priceRange.start || item.price > _priceRange.end) return false;
        if (_selectedMoboBrands.isNotEmpty && !_selectedMoboBrands.contains(item.brand.toUpperCase())) return false;
        if (_selectedSockets.isNotEmpty && !_selectedSockets.contains(item.socket)) return false;
        if (_selectedMemoryTypes.isNotEmpty && !_selectedMemoryTypes.contains(item.memoryType)) return false;
        if (_wifiPreference == "Yes" && !item.hasWifi) return false;
        if (_wifiPreference == "No" && item.hasWifi) return false;
        if (item.m2Slots < _minM2Slots) return false;
        return true;
      }).toList();

    } else if (widget.slotType == "GPU") {
      filtered = widget.allItems.cast<Gpu>().where((item) {
        if (item.price < _priceRange.start || item.price > _priceRange.end) return false;
        if (_selectedGpuBrands.isNotEmpty) {
          bool isNvidia = item.brand.toLowerCase().contains("nvidia");
          bool isAmd = item.brand.toLowerCase().contains("amd") || item.brand.toLowerCase().contains("radeon");
          if (_selectedGpuBrands.contains("NVIDIA") && !isNvidia) return false;
          if (_selectedGpuBrands.contains("AMD") && !isAmd) return false;
        }
        if (_selectedVram.isNotEmpty && !_selectedVram.contains(item.vram)) return false;
        if (_selectedUpscaling.isNotEmpty && !_selectedUpscaling.contains(item.upscaling)) return false;
        if (item.clock < _minGpuClock) return false;
        return true;
      }).toList();

    } else if (widget.slotType == "STORAGE") {
      filtered = widget.allItems.cast<Storage>().where((item) {
        if (item.price < _priceRange.start || item.price > _priceRange.end) return false;
        if (_selectedStorageBrands.isNotEmpty && !_selectedStorageBrands.contains(item.brand.toUpperCase())) return false;
        if (_selectedStorageTypes.isNotEmpty && !_selectedStorageTypes.contains(item.type)) return false;
        if (_selectedStorageFormats.isNotEmpty && !_selectedStorageFormats.contains(item.format)) return false;
        if (_selectedStorageCapacities.isNotEmpty && !_selectedStorageCapacities.contains(item.capacity)) return false;
        if (_selectedStoragePcieGens.isNotEmpty && !_selectedStoragePcieGens.contains(item.pcieGen)) return false;
        if (item.readSpeed < _minReadSpeed) return false;
        return true;
      }).toList();

    } else if (widget.slotType == "PSU") {
      filtered = widget.allItems.cast<Psu>().where((item) {
        if (item.price < _priceRange.start || item.price > _priceRange.end) return false;
        if (_selectedPsuBrands.isNotEmpty && !_selectedPsuBrands.contains(item.brand.toUpperCase())) return false;
        if (_selectedEfficiencies.isNotEmpty && !_selectedEfficiencies.contains(item.efficiency)) return false;
        if (_modularPreference == "Modular" && !item.isModular) return false;
        if (_modularPreference == "Non-Modular" && item.isModular) return false;
        if (item.wattage < _minWattage) return false;
        return true;
      }).toList();

    } else if (widget.slotType == "COOLER") {
      filtered = widget.allItems.cast<Cooler>().where((item) {
        if (item.price < _priceRange.start || item.price > _priceRange.end) return false;
        if (_selectedCoolerBrands.isNotEmpty && !_selectedCoolerBrands.contains(item.brand.toUpperCase())) return false;
        if (_selectedCoolerTypes.isNotEmpty && !_selectedCoolerTypes.contains(item.type)) return false;
        if (_selectedFanSizes.isNotEmpty && !_selectedFanSizes.contains(item.fanSize)) return false;
        if (_selectedFanCounts.isNotEmpty && !_selectedFanCounts.contains(item.fanCount)) return false;
        if (_rgbPreference == "Yes" && !item.hasRGB) return false;
        if (_rgbPreference == "No" && item.hasRGB) return false;
        return true;
      }).toList();
    }

    widget.onApply(filtered);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const SizedBox(); 

    return Column(
      children: [
        // --- HEADER WITH REFRESH BUTTON ---
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("SORT & FILTER",
                  style: GoogleFonts.orbitron(
                      color: widget.themeColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w900)),
              Row(
                children: [
                  GestureDetector(
                    onTap: _resetFilters, // ✅ NEW: CLEAR FILTERS BUTTON
                    child: const Icon(Icons.refresh, color: Colors.white54, size: 20),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      _saveFilters(); // Save state when user clicks 'X'
                      widget.onClose();
                    },
                    child: const Icon(Icons.close, color: Colors.white54, size: 20),
                  ),
                ],
              )
            ],
          ),
        ),

        // --- SCROLLABLE FILTERS ---
        Expanded(
          child: RawScrollbar(
            controller: _sortController, 
            thumbColor: widget.themeColor.withOpacity(0.5),
            radius: const Radius.circular(20),
            thickness: 4,
            padding: const EdgeInsets.only(right: 3,top: 7),
            minThumbLength: 50,
            thumbVisibility: true,
            interactive: true,
            child: SingleChildScrollView(
              controller: _sortController, 
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  if (widget.slotType == "CPU") _buildCpuFilters(),
                  if (widget.slotType == "RAM") _buildRamFilters(),
                  if (widget.slotType == "MOTHER\nBOARD") _buildMoboFilters(),
                  if (widget.slotType == "GPU") _buildGpuFilters(),
                  if (widget.slotType == "STORAGE") _buildStorageFilters(),
                  if (widget.slotType == "PSU") _buildPsuFilters(),
                  if (widget.slotType == "COOLER") _buildCoolerFilters(),
                  
                  const SizedBox(height: 15),
                  _buildSectionTitle("PRICE RANGE"),
                  _buildPriceSlider(),
                  
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),

        // --- APPLY BUTTON ---
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.themeColor.withOpacity(0.15),
              side: BorderSide(color: widget.themeColor, width: 1.5),
              minimumSize: const Size(250, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _applyFilters,
            child: Text("APPLY FILTERS", style: GoogleFonts.orbitron(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
          ),
        )
      ],
    );
  }

  // --- UI BUILDING BLOCKS ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 12),
      child: Text(title, style: GoogleFonts.roboto(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
    );
  }

  Widget _buildStyledSlider({required Widget child}) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 2.0, 
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0), 
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0), 
        activeTrackColor: widget.themeColor,
        inactiveTrackColor: Colors.white12,
        thumbColor: widget.themeColor,
        overlayColor: widget.themeColor.withOpacity(0.2),
      ),
      child: child,
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₹${_priceRange.start.toInt()}", style: GoogleFonts.orbitron(color: widget.themeColor, fontSize: 12, fontWeight: FontWeight.bold)),
            Text("₹${_priceRange.end.toInt()}", style: GoogleFonts.orbitron(color: widget.themeColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        _buildStyledSlider(
          child: RangeSlider(
            values: _priceRange,
            min: 0,
            max: _maxPrice == 0 ? 1000 : _maxPrice,
            divisions: 20,
            onChanged: (values) => setState(() => _priceRange = values),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Function(bool) onSelected) {
    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: FilterChip(
        label: Text(label, style: GoogleFonts.roboto(color: isSelected ? Colors.white : Colors.white70, fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        selected: isSelected,
        onSelected: onSelected,
        backgroundColor: Colors.white.withOpacity(0.05),
        selectedColor: widget.themeColor.withOpacity(0.2),
        checkmarkColor: widget.themeColor,
        side: BorderSide(color: isSelected ? widget.themeColor : Colors.white12, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        padding: EdgeInsets.zero,
      ),
    );
  }

  // --- COMPONENT SPECIFIC UIs ---
  
  Widget _buildCpuFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("BRAND"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: ["AMD", "Intel"].map((brand) => _buildFilterChip(brand, _selectedCpuBrands.contains(brand), (selected) {
            setState(() { selected ? _selectedCpuBrands.add(brand) : _selectedCpuBrands.remove(brand); });
          })).toList(),
        ),
        _buildSectionTitle("SOCKET"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getSockets.map((socket) => _buildFilterChip(socket, _selectedSockets.contains(socket), (selected) {
            setState(() { selected ? _selectedSockets.add(socket) : _selectedSockets.remove(socket); });
          })).toList(),
        ),
        _buildSectionTitle("CORES"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getCores.map((cores) => _buildFilterChip("$cores Cores", _selectedCores.contains(cores), (selected) {
            setState(() { selected ? _selectedCores.add(cores) : _selectedCores.remove(cores); });
          })).toList(),
        ),
        _buildSectionTitle("MINIMUM BASE CLOCK: ${_minClock.toStringAsFixed(1)} GHz"),
        _buildStyledSlider(
          child: Slider(
            value: _minClock,
            min: 0.0, max: 5.0, divisions: 10,
            onChanged: (val) => setState(() => _minClock = val),
          ),
        ),
        _buildSectionTitle("MINIMUM TDP: ${_minTdp.toInt()} W"),
        _buildStyledSlider(
          child: Slider(
            value: _minTdp,
            min: 0.0, max: _maxTdpFound == 0 ? 300 : _maxTdpFound, divisions: 15,
            onChanged: (val) => setState(() => _minTdp = val),
          ),
        ),
      ],
    );
  }

  Widget _buildRamFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("MEMORY TYPE"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getRamTypes.map((type) => _buildFilterChip(type, _selectedRamTypes.contains(type), (selected) {
            setState(() { selected ? _selectedRamTypes.add(type) : _selectedRamTypes.remove(type); });
          })).toList(),
        ),
        _buildSectionTitle("MINIMUM SPEED: ${_minRamSpeed.toInt()} MHz"),
        _buildStyledSlider(
          child: Slider(
            value: _minRamSpeed,
            min: 0, max: 8000, divisions: 16,
            onChanged: (val) => setState(() => _minRamSpeed = val),
          ),
        ),
        _buildSectionTitle("CAPACITY"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getCapacities.map((cap) => _buildFilterChip("${cap}GB", _selectedCapacities.contains(cap), (selected) {
            setState(() { selected ? _selectedCapacities.add(cap) : _selectedCapacities.remove(cap); });
          })).toList(),
        ),
        _buildSectionTitle("MODULES"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: [1, 2, 4].map((mod) => _buildFilterChip("x$mod", _selectedModules.contains(mod), (selected) {
            setState(() { selected ? _selectedModules.add(mod) : _selectedModules.remove(mod); });
          })).toList(),
        ),
      ],
    );
  }

  Widget _buildMoboFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("BRAND"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getBrands.map((brand) => _buildFilterChip(brand, _selectedMoboBrands.contains(brand), (selected) {
            setState(() { selected ? _selectedMoboBrands.add(brand) : _selectedMoboBrands.remove(brand); });
          })).toList(),
        ),
        _buildSectionTitle("SOCKET"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getSockets.map((socket) => _buildFilterChip(socket, _selectedSockets.contains(socket), (selected) {
            setState(() { selected ? _selectedSockets.add(socket) : _selectedSockets.remove(socket); });
          })).toList(),
        ),
        _buildSectionTitle("MEMORY SUPPORT"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getRamTypes.map((type) => _buildFilterChip(type, _selectedMemoryTypes.contains(type), (selected) {
            setState(() { selected ? _selectedMemoryTypes.add(type) : _selectedMemoryTypes.remove(type); });
          })).toList(),
        ),
        _buildSectionTitle("WIFI"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: ["Any", "Yes", "No"].map((pref) => _buildFilterChip(pref, _wifiPreference == pref, (selected) {
            setState(() => _wifiPreference = pref);
          })).toList(),
        ),
      ],
    );
  }

  Widget _buildGpuFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("CHIPSET BRAND"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: ["NVIDIA", "AMD"].map((brand) => _buildFilterChip(brand, _selectedGpuBrands.contains(brand), (selected) {
            setState(() { selected ? _selectedGpuBrands.add(brand) : _selectedGpuBrands.remove(brand); });
          })).toList(),
        ),
        _buildSectionTitle("VRAM (MEMORY)"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getVrams.map((vram) => _buildFilterChip("${vram}GB", _selectedVram.contains(vram), (selected) {
            setState(() { selected ? _selectedVram.add(vram) : _selectedVram.remove(vram); });
          })).toList(),
        ),
        _buildSectionTitle("UPSCALING TECH"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getUpscalings.map((tech) => _buildFilterChip(tech, _selectedUpscaling.contains(tech), (selected) {
            setState(() { selected ? _selectedUpscaling.add(tech) : _selectedUpscaling.remove(tech); });
          })).toList(),
        ),
        _buildSectionTitle("MINIMUM CORE CLOCK: ${_minGpuClock.toInt()} MHz"),
        _buildStyledSlider(
          child: Slider(
            value: _minGpuClock,
            min: 0.0, max: _maxGpuClockFound == 0 ? 3000 : _maxGpuClockFound, divisions: 15,
            onChanged: (val) => setState(() => _minGpuClock = val),
          ),
        ),
      ],
    );
  }

  Widget _buildStorageFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("BRAND"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getBrands.map((brand) => _buildFilterChip(brand, _selectedStorageBrands.contains(brand), (selected) {
            setState(() { selected ? _selectedStorageBrands.add(brand) : _selectedStorageBrands.remove(brand); });
          })).toList(),
        ),
        _buildSectionTitle("STORAGE TYPE"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getStorageTypes.map((type) => _buildFilterChip(type, _selectedStorageTypes.contains(type), (selected) {
            setState(() { selected ? _selectedStorageTypes.add(type) : _selectedStorageTypes.remove(type); });
          })).toList(),
        ),
        _buildSectionTitle("FORM FACTOR"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getStorageFormats.map((format) => _buildFilterChip(format, _selectedStorageFormats.contains(format), (selected) {
            setState(() { selected ? _selectedStorageFormats.add(format) : _selectedStorageFormats.remove(format); });
          })).toList(),
        ),
        _buildSectionTitle("PCIE GENERATION"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getStoragePcieGens.map((gen) => _buildFilterChip(gen == 0 ? "SATA" : "Gen $gen", _selectedStoragePcieGens.contains(gen), (selected) {
            setState(() { selected ? _selectedStoragePcieGens.add(gen) : _selectedStoragePcieGens.remove(gen); });
          })).toList(),
        ),
        _buildSectionTitle("CAPACITY"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getStorageCapacities.map((cap) => _buildFilterChip(cap >= 1000 ? "${cap~/1000}TB" : "${cap}GB", _selectedStorageCapacities.contains(cap), (selected) {
            setState(() { selected ? _selectedStorageCapacities.add(cap) : _selectedStorageCapacities.remove(cap); });
          })).toList(),
        ),
        _buildSectionTitle("MINIMUM READ SPEED: ${_minReadSpeed.toInt()} MB/s"),
        _buildStyledSlider(
          child: Slider(
            value: _minReadSpeed,
            min: 0.0, max: _maxReadSpeedFound == 0 ? 10000 : _maxReadSpeedFound, divisions: 20,
            onChanged: (val) => setState(() => _minReadSpeed = val),
          ),
        ),
      ],
    );
  }

  Widget _buildPsuFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("BRAND"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getBrands.map((brand) => _buildFilterChip(brand, _selectedPsuBrands.contains(brand), (selected) {
            setState(() { selected ? _selectedPsuBrands.add(brand) : _selectedPsuBrands.remove(brand); });
          })).toList(),
        ),
        _buildSectionTitle("EFFICIENCY RATING"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getEfficiencies.map((eff) => _buildFilterChip(eff, _selectedEfficiencies.contains(eff), (selected) {
            setState(() { selected ? _selectedEfficiencies.add(eff) : _selectedEfficiencies.remove(eff); });
          })).toList(),
        ),
        _buildSectionTitle("MODULARITY"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: ["Any", "Modular", "Non-Modular"].map((pref) => _buildFilterChip(pref, _modularPreference == pref, (selected) {
            setState(() => _modularPreference = pref);
          })).toList(),
        ),
        _buildSectionTitle("MINIMUM WATTAGE: ${_minWattage.toInt()} W"),
        _buildStyledSlider(
          child: Slider(
            value: _minWattage,
            min: 0.0, max: _maxWattageFound == 0 ? 2000 : _maxWattageFound, divisions: 20,
            onChanged: (val) => setState(() => _minWattage = val),
          ),
        ),
      ],
    );
  }

  Widget _buildCoolerFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("BRAND"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getBrands.map((brand) => _buildFilterChip(brand, _selectedCoolerBrands.contains(brand), (selected) {
            setState(() { selected ? _selectedCoolerBrands.add(brand) : _selectedCoolerBrands.remove(brand); });
          })).toList(),
        ),
        _buildSectionTitle("COOLING TYPE"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getCoolerTypes.map((type) => _buildFilterChip(type, _selectedCoolerTypes.contains(type), (selected) {
            setState(() { selected ? _selectedCoolerTypes.add(type) : _selectedCoolerTypes.remove(type); });
          })).toList(),
        ),
        _buildSectionTitle("FAN SIZE"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getFanSizes.map((size) => _buildFilterChip("${size}mm", _selectedFanSizes.contains(size), (selected) {
            setState(() { selected ? _selectedFanSizes.add(size) : _selectedFanSizes.remove(size); });
          })).toList(),
        ),
        _buildSectionTitle("FAN COUNT"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _getFanCounts.map((count) => _buildFilterChip("$count Fans", _selectedFanCounts.contains(count), (selected) {
            setState(() { selected ? _selectedFanCounts.add(count) : _selectedFanCounts.remove(count); });
          })).toList(),
        ),
        _buildSectionTitle("RGB LIGHTING"),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: ["Any", "Yes", "No"].map((pref) => _buildFilterChip(pref, _rgbPreference == pref, (selected) {
            setState(() => _rgbPreference = pref);
          })).toList(),
        ),
      ],
    );
  }
}