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
% LQR or LQR_SCHEDULLING

ACTUATOR_CHOICE = "REAL";
% IDEAL_UNCONSTRAINED or IDEAL_CONSTRAINED or REAL

%% Set the robot into position apply initial conditions and correct matrices

idx = 14;
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
% K = zeros(2, 4)
% K = table_of_optimized_controller_parameters(idx).K;

% set the inital positions for the system
model_parameters.initial.x1 = table_of_model_parameters(idx).theta_op_points;
model_parameters.initial.x2 = 0;
model_parameters.initial.x3 = table_of_model_parameters(idx).r_op_points;
model_parameters.initial.x4 = 0;
model_parameters.initial.f = table_of_model_parameters(idx).f_op_points;
model_parameters.initial.tau = table_of_model_parameters(idx).tau_op_points;

%% Run the simulation, and obtain the results for plotting
set_solver_parameters('variable', 22); % specify time if needed :>>
simOut = sim('robot_model');


%% Obtain the results
x1_sim = simOut.state_and_control.signals(1).values(:,1); % theta
x2_sim = simOut.state_and_control.signals(2).values(:,1); % theta dot
x3_sim = simOut.state_and_control.signals(3).values(:,1); % r
x4_sim = simOut.state_and_control.signals(4).values(:,1); % r dot
f_sim = simOut.state_and_control.signals(5).values(:,2);  % f 
tau_sim = simOut.state_and_control.signals(6).values(:,2);% tau
time_sim = simOut.state_and_control.time;
samples_sim = length(time_sim);

% % Animate the results
% animation_rate = 30; % [Hz]
% sim_time = 13; % [s]


filename = 'LQR.gif'; % Output file name
clear plot_robot
for i=1:30:samples_sim
    plot_robot(x3_sim(i), x1_sim(i), x4_sim(i), x2_sim(i), f_sim(i), tau_sim(i), time_sim(i), time_sim(end), model_parameters.r_min, model_parameters.r_max, model_parameters.theta_min, model_parameters.theta_max)
    % pause(0.001);
    drawnow


    if false
         % Capture frame as an image
        frame = getframe(gcf);
        img = frame2im(frame);
        [imind, cm] = rgb2ind(img, 256);
        
        % Write to the GIF File
        if i == 1
            imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
        else
            imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
        end
    end
end
clear samples_sim time_sim tau_sim f_sim
clear x1_sim x2_sim x3_sim x4_sim
