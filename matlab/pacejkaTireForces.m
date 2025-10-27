function [Fx, Fy] = pacejkaTireForces(alpha, kappa, Fz, params) % 定义计算轮胎力的函数
B = 10; % Pacejka 模型刚度因子
C = 1.9; % Pacejka 模型形状因子
D = params.mu * Fz; % 侧向与纵向力幅值
Fy = D .* sin(C .* atan(B .* alpha)); % 根据侧偏角计算侧向力
Fx = params.mu * Fz .* kappa ./ (1 + abs(kappa)); % 使用简单模型计算纵向力
end % 函数结束
