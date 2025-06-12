clear plot_robot
clear run_the_robot_model

%% Select the variant subsystems
BOUNDARY_CHOICE = "BOUNDED";
% BOUNDED or UNBOUNDED

MODEL_CHOICE = "NONLINEAR"; 
% NONLINEAR or SIMSCAPE // TODO
% LINEARIZED

REGULATOR_CHOICE = "LQR"; 
% NO_FORCE_AND_TORQUE_APPLIED or INITIAL_FORCE_AND_TORQUE_APPLIED or
% LQR or LQR_SCHEDULLING // TODO

ACTUATOR_CHOICE = "IDEAL_CONSTRAINED";
% IDEAL_UNCONSTRAINED or IDEAL_CONSTRAINED or REAL

%% Set the robot into position apply initial conditions and correct matrices

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


%% Run the simulation, and obtain the results for plotting
set_solver_parameters(13); % specify time if needed :>>
simOut = sim('robot_model');

x1_sim = simOut.state_and_control.signals(1).values; % theta
x2_sim = simOut.state_and_control.signals(2).values; % theta dot
x3_sim = simOut.state_and_control.signals(3).values; % r
x4_sim = simOut.state_and_control.signals(4).values; % r dot
f_sim = simOut.state_and_control.signals(5).values;  % f 
tau_sim = simOut.state_and_control.signals(6).values;% tau
time_sim = simOut.state_and_control.time;
samples_sim = length(time_sim);
return
%% Animate the results

clear plot_robot
for i=1:30:samples_sim
    plot_robot(x3_sim(i), x1_sim(i), x4_sim(i), x2_sim(i), f_sim(i), tau_sim(i), time_sim(i), time_sim(end), model_parameters.r_min, model_parameters.r_max, model_parameters.theta_min, model_parameters.theta_max)
    % pause(0.001);
    drawnow
end
