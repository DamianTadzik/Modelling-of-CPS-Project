%% select the optimized controller index

idx = 1;

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

A = table_of_model_parameters(idx).matrices_A;
B = table_of_model_parameters(idx).matrices_B;

set_solver_parameters(17); % specify time if needed :>>
J_before = cost_function([20 40 20 40 .01 .01], A, B)

%% Optimization 
initial_eyeballed_parameters = [20 40 20 40 .01 .01];
% optimize_fmincon(A, B, initial_eyeballed_parameters)

% if isempty(gcp('nocreate'))
%     parpool('local');
% end
% optimize_ga(A, B, initial_eyeballed_parameters)
% delete(gcp('nocreate'))

function [x_opt, J_opt] = optimize_fmincon(A, B, x0_manual)
    cost = @(x) cost_function(x, A, B); % Funkcja celu
    
    % Ograniczenia
    lb = [1, 1, 1, 1, 1e-4, 1e-4];
    ub = [100, 100, 100, 100, 1, 1];
    
    % Opcje solvera
    opts = optimoptions('fmincon', ...
        'Display', 'iter', ...
        'Algorithm', 'sqp', ...
        'MaxIterations', 100, ...
        'UseParallel', false);  % Możesz dać true, ale tylko jeśli model jest 100% bez side-effectów
    
    % Uruchom optymalizację
    set_param('robot_model', 'FastRestart', 'on');
    [x_opt, J_opt] = fmincon(cost, x0_manual, [], [], [], [], lb, ub, [], opts);    
    set_param('robot_model', 'FastRestart', 'off');
end

function [x_opt, J_opt] = optimize_ga(A, B, x0_manual)
    cost = @(x) cost_function(x, A, B); % Funkcja celu

    % Przedziały dla parametrów [q1, q2, q3, q4, r1, r2]
    lb = [1, 1, 1, 1, 1e-4, 1e-4];
    ub = [100, 100, 100, 100, 1, 1];

    % Ustawienia algorytmu genetycznego
    opts = optimoptions('ga', ...
        'Display', 'iter', ...              % Wyświetlaj postęp w konsoli
        'UseParallel', false, ...            % Jeśli masz Parallel Toolbox, to bardzo przyspieszy
        'PopulationSize', 16, ...           % Liczba osobników na pokolenie
        'MaxGenerations', 32, ...           % Liczba pokoleń
        'EliteCount', 2, ...                % Ile najlepszych osobników przechodzi bez zmian
        'InitialPopulationMatrix', x0_manual, ... % Starting point
        'FunctionTolerance', 1e-3);         % Kryterium zbieżności

    % Odpal optymalizację
    set_param('robot_model', 'FastRestart', 'on');
    [x_opt, J_opt] = ga(cost, 6, [], [], [], [], lb, ub, [], opts);
    set_param('robot_model', 'FastRestart', 'off');
end

%% cost function definition
function J = cost_function(x, A, B)

    Q = 2*[x(1), 0, 0, 0; % Penalize the angular position error
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

    r_sp = simOut.linear_sp.signals(1).values; % r_sp
    theta_sp = simOut.angular_sp.signals(1).values; % theta_sp

    r = simOut.state_and_control.signals(3).values; % r
    theta = simOut.state_and_control.signals(1).values; % theta

    r_err = r_sp - r;
    theta_err = theta_sp - theta;

    J = sum(r_err.^2) + sum(theta_err.^2); % Calculate the cost as the sum of squared errors
end
