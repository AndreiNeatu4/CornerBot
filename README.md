# CornerBot

Self-balancing reaction-wheel cube: classical vs. RL controllers, on edge and corner.

## Team
- Andrei Neațu: hardware, simulation, integration

## Requirements
MATLAB R2026b with Simulink, Simscape, Simscape Multibody, Reinforcement Learning, Deep Learning, Control System, Parallel Computing and Signal Processing toolboxes.

## Layout
| Folder | Contents |
|---|---|
| `functions/` | Models, controllers, environments, `evaluate.m` |
| `simulink/` | Corner model (Simscape Multibody) |
| `models/` | Final trained agents |
| `app/` | Demo app |
| `data/` | Hardware logs, measured parameters |
| `firmware/` | ESP32 sketches, exported actor weights |
| `documents/` | Plan, slides, report, figures |

## Run
Open `main.mlx` in MATLAB and run all sections.

## Video
_Link here._
