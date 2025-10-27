function results = simulateLeftTurn() % 定义仿真主函数
params = vehicleParameters(); % 读取车辆参数
steeringInput = @(t) params.steeringStep * (t >= 1.0); % 定义方向盘阶跃输入
steeringDynamics = @(t, delta) (steeringInput(t) - delta) / params.steeringTimeConstant; % 定义转向一阶滞后微分方程
steeringOde = @(t, y) steeringDynamics(t, y); % 转换为匿名函数供积分器使用
[tSteer, deltaHistory] = ode45(steeringOde, [0 params.simTime], 0); % 数值积分方向盘输出
steeringDelta = @(t) interp1(tSteer, deltaHistory, t, 'linear', 'extrap'); % 使用插值函数生成方向盘输出
vehicleInput.deltaFunction = @(t) steeringDelta(t) / params.steeringRatio; % 将方向盘角转换为前轮转角
vehicleOde = @(t, x) vehicleDynamicsEOM(t, x, struct('delta', vehicleInput.deltaFunction(t)), params); % 定义车辆状态方程
initialState = [0; 0; 0; 0; 0]; % 定义初始状态
[tState, stateHistory] = ode45(vehicleOde, [0 params.simTime], initialState); % 数值积分车辆动力学
vy = stateHistory(:, 1); % 提取侧向速度时间历史
r = stateHistory(:, 2); % 提取横摆角速度时间历史
psi = stateHistory(:, 3); % 提取航向角时间历史
X = stateHistory(:, 4); % 提取 X 位置时间历史
Y = stateHistory(:, 5); % 提取 Y 位置时间历史
results.time = tState; % 存储时间序列
results.vy = vy; % 存储侧向速度
results.r = r; % 存储横摆角速度
results.psi = psi; % 存储航向角
results.X = X; % 存储 X 位置
results.Y = Y; % 存储 Y 位置
results.params = params; % 存储参数集合
if ~exist('results', 'dir') % 检查结果目录是否存在
    mkdir('results'); % 创建结果目录
end % 结束条件判断
save('results/left_turn_response.mat', 'results'); % 保存仿真结果
figure; % 创建新图窗
plot(X, Y, 'LineWidth', 2); % 绘制车辆轨迹
axis equal; % 设置坐标等比例
xlabel('X Position [m]'); % 设置 X 轴标签
ylabel('Y Position [m]'); % 设置 Y 轴标签
title('30 km/h 左转弯轨迹'); % 设置图表标题
grid on; % 开启网格
end % 函数结束
