# 车辆动力学高质量文献与开源项目调研

## 学术文献
1. Rajamani, R. *Vehicle Dynamics and Control*, Springer, 2012.
2. Genta, G. & Morello, L. *The Automotive Chassis: Volume 2: System Design*, Springer, 2009.
3. Milliken, W. F. & Milliken, D. L. *Race Car Vehicle Dynamics*, SAE International, 1995.
4. Pacejka, H. B. *Tire and Vehicle Dynamics*, Elsevier, 2012.
5. Wong, J. Y. *Theory of Ground Vehicles*, Wiley, 2008.

## 开源项目
1. **MATLAB Vehicle Dynamics Blockset 示例**（MathWorks 官方）：提供轮胎、驱动和车辆动力学参考模型，适合与本项目对照理解。
2. **CarSim 参考脚本库**：商业软件的公开脚本示例展示了高保真车辆动力学模型搭建方法。
3. **Adams & Simulink Co-Simulation Demo**：展示多体动力学与控制联合仿真流程。
4. **Python Vehicle Dynamics (pyvdyn)**：虽然使用 Python，但其模块化结构对构建轮胎和车身模块具有借鉴意义。
5. **openVDynamics**：GitHub 上的车辆动力学教学项目，提供了多自由度车辆模型。

以上资源为本项目提供模型结构、参数设定和仿真流程的参考。项目中的模型采用四轮车辆结构，包括轮胎、转向、驱动与车身子模块，并按照 MATLAB/Simulink 规范以脚本方式生成模块化模型。
