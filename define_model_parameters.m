function model_parameters = define_model_parameters()
%DEFINE_MODEL_PARAMETERS Defines model parameters and constrains
%   Detailed explanation goes here
    
    model_parameters.r_min = 0.8; % [m]
    model_parameters.r_max = 1.4; % [m]
    
    model_parameters.theta_min = 0; % [rad]
    model_parameters.theta_max = pi; % [rad]

    model_parameters.g = 9.80665; % [m/s^2]
    model_parameters.m = 1; % [kg]
    
    model_parameters.b1 = 0; % [?]
    model_parameters.b2 = 0; % [?]

    model_parameters.initial.x1 = pi/2; % [rad] 
    model_parameters.initial.x2 = 0; % [rad/s]
    model_parameters.initial.x3 = 1; % [m]
    model_parameters.initial.x4 = 0; % [m/s]

    model_parameters.initial.f = 9.806649999999999; % [N]
    model_parameters.initial.tau = 0; % [N*m]


    % Actuators
    model_parameters.linear_actuator.transfer_fcn_num = [1]; % Gain = 1
    model_parameters.linear_actuator.transfer_fcn_den = [0.01 1]; % małe opóźnienie, tau = 10 ms
    model_parameters.linear_actuator.saturation_max = 100;   % [N]
    model_parameters.linear_actuator.saturation_min = -100;  % [N]
    model_parameters.linear_actuator.slew_rate = 10000;      % [N/s]

    model_parameters.angular_actuator.transfer_fcn_num = [1]; % Gain = 1
    model_parameters.angular_actuator.transfer_fcn_den = [0.01 1]; % małe opóźnienie, tau = 10 ms
    model_parameters.angular_actuator.saturation_max = 120;     % [Nm]
    model_parameters.angular_actuator.saturation_min = -120;    % [Nm]
    model_parameters.angular_actuator.slew_rate = 12000;        % [Nm/s]


    % Those are 'declared' here they are modified later in the script
    model_parameters.linearized.A = 0;
    model_parameters.linearized.B = 0;
    model_parameters.linearized.x0 = 0;
    model_parameters.linearized.u0 = 0;
    model_parameters.linearized.id = 0;
end