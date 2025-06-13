function set_solver_parameters(step_mode, stopTime)
%SET_SOLVER_PARAMETERS Sets solver parameters for 'robot_model'
%   step_mode (required): 'fixed' or 'variable'
%   stopTime (optional): simulation stop time, default is '0.5'

    if nargin < 2
        stopTime = '0.5';
    else
        stopTime = num2str(stopTime);
    end

    model = 'robot_model';

    switch lower(step_mode)
        case 'fixed'
            set_param(model, 'SolverType', 'Fixed-step');
            set_param(model, 'Solver', 'ode4');          % Runge-Kutta (4)
            set_param(model, 'FixedStep', '0.001');
        case 'variable'
            set_param(model, 'SolverType', 'Variable-step');
            set_param(model, 'Solver', 'ode45');         % Dormand-Prince
            set_param(model, 'MaxStep', '0.001');
        otherwise
            error('Unknown step_mode "%s". Use "fixed" or "variable".', step_mode);
    end

    set_param(model, 'StartTime', '0');
    set_param(model, 'StopTime', stopTime);
    set_param(model, 'SimulationCommand', 'update');
end
