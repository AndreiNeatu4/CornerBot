# CornerBot – Milestone 1 talking script

10 minutes total. Slide order: 1 Cover · 2 Problem · 3 Specification · 4 Data · 5 Where we are · 6 Success targets · 7 Risks · 8 Plan · 9 Team · 10 Questions.

| Speaker | Slides | Time |
|---|---|---|
| Andrei | 1, 2, 3 (and 10) | ~3 min |
| Andrei | 4, 5 | ~3 min |
| Andrei | 6, 7, 8 | ~3 min |
| Andrei | 9 | ~45 s |

---

## Andrei — slides 1–3

### Slide 1 · Cover (~20 s)

> Good morning. I am Andrei Neațu, and my project is **CornerBot**: a cube that balances on a single corner, controlled by a reinforcement learning agent. It falls under topic **T12**, a robot that learns by itself through reinforcement.
>
> I'll cover the problem and the hardware, the data and where the model stands, how we measure success, the risks and the plan.

### Slide 2 · The problem (~70 s)

> A cube standing on one corner is a **3D inverted pendulum**. Left alone, it falls within about a second.
>
> Inside the cube there are **three reaction wheels**, each driven by its own brushless motor, mounted 120° apart. When a motor speeds its wheel up in one direction, the cube body is pushed in the opposite direction. That reaction torque is the only thing that keeps it up: there is nothing pushing against the table.
>
> The cube has two balancing modes. On an **edge**, only one wheel works and it is a problem on one axis. On a **corner**, all three wheels work together, and it becomes a full 3D problem.
>
> The controller runs every **15 milliseconds**, so about **67 times per second**. At every step it decides how hard to drive each motor.
>
> The classical solution is a linear controller with hand-tuned gains. Our question is: **can an RL agent learn this policy by itself in simulation, and can it do better, especially when the cube is pushed hard?** Our inspiration is the Cubli project from ETH Zürich.

### Slide 3 · Specification (~80 s)

> Here is our specification in PEAS form, with the real hardware we are building.
>
> - **Controller:** an **ESP32** microcontroller. It also has Bluetooth, which we use to calibrate the cube.
> - **Sensor:** an **MPU6050** IMU, with an accelerometer set to **±2 g** and a gyroscope set to **±250°/s**.
>   - The tilt angle comes from a **complementary filter**: every loop it takes **99.6%** from the integrated gyroscope and **0.4%** from the accelerometer angle.
>   - The gyroscope is fast but drifts, the accelerometer is noisy but doesn't drift, so together they give a clean angle.
>   - At startup the cube averages **512 gyroscope samples** per axis to remove the sensor offset.
> - **Actuators:** three **Nidec 24H brushless motors**. Each gets a direction signal and a **20 kHz PWM** signal with **8-bit resolution**, so a command from **−255 to +255**. Each motor also has an **encoder**, which gives us the wheel speed.
> - **Power:** a **3-cell LiPo, 500 mAh**, 11.1 V nominal, with a 5 V regulator. A buzzer warns when the battery drops below **9.5 V**.
> - **Performance:** time upright, tilt, motor effort and recovery after a push.
> - **Environment:** a Simulink / Simscape model matched to this cube.
>
> So we know exactly what signals a real controller has to work with. Next: how we turn that into data for the agent.

---

## Andrei — slides 4–5

### Slide 4 · The data (~100 s)

> In reinforcement learning there is no fixed dataset. **Our data is experience**: what the agent collects by trying things in the simulation, step by step.
>
> - **What the agent sees:**
>   - the tilt angles on X and Y
>   - the filtered gyroscope rates
>   - the speed of each wheel from the encoders
>
>   These are **exactly the signals the real cube measures**, so an agent trained in simulation could later run on the real cube.
> - **What it controls:** every **15 ms**, one command per motor, clipped to **−255…+255**, the same range as the real PWM. On the edge that's one motor, on the corner all three.
> - **What it is paid for:**
>   - a reward for every step it stays upright
>   - a penalty for tilt and for wasted motor effort
>   - a large penalty when the tilt passes **7°**, because that's where the real cube switches its motors off and counts it as a fall
>
> Each episode starts with a **random tilt of up to ±3°** and lasts **30 seconds, which is 2,000 control steps**.
>
> To put the ±3° in context: the classical controller on the real cube only takes over when the cube is already within **0.4°** of the balance point on a corner, or **0.3°** on an edge. So we are asking the agent to catch the cube from much further away.
>
> We **train** on random starting points and **test** on a fixed set of starts and pushes the agent has never seen, with a fixed random seed, `rng(0)`, so the results can be reproduced.

### Slide 5 · Where we are (~80 s)

> Here is where we honestly are at week 7.
>
> - **Parts:** the parts for the prototype are **ordered**: the ESP32, the MPU6050, the three Nidec motors with encoders and the battery.
> - **Simulation models:** they **don't depend on the parts**, so they are already **in progress**. There are two:
>   - the cube on an **edge** with one wheel, a 2D problem
>   - the full **corner** model with three wheels, in Simscape Multibody
> - **First agent:** a **DDPG** agent, which works with continuous actions like our motor commands. It is **designed**: we have decided what it observes, what it controls and how it is rewarded. **Training starts in week 8**, on the edge model.
> - **Hardware controller:** when the parts arrive, we assemble the cube and run the **classical controller** on it, which gives us a real reference.
>
> Why the edge first? It's the same problem on one axis with one motor, so training is much faster and we can debug the reward before moving to the corner.
>
> Next: how we'll decide whether it works.

---

## Andrei — slides 6–8

### Slide 6 · Success targets (~80 s)

> We set three measurable targets, checked on the test set the agent never trained on:
>
> 1. **At least 30 seconds upright on the corner** from every test start. That's **2,000 decisions in a row** without a fall.
> 2. **An average tilt under 1°.** A fall is anything past 7°, so 1° is a tight band.
> 3. **Recovering from at least 8 of 10 test pushes**, each tilting the cube up to **4°**.
>
> Doing nothing scores zero on all three, because the cube falls within about a second.
>
> Our **baseline** is the classical controller for this cube, a linear state feedback:
> **u = K₁·angle + K₂·rate + K₃·wheel speed + K₄·accumulated wheel speed.**
>
> | Gains | K₁ | K₂ | K₃ | K₄ | Yaw damping |
> |---|---|---|---|---|---|
> | Corner | 180 | 30 | 1.6 | 0.008 | 8 and 0.3 |
> | Edge | 190 | 31 | 2.5 | 0.014 | none |
>
> We run this same controller in our simulation, on the same test set. To keep it fair, the agent may use at most **1.2 times** the baseline's motor effort, so it can't win just by running the motors harder.

### Slide 7 · Risks (~60 s)

> If the model makes a mistake, the cube falls. Here are our main risks and what we do about them.
>
> - **Training doesn't converge on the corner.** Our backup is the edge version plus the comparison with the classical controller, which already meets the basic level of T12.
> - **It only works in our exact simulation.** We randomise mass, friction, sensor noise and motor delay during training. That's also one of the T12 extensions.
> - **The agent is too heavy for the ESP32.** It has to compute its answer well inside the 15 ms loop, so we keep the network small.
> - **The agent exploits the reward.** We penalise effort and wheel speed, and we watch how it behaves, not only the score.
> - **A fall on the real cube.** The controller switches the motors off past 7°, and the buzzer warns below 9.5 V, before the battery is damaged.

### Slide 8 · Plan (~50 s)

> Our plan follows the course calendar.
>
> | Week | Work |
> |---|---|
> | 8 | Train the first agent and choose an improved one, SAC or PPO |
> | 9 | Compare the variants in Experiment Manager |
> | 10 | Move to the corner model and compare with the classical controller |
> | 11 | Build the App Designer demo, where you can push the cube and watch it recover; if time allows, try the agent on the real cube for the bonus |
> | 12 | **Milestone 2:** a working system with an error and risk analysis |
> | 13 | The report, project files and video |
> | 14 | **The defence** |

---

## All three — slide 9 · Team (~45 s)

> **Andrei:** I'm building the physical cube and the simulation model that matches it, and I connect the controllers to the real hardware.
>
> I also design the reward and the RL agents, and I train and compare them.
>
> I also define the tests and the metrics, build the demo app and lead the report.

## Andrei — slide 10 · Questions (~10 s)

> Thank you. Our next checkpoint is Milestone 2 in week 12, with the agent balancing on the corner and compared to the classical controller. We're happy to take your questions.

---

## Likely questions and short answers

| Question | Who | Answer |
|---|---|---|
| Why RL if a linear controller already works? | Andrei | The linear controller only catches the cube within 0.4° of balance. We want to see if an agent handles larger tilts and pushes better, and that comparison is the point of the project. |
| Where does the training data come from? | Andrei | From the simulation. Every episode is new data, so we can generate as much as we need. |
| How do you know the simulation is realistic? | Andrei | It uses the same loop time, the same PWM range and the same sensor signals as the real cube. We add noise and randomise parameters, and we check it against the classical controller on the hardware once it's built. |
| What if the parts are late? | Andrei | The simulation and training don't depend on them. Hardware is the bonus part, not the basis. |
| Why DDPG first? | Andrei | The actions are continuous motor commands, and DDPG is the simplest standard agent for continuous actions in the Reinforcement Learning Toolbox. SAC and PPO are the improved candidates. |
| How do you split the training and test data? | Andrei | We train on random starts. The test is a fixed, separate set of starts and pushes, with `rng(0)`. |
