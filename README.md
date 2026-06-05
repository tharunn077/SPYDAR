# SPYDAR 🕷️💻
**Smart PC Yield, Diagnostics & Assembly Resolver**

![Flutter](https://img.shields.io/badge/Framework-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Language-Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)

SPYDAR is a high-fidelity, cross-platform mobile application that functions as a professional PC Building Simulator and diagnostic tool. It bridges the complexity gap in modern computer architecture by transforming static hardware specifications into a visual, rule-based engineering sandbox. 

---

## 📸 Screenshots

*(Replace the placeholder links below with the actual paths to your images once you upload them to the repository)*

| Assembly Dashboard | Bottleneck Diagnostics | SPYDAR OS Vault | Campaign Mode |
| :---: | :---: | :---: | :---: |
| <img src="link_to_assembly_image.png" width="200"/> | <img src="link_to_diagnostic_image.png" width="200"/> | <img src="link_to_vault_image.png" width="200"/> | <img src="link_to_campaign_image.png" width="200"/> |

---

## 📱 Interactive UI & Controls

SPYDAR is designed with a highly tactile, mobile-first interface, stepping away from traditional web-based list pickers. 

* **Tap to Select:** The core assembly loop utilizes a streamlined "tap to select" architecture. Users tap an empty component node on the dashboard to instantly open the categorized hardware inventory, allowing for rapid build prototyping.
* **Hold to View Details:** Long-pressing any hardware component inside the inventory triggers a deep-dive diagnostic panel. This reveals critical secondary specifications (e.g., PCIe generation, exact VRAM count, or RAM timing speeds) before the user commits to equipping the part.
* **Gyroscope Parallax Engine:** The application utilizes the physical device's gyroscopic sensors to create a subtle, 3D parallax effect on the background and component nodes. This creates a deeply immersive "cockpit" feel, giving depth to the simulation environment as the user tilts their device.

---

## ✨ Core Features & The Heuristic Engine

* **Heuristic Resolver Engine:** A deterministic algorithm that actively enforces physical and electrical laws. It instantly detects socket mismatches, invalid RAM generations (DDR4 vs. DDR5), and calculates true aggregate power consumption (including precise motherboard and liquid pump overheads).
* **Yield Prediction Module:** Calculates synthetic gaming performance and system bottlenecks. The engine normalizes raw CPU (Geekbench) and GPU (3DMark Time Spy) scores to a 100-point scale.
* **SPYDAR OS & The Vault:** A simulated post-build desktop environment featuring live telemetry and persistent JSON-based rig saving.
* **SPYDAR Labs & Campaign Mode:** Features a comparative A/B testing module and gamified "Spider-verse" scenario missions requiring users to balance target FPS thresholds against strict budgets.

---

## 🛠️ Technology Stack

* **Presentation Layer:** Flutter SDK (providing a highly responsive, 60 FPS UI with custom painting and animations).
* **Logic Layer:** Dart (handling asynchronous execution of the Heuristic Resolver and Bottleneck calculations).
* **Data Persistence:** Local JSON Serialization & Shared Preferences (Offline-first architecture).

---

## 🚀 How to Run (Installation & Setup)

To run SPYDAR locally on your Android device or emulator:

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/tharunn077/SPYDAR.git](https://github.com/tharunn077/SPYDAR.git)
