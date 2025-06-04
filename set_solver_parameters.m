function set_solver_parameters(stopTime)
%SET_SOLVER_PARAMETERS Sets solver parameters for 'robot_model'
%   stopTime (optional): simulation stop time, default is 0.5

    if nargin < 1
        stopTime = '0.5';
    else
        stopTime = num2str(stopTime);
    end

    model = 'robot_model';

    % Configure variable-step solver with ode45 and minimum step size
    set_param(model, 'SolverType', 'Variable-step');
    set_param(model, 'Solver', 'ode45');
    set_param(model, 'MaxStep', '0.001');      

    set_param(model, 'StartTime', '0');
    set_param(model, 'StopTime', stopTime);
    set_param(model, 'SimulationCommand', 'update');
end
