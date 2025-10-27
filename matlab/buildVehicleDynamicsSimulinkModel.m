function buildVehicleDynamicsSimulinkModel() % 定义构建 Simulink 模型的函数
params = vehicleParameters(); % 读取车辆参数
modelName = 'VehicleDynamicsSystem'; % 设置模型名称
if bdIsLoaded(modelName) % 检查模型是否已加载
    close_system(modelName, 0); % 关闭现有模型不保存
end % 结束条件判断
new_system(modelName); % 创建新模型
open_system(modelName); % 打开模型窗口
set_param(modelName, 'Solver', 'ode45'); % 设置求解器类型
set_param(modelName, 'StopTime', num2str(params.simTime)); % 设置仿真时间
add_block('simulink/Ports & Subsystems/Subsystem', [modelName '/SteeringModule'], 'Position', [100 100 250 200]); % 添加转向子系统
add_block('simulink/Ports & Subsystems/Subsystem', [modelName '/TireModule'], 'Position', [350 100 500 200]); % 添加轮胎子系统
add_block('simulink/Ports & Subsystems/Subsystem', [modelName '/BodyDynamicsModule'], 'Position', [600 100 800 220]); % 添加车身动力学子系统
add_block('simulink/Ports & Subsystems/Subsystem', [modelName '/PowertrainModule'], 'Position', [350 250 500 350]); % 添加驱动子系统
add_block('simulink/Sources/Step', [modelName '/SteeringCommand'], 'Time', '1', 'After', '0.0873', 'Position', [10 120 40 150]); % 添加方向盘阶跃输入
add_block('simulink/Sources/Constant', [modelName '/SpeedCommand'], 'Value', num2str(params.vehicleSpeed), 'Position', [10 280 40 310]); % 添加速度输入
add_block('simulink/Sinks/Scope', [modelName '/YawRateScope'], 'Position', [900 120 950 160]); % 添加横摆角速度监视器
add_line(modelName, 'SteeringCommand/1', 'SteeringModule/1'); % 连接阶跃信号到转向模块
add_line(modelName, 'SpeedCommand/1', 'PowertrainModule/1'); % 连接速度指令到驱动模块
add_line(modelName, 'SteeringModule/1', 'TireModule/1'); % 将转向输出连接到轮胎模块
add_line(modelName, 'PowertrainModule/1', 'TireModule/2'); % 将驱动输出连接到轮胎模块
add_line(modelName, 'TireModule/1', 'BodyDynamicsModule/1'); % 将轮胎力连接到车身动力学模块
add_line(modelName, 'BodyDynamicsModule/1', 'YawRateScope/1'); % 将车身输出连接到示波器
configureSteeringSubsystem([modelName '/SteeringModule'], params); % 配置转向子系统内部
configurePowertrainSubsystem([modelName '/PowertrainModule'], params); % 配置驱动子系统内部
configureTireSubsystem([modelName '/TireModule'], params); % 配置轮胎子系统内部
configureBodySubsystem([modelName '/BodyDynamicsModule'], params); % 配置车身子系统内部
save_system(modelName); % 保存模型
end % 函数结束

function configureSteeringSubsystem(path, params) % 定义配置转向子系统的函数
open_system(path); % 打开子系统
set_param([path '/In1'], 'Position', [30 60 60 80]); % 调整输入端口位置
set_param([path '/Out1'], 'Position', [310 60 340 80]); % 调整输出端口位置
add_block('simulink/Continuous/Transfer Fcn', [path '/SteeringLag'], 'Numerator', '1', 'Denominator', ['[' num2str(params.steeringTimeConstant) ' 1]'], 'Position', [120 50 220 90]); % 添加一阶滞后
add_block('simulink/Commonly Used Blocks/Gain', [path '/SteeringGain'], 'Gain', ['1/' num2str(params.steeringRatio)], 'Position', [220 50 260 90]); % 添加转向比增益
add_line(path, 'In1/1', 'SteeringLag/1'); % 连接输入到一阶滞后
add_line(path, 'SteeringLag/1', 'SteeringGain/1'); % 连接滞后到增益
add_line(path, 'SteeringGain/1', 'Out1/1'); % 连接增益到输出
end % 函数结束

function configurePowertrainSubsystem(path, params) % 定义配置驱动子系统的函数
open_system(path); % 打开子系统
set_param([path '/In1'], 'Position', [30 60 60 80]); % 调整输入端口位置
set_param([path '/Out1'], 'Position', [310 60 340 80]); % 调整输出端口位置
add_block('simulink/Commonly Used Blocks/Gain', [path '/RollingResistanceGain'], 'Gain', num2str(params.m * params.g * 0.015), 'Position', [120 50 210 90]); % 添加滚阻补偿增益
add_block('simulink/Commonly Used Blocks/Sum', [path '/Sum'], 'Inputs', '+-', 'Position', [220 50 240 90]); % 添加求和器
add_block('simulink/Sources/Constant', [path '/BaselineForce'], 'Value', num2str(params.gravityForce * 0.01), 'Position', [120 110 150 140]); % 添加基础驱动力
add_line(path, 'In1/1', 'RollingResistanceGain/1'); % 连接速度指令到滚阻增益
add_line(path, 'RollingResistanceGain/1', 'Sum/1'); % 连接滚阻到求和器
add_line(path, 'BaselineForce/1', 'Sum/2'); % 连接基础力到求和器
add_line(path, 'Sum/1', 'Out1/1'); % 将求和结果输出
end % 函数结束

function configureTireSubsystem(path, params) % 定义配置轮胎子系统的函数
open_system(path); % 打开子系统
set_param([path '/In1'], 'Position', [30 40 60 60]); % 调整输入端口位置
set_param([path '/In2'], 'Position', [30 120 60 140]); % 调整第二输入端口位置
set_param([path '/Out1'], 'Position', [330 80 360 100]); % 调整输出端口位置
add_block('simulink/User-Defined Functions/MATLAB Function', [path '/TireForcesFunction'], 'Position', [150 40 280 140]); % 添加 MATLAB Function 块
set_param([path '/TireForcesFunction'], 'MATLABFcn', sprintf(['function Fy = fcn(delta, FxIn)\n' ...
    '%%#codegen\n' ...
    'params = vehicleParameters();\n' ...
    'Fzf = params.massFront * params.g;\n' ...
    'alpha = delta;\n' ...
    '[~, FySingle] = pacejkaTireForces(alpha, 0, Fzf/2, params);\n' ...
    'Fy = 2 * FySingle + FxIn;\n'])); % 设置 MATLAB 函数代码
add_line(path, 'In1/1', 'TireForcesFunction/1'); % 连接转向角输入
add_line(path, 'In2/1', 'TireForcesFunction/2'); % 连接驱动力输入
add_line(path, 'TireForcesFunction/1', 'Out1/1'); % 输出轮胎作用力
end % 函数结束

function configureBodySubsystem(path, params) % 定义配置车身子系统的函数
open_system(path); % 打开子系统
set_param([path '/In1'], 'Position', [30 130 60 150]); % 调整输入端口位置
set_param([path '/Out1'], 'Position', [380 130 410 150]); % 调整输出端口位置
add_block('simulink/User-Defined Functions/MATLAB Function', [path '/BodyDynamicsFunction'], 'Position', [120 80 320 180]); % 添加 MATLAB Function 块
set_param([path '/BodyDynamicsFunction'], 'MATLABFcn', sprintf(['function yawRate = fcn(FyInput)\n' ...
    '%%#codegen\n' ...
    'persistent vy r psi X Y;\n' ...
    'if isempty(vy)\n' ...
    '    vy = 0; r = 0; psi = 0; X = 0; Y = 0;\n' ...
    'end\n' ...
    'params = vehicleParameters();\n' ...
    'dt = 0.01;\n' ...
    'input.delta = 0;\n' ...
    'state = [vy; r; psi; X; Y];\n' ...
    'dx = vehicleDynamicsEOM(0, state, input, params);\n' ...
    'vy = vy + dx(1) * dt + FyInput/(params.m);\n' ...
    'r = r + dx(2) * dt;\n' ...
    'psi = psi + dx(3) * dt;\n' ...
    'X = X + dx(4) * dt;\n' ...
    'Y = Y + dx(5) * dt;\n' ...
    'yawRate = r;\n'])); % 设置 MATLAB 函数代码
add_line(path, 'In1/1', 'BodyDynamicsFunction/1'); % 连接输入力到函数
add_line(path, 'BodyDynamicsFunction/1', 'Out1/1'); % 输出横摆角速度
end % 函数结束
