%% select the optimized controller index

BOUNDARY_CHOICE = "BOUNDED";
MODEL_CHOICE = "NONLINEAR"; 
REGULATOR_CHOICE = "LQR"; 
ACTUATOR_CHOICE = "IDEAL_CONSTRAINED";

for idx = 1:3
    % set the reference parameters for the controller and linearized model
    model_parameters.linearized.A = table_of_model_parameters(idx).matrices_A;
    model_parameters.linearized.B = table_of_model_parameters(idx).matrices_B;
    
    model_parameters.linearized.x0 = [table_of_model_parameters(idx).theta_op_points;...
                                      0;...
                                      table_of_model_parameters(idx).r_op_points;...
                                      0];
    
    model_parameters.linearized.u0 = [table_of_model_parameters(idx).f_op_points;...
                                      table_of_model_parameters(idx).tau_op_points];
    
    % set the gains for the controller
    K = table_of_controller_parameters(idx).K;
    
    % set the inital positions for the system
    model_parameters.initial.x1 = table_of_model_parameters(idx).theta_op_points;
    model_parameters.initial.x2 = 0;
    model_parameters.initial.x3 = table_of_model_parameters(idx).r_op_points;
    model_parameters.initial.x4 = 0;
    model_parameters.initial.f = table_of_model_parameters(idx).f_op_points;
    model_parameters.initial.tau = table_of_model_parameters(idx).tau_op_points;
    
    A = table_of_model_parameters(idx).matrices_A;
    B = table_of_model_parameters(idx).matrices_B;
    
    set_solver_parameters('fixed', 13); % Fixed solver is a must!
    
    initial_eyeballed_parameters = [20 40 20 40 .01 .01];
    J_before = cost_function(initial_eyeballed_parameters, A, B)
    % [x_opt, ~] = optimize_fmincon(A, B, initial_eyeballed_parameters)
    [x_opt, ~] = optimize_ga(A, B, initial_eyeballed_parameters)
    
    Q_optimized = [x_opt(1), 0, 0, 0; % Penalize the angular position error
                   0, x_opt(2), 0, 0; % Penalize the angular velocity error
                   0, 0, x_opt(3), 0; % Penalize the linear position error
                   0, 0, 0, x_opt(4)]; % Penalize the linear velocity error
    R_optimized = [x_opt(5), 0; % Penalize the linear actuation
                   0, x_opt(6)]; % Penalize the angular actuation
    
    [K, S, P] = lqr(A, B, Q_optimized, R_optimized);
    table_of_optimized_controller_parameters(idx).Q = Q_optimized;
    table_of_optimized_controller_parameters(idx).R = R_optimized;
    table_of_optimized_controller_parameters(idx).K = K;
    table_of_optimized_controller_parameters(idx).S = S;
    table_of_optimized_controller_parameters(idx).P = P;

    clear R_optimized Q_optimized K S P x_opt
end

%% Optimization functions
% if isempty(gcp('nocreate'))
%     parpool('local');
% end
% optimize_ga(A, B, initial_eyeballed_parameters)
% delete(gcp('nocreate'))

function [x_opt, J_opt] = optimize_fmincon(A, B, x0_manual)
    cost = @(x) cost_function(x, A, B); % Funkcja celu
    
    % Ograniczenia
    lb = [1, 1, 1, 1, 1e-4, 1e-4];
    ub = [1000, 1000, 1000, 1000, 1, 1];
    
    % Opcje solvera
    opts = optimoptions('fmincon', ...
        'Display', 'iter', ...
        'Algorithm', 'sqp', ...
        'MaxIterations', 20, ...
        'UseParallel', false);  % Możesz dać true, ale tylko jeśli model jest 100% bez side-effectów
    
    % Uruchom optymalizację
    set_param('robot_model', 'SimulationMode', 'accelerator');
    set_param('robot_model', 'FastRestart', 'on');
    [x_opt, J_opt] = fmincon(cost, x0_manual, [], [], [], [], lb, ub, [], opts);    
    set_param('robot_model', 'FastRestart', 'off');
    set_param('robot_model', 'SimulationMode', 'normal');
end

function [x_opt, J_opt] = optimize_ga(A, B, x0_manual)
    cost = @(x) cost_function(x, A, B); % Funkcja celu

    % Przedziały dla parametrów [q1, q2, q3, q4, r1, r2]
    lb = [1, 1, 1, 1, 1e-4, 1e-4];
    ub = [1000, 1000, 1000, 1000, 1, 1];

    % Ustawienia algorytmu genetycznego
    opts = optimoptions('ga', ...
        'Display', 'iter', ...              % Wyświetlaj postęp w konsoli
        'UseParallel', false, ...            % Jeśli masz Parallel Toolbox, to bardzo przyspieszy
        'PopulationSize', 30, ...           % Liczba osobników na pokolenie
        'MaxGenerations', 50, ...           % Liczba pokoleń
        'EliteCount', 3, ...                % Ile najlepszych osobników przechodzi bez zmian
        'InitialPopulationMatrix', x0_manual, ... % Starting point
        'FunctionTolerance', 1e-3);         % Kryterium zbieżności

    % Odpal optymalizację
    set_param('robot_model', 'SimulationMode', 'accelerator');
    set_param('robot_model', 'FastRestart', 'on');
    [x_opt, J_opt] = ga(cost, 6, [], [], [], [], lb, ub, [], opts);
    set_param('robot_model', 'FastRestart', 'off');
    set_param('robot_model', 'SimulationMode', 'normal');
end

%% cost function definition
function J = cost_function(x, A, B)

    Q = [x(1), 0, 0, 0; % Penalize the angular position error
           0, x(2), 0, 0; % Penalize the angular velocity error
           0, 0, x(3), 0; % Penalize the linear position error
           0, 0, 0, x(4)]; % Penalize the linear velocity error
    R = [x(5), 0; % Penalize the linear actuation
         0, x(6)]; % Penalize the angular actuation

    [K, ~, ~] = lqr(A, B, Q, R);
    % table_of_controller_parameters(idx).K = K;
    % table_of_controller_parameters(idx).S = S;
    % table_of_controller_parameters(idx).P = P;
    
    simIn = Simulink.SimulationInput('robot_model');
    simIn = simIn.setVariable('K', K);

    simOut = sim(simIn);

    % Unpack the simOut data into user friendly variables
    theta_sp = simOut.state_and_control.signals(1).values(:,2); % theta_sp
    theta = simOut.state_and_control.signals(1).values(:,1); % theta

    theta_dot_sp = simOut.state_and_control.signals(2).values(:,2); % theta_dot_sp
    theta_dot = simOut.state_and_control.signals(2).values(:,1); % theta_dot

    r_sp = simOut.state_and_control.signals(3).values(:,2); % r_sp
    r = simOut.state_and_control.signals(3).values(:,1); % r

    r_dot_sp = simOut.state_and_control.signals(4).values(:,2); % r_dot_sp
    r_dot = simOut.state_and_control.signals(4).values(:,1); % r_dot

    f_raw = simOut.state_and_control.signals(5).values(:,1); % f
    f_act = simOut.state_and_control.signals(5).values(:,2); % f_act

    tau_raw = simOut.state_and_control.signals(6).values(:,1); % tau
    tau_act = simOut.state_and_control.signals(6).values(:,2); % tau_act

    % Calculate the error
    theta_err = theta_sp - theta;
    theta_dot_err = theta_dot_sp - theta_dot;
    r_err = r_sp - r;
    r_dot_err = r_dot_sp - r_dot;

    % Calculate the actuation 'overshoot' only if limited
    f_overshoot = (abs(f_raw) > abs(f_act)) .* (f_raw - f_act);
    tau_overshoot = (abs(tau_raw) > abs(tau_act)) .* (tau_raw - tau_act);

    % Calculate the cost as the sum of squared errors
    J = 2 * (sum(r_err.^2) + sum(theta_err.^2)) + ...
        0.5 * (sum(theta_dot_err.^2) + sum(r_dot_err.^2)) + ...
        0.1 * (sum(f_overshoot.^2) + sum(tau_overshoot.^2));
end
