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
