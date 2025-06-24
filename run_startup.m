clc
clear

model_equations = define_model_equations();

model_parameters = define_model_parameters();

% plot_stationary_force_and_torque(model_equations, model_parameters);
    
table_of_model_parameters = linearize_model_at_multiple_points(model_equations, model_parameters, 9, 3); % For now the number of theta ranges and number of r ranges is passed into this function as parameter 
% const_table_of_model_parameters = coder.const(table_of_model_parameters);

plot_operating_points_area_and_ranges(model_parameters, table_of_model_parameters);

table_of_controller_parameters = calculate_lqr_controllers(table_of_model_parameters);
% const_table_of_controller_parameters = coder.const(table_of_controller_parameters);


plot_mesh_K(table_of_controller_parameters, table_of_model_parameters)

plot_mesh_EIG_LQR(table_of_controller_parameters, table_of_model_parameters)


if isempty(find_system('MatchFilter', @Simulink.match.allVariants, 'Name', 'robot_model'))
    disp('Model loading...')
    open_system('robot_model');
    disp('...done!')
else 
    disp('Model is already loaded!')
end
BOUNDARY_CHOICE = "BOUNDED";
MODEL_CHOICE = "NONLINEAR"; 
REGULATOR_CHOICE = "NO_FORCE_AND_TORQUE_APPLIED"; 
ACTUATOR_CHOICE = "IDEAL_CONSTRAINED";
set_solver_parameters('variable');
