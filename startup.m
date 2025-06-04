clc
clear

model_equations = define_model_equations();

model_parameters = define_model_parameters();

plot_stationary_force_and_torque(model_equations, model_parameters);

table_of_parameters = linearize_model_at_multiple_points(model_equations, model_parameters, 5, 3); % For now the number of theta ranges and number of r ranges is passed into this function as parameter 

plot_operating_points_area_and_ranges(model_parameters, table_of_parameters);


