# CornerBot – parts to buy

Based on remrc's cube (thing:6695891, github.com/remrc/Self-Balancing-Cube) and the build video (2024-07-14).

## Electronics
| Qty | Part | Note |
|---|---|---|
| 3 (+1 spare) | Nidec 24H brushless, built-in driver, 100-line encoder | 12 V variant, AliExpress |
| 1 | ESP32 DevKit (ESP32-WROOM-32, 30 or 38 pin) | check pins 4, 5, 13–19, 25–27, 32–35 are broken out |
| 1 | MPU6050 module (GY-521) | |
| 1 | 3S1P LiPo 450–500 mAh (11.1 V) | remrc uses T-plug (Deans) connector |
| 1 | LiPo balance charger (e.g. ISDT, SkyRC, or B3 for 3S) | |
| 1 | 5 V regulator: 7805 or small buck (MP1584 / Mini-360) | buck runs cooler |
| 1 | 5 V active buzzer | |
| 3 | WS2812B LEDs | pin 19, optional |
| 2 | Resistors for battery divider (e.g. 100 kΩ + 33 kΩ) | VBAT pin 34, max 3.3 V |
| ~8 | Resistors for encoder level shift (e.g. 10 kΩ + 20 kΩ per line) | only if encoder outputs 5 V |
| 1 | Power switch (rated > 3 A) | |
| 1 | Battery connector pair (T-plug / Deans) | match battery |
| 1 | Perfboard ~5×7 cm, pin headers | |
| 1 | Silicone wire (22–26 AWG), Dupont cables | |

## Mechanical
| Qty | Part | Note |
|---|---|---|
| ~0.5 kg | PLA filament | 50–60% infill, 0.2 mm |
| 96 + 96 | M4×10 **flat (countersunk) head** bolts + M4 nuts | wheel weights: 32 holes × 3 wheels, only flat head fits |
| ~60 + 60 | M3×8 flat (countersunk) head bolts + M3 nuts | frame sides to corners, nuts in corners |
| ~12 | M3×10 bolts | motor holders |
| 4 + 4 | M2×10 bolts + nuts | controller board |
| 1 | Thin packing foam | under battery |

## Tools
- Soldering iron, multimeter, screwdriver, USB cable for ESP32
- Phone with Bluetooth terminal app (calibration `c+` / `c-`)
