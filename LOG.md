# Log

## Week 7
- Repo created.
- MATLAB R2026b installed (Andrei).
- Edge model (plain MATLAB): cubeParams, motor, dynamics, filters, encoder.
- Classical edge gains balance 30 s with encCPR = 200; fail at 100 (wheel drift). Parameters are estimates.
- Parameters from remrc STL files (thing:6695891) and firmware (github.com/remrc/Self-Balancing-Cube, esp32_cube_enc).
- Model now matches firmware: x4 encoder, motors_speed += speed/5, Motor3_control adds wheel speed, gyro integrated at /65.536.
- Edge balances 10/10 starts (±2°) for any rim mass. Push survival depends on Tstall (0.05 fails, 0.1 survives 0.1 N m push).
- To measure: rim weight mass, Nidec 24H stall torque and no-load speed, encoder PPR, total mass.
- Motor: Nidec 24H (AliExpress). Seller: 100-line 2-ch encoder, 3020 rpm no-load at 12 V. Stall torque still unknown.
- DDPG edge agent (2x64): first run with ±2° starts did not learn (falls in ~0.2 s). With ±0.5° starts and noise 0.1 it reached avg reward 1900/2000 in 724 episodes.
- DDPG vs classical: ±0.5° starts 10/10 both; ±2° starts 3/10 vs 10/10; pushes: both survive 0.05 N m, both fall at 0.08 N m. DDPG uses ~2.5x more PWM.
