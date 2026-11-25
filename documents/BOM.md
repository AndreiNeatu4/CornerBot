# CornerBot – parts to buy

Based on remrc's cube (thing:6695891, github.com/remrc/Self-Balancing-Cube).

## Electronics
| Qty | Part | Note |
|---|---|---|
| 3 (+1 spare) | Nidec 24H brushless, built-in driver, 100-line encoder | 12 V variant, AliExpress |
| 1 | ESP32 DevKit (ESP32-WROOM-32, 30 or 38 pin) | check pins 4,5,13–19,25–27,32–35 are broken out |
| 1 | MPU6050 module (GY-521) | |
| 1 | 3S LiPo 500 mAh (11.1 V) | check size fits battery holder |
| 1 | LiPo balance charger (e.g. ISDT, SkyRC, or B3 for 3S) | |
| 1 | 5 V regulator: 7805 or small buck (MP1584 / Mini-360) | buck runs cooler |
| 1 | 5 V active buzzer | |
| 3 | WS2812B LEDs (or 3-LED strip piece) | pin 19 |
| 2 | Resistors for battery divider (e.g. 100 kΩ + 33 kΩ) | VBAT pin 34, max 3.3 V |
| ~8 | Resistors for encoder level shift (e.g. 10 kΩ + 20 kΩ per line) | only if encoder outputs 5 V |
| 1 | Power switch (rated > 3 A) | |
| 1 | Battery connector pair (XT30 or JST-XH matching battery) | |
| 1 | Perfboard or protoboard ~5×7 cm, pin headers | |
| 1 | Silicone wire (22–26 AWG), Dupont cables | |

## Mechanical
| Qty | Part | Note |
|---|---|---|
| ~0.5 kg | PLA filament | 50–60% infill, 0.2 mm |
| 1 set | M3 screws (8–16 mm) and nuts | |
| ? | Rim weights for wheel groove | check thingiverse description |

## Tools
- Soldering iron, multimeter, USB cable for ESP32
- Phone with Bluetooth terminal app (calibration `c+` / `c-`)
