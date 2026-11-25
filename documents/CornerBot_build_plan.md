# CornerBot – build plan (weeks 7–14)

Team: Andrei Neațu (hardware, simulation, integration)

## The approach

There are three tracks, and each one feeds the others:

1. **Simulation (Andrei):** a model that behaves like the real cube. Everything else is trained and tested on it.
2. **Learning:** RL agents trained on that model.
3. **Evaluation:** one shared test that every controller has to pass, plus the demo app.

Hardware runs alongside. It's useful but not required. Its main job is to check the simulation against reality, and to earn bonus points at the end.

**Key design choice:** the simulation uses the **same signals and units as the real firmware**:
- a 15 ms control step
- PWM commands from −255 to +255
- angles that go through the same complementary filter (0.996 gyroscope, 0.004 accelerometer)

That way the classical controller's gains work unchanged in simulation, and a trained agent can later move to the ESP32 without being retranslated.

### Reference values from the cube firmware

| Item | Value |
|---|---|
| Control loop | 15 ms (~67 Hz) |
| Motor command | PWM 20 kHz, 8-bit, −255…+255 |
| IMU | MPU6050, ±2 g, ±250°/s |
| Angle filter | angle = 0.996·(gyro-integrated angle) + 0.004·(accelerometer angle) |
| Gyro rate filter | low-pass, α = 0.7 |
| Corner gains | K1 = 180, K2 = 30, K3 = 1.6, K4 = 0.008; yaw zK2 = 8, zK3 = 0.3 |
| Edge gains | eK1 = 190, eK2 = 31, eK3 = 2.5, eK4 = 0.014 |
| Control law | u = K1·angle + K2·gyroRate + K3·wheelSpeed + K4·accumulatedWheelSpeed |
| Takes over | within 0.4° of the corner balance point, 0.3° on an edge |
| Gives up (fall) | tilt > 7° |
| 3-motor mixing | m1 = (0.5X − 0.866Y)/1.37 + Z · m2 = (0.5X + 0.866Y)/1.37 + Z · m3 = −X/1.37 + Z |
| Battery | 3S LiPo 500 mAh; warning between 8 V and 9.5 V |

## Week 7–8: setup and the edge model

**Everyone, this week:**
- **Shared Git repo** with the folder layout from the project guide: `README.md`, `LOG.md`, `main.mlx`, `data/`, `functions/`, `models/`, `simulink/`, `app/`, `documents/`.
- **Check your MATLAB licence covers:**
  - Simulink
  - Simscape Multibody
  - Reinforcement Learning Toolbox
  - Deep Learning Toolbox
  - Control System Toolbox
  - Parallel Computing Toolbox (optional, speeds up training)

**Andrei: the edge model**
- **`cubeParams.m`:** cube side and mass, wheel mass and radius (giving wheel inertia), and motor constants from the Nidec 24H datasheet. Use estimates for now, and replace them with measurements when the parts arrive.
- **Edge physics as a plain MATLAB function**, not Simscape: a pendulum on its edge driven by one reaction wheel. It's a few lines of equations, and it trains about 100× faster than Simscape.
- **Motor model:** PWM → voltage (battery × u/255) → torque, minus the back-EMF from wheel speed.
- **Make it realistic:** add sensor noise and the complementary filter.
- **Check:** run the edge controller (190 / 31 / 2.5 / 0.014). If it balances, the model is roughly right. If not, the parameters or units are off, and that's the first thing to fix.

## Week 8–9: the first agent

**Training on the edge model**
- **Environment:** `rlFunctionEnv` wrapped around the edge function.
  - Observations: tilt angle, tilt rate, wheel speed, accumulated wheel speed. These are the same four values the classical controller uses.
  - Action: one value in [−1, 1], scaled to ±255.
  - Step: 15 ms. Episode: 2,000 steps (30 s). It ends early when tilt passes 7°.
- **Reward:** `+1 per step − a·tilt² − b·u² − c·wheelSpeed²`, and **−100** for a fall. Expect to tune a, b and c several times.
- **Agent:** DDPG first, with a **small network** (2 layers × 64 neurons), so it could later run on the ESP32.
- **Week 9:** compare DDPG, TD3 and SAC in **Experiment Manager** on the same reward. Pick the best one and record why, for the report.

## Week 9–10: the corner model

**Andrei: the 3D model in Simscape Multibody**
- **Bodies:** a cube body on a point contact (a spherical joint at the corner) and three wheels at 120°.
- **Mixing:** commands go through the same 3-motor mixing as the firmware.
- **Check:** run the corner controller (180 / 30 / 1.6 / 0.008, plus yaw damping 8 / 0.3). It should balance.
- **3D view:** Mechanics Explorer shows the cube moving, which is also useful for the demo.

Reuse the reward, this time with 3 actions, and train with `rlSimulinkEnv`. This is slower, so use parallel training if available.

## Week 8–11: tests and demo

- **`evaluate.m`:** one function that takes **any controller** (classical, DDPG, SAC…) and runs:
  - 20 fixed starting tilts up to ±3°, with `rng(0)`
  - 10 pushes, each a short torque impulse that tilts the cube up to 4°
  - It returns the success metrics: time upright (target ≥ 30 s), average tilt (target < 1°), pushes survived (target ≥ 8/10), and motor effort (agent ≤ 1.2× the classical controller).
- **Comparison table and plots**, generated automatically, for the Milestone 2 slides and the report.
- **Week 11, App Designer demo:**
  - pick a controller
  - press a "Push" button
  - watch the tilt and wheel speeds live, next to a 3D cube

## Hardware, when the parts arrive (Andrei)

1. **Assemble** following the wiring diagram, including the encoder connections.
2. **Test the motors** with a motor test sketch, then flash the main firmware unchanged.
3. **Calibrate** over Bluetooth (device name "ESP32-Cube"):
   - Send `c+` to start calibration.
   - Hold the cube on its **corner** and send `c-`.
   - Then hold it on an **edge** and send `c-` again.

   This saves one corner and one edge position to memory.
4. **Add logging:** send angle, gyroscope rate, wheel speeds and PWM over serial or Bluetooth every loop. Use it to compare the real cube against the simulation; it's also strong material for the report.
5. **Bonus, week 11+:** copy the trained actor's weights into the firmware as a small C function, and replace the line that computes the motor command. Do the edge first.

## Deadlines

| Week | Must be done |
|---|---|
| 8 | Edge model balances with the classical gains; first DDPG training running |
| 9 | Agent comparison; `evaluate.m` working on the edge |
| 10 | Corner model balancing with the classical gains; agent training on it |
| 11 | Demo app; robustness tests with randomised parameters |
| **12** | **Milestone 2:** agent vs. classical controller on the corner, with numbers |
| 13 | Technical report (15–25 pages), project files, 2–3 min video |
| **14** | **Final defence** |

**Biggest risk:** the corner model in week 10. If it slips, Milestone 2 can still show the full edge results, and the corner as work in progress.

## Questions to settle as a team

- **Size:** what are the cube's planned dimensions, or are you 3D-printing a frame? The simulation needs a first estimate.
- **MATLAB:** which version and toolboxes do you have? This decides between `rlFunctionEnv` and Simulink for the edge model.
- **Where the code lives:** who creates the Git repo, and where?
