# VehicleDynamicsSteering

本仓库提供一套基于 MATLAB/Simulink 规范的车辆动力学模型示例，涵盖参数定义、车辆运动方程、仿真脚本以及自动生成的模块化 Simulink 模型。通过 `simulateLeftTurn.m` 可演示车辆以 30 km/h 等速左转弯的工况。

## 仓库结构
- `docs/literature_review.md`：车辆动力学高质量文献与开源项目调研。
- `docs/model_description.md`：模块化车辆动力学模型结构与接口说明。
- `matlab/vehicleParameters.m`：车辆与轮胎参数定义函数。
- `matlab/pacejkaTireForces.m`：轮胎纵向与侧向力计算函数。
- `matlab/vehicleDynamicsEOM.m`：车辆二自由度横向动力学状态方程。
- `matlab/simulateLeftTurn.m`：30 km/h 左转仿真脚本，生成轨迹与结果文件。
- `matlab/buildVehicleDynamicsSimulinkModel.m`：自动构建包含轮胎、转向、驱动与车身模块的 Simulink 模型脚本。
- `results/`：仿真结果输出目录（运行仿真脚本后生成 `left_turn_response.mat`）。

## 使用说明
1. 在 MATLAB 环境中打开 `matlab` 目录并添加至路径。
2. 运行 `simulateLeftTurn` 函数以执行 30 km/h 左转仿真，并在 `results` 目录下生成结果文件与轨迹图。
3. 运行 `buildVehicleDynamicsSimulinkModel` 函数生成模块化 Simulink 模型，在 Simulink 中可查看各子模块结构。

## 参考
文献与开源项目参考详见 `docs/literature_review.md`。
