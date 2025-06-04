function model_parameters = define_model_parameters()
%DEFINE_MODEL_PARAMETERS Defines model parameters and constrains
%   Detailed explanation goes here
    
    model_parameters.r_min = 0.8; % [m]
    model_parameters.r_max = 1.2; % [m]
    
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


    % Those are 'declared' here they are modified later in the script
    model_parameters.linearized.A = 0;
    model_parameters.linearized.B = 0;
    model_parameters.linearized.x0 = 0;
    model_parameters.linearized.u0 = 0;
    model_parameters.linearized.id = 0;
end