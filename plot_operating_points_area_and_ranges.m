function plot_operating_points_area_and_ranges(model_parameters, table_of_parameters)
    figure;
    plot_area(model_parameters.r_min, model_parameters.r_max, model_parameters.theta_min, model_parameters.theta_max); hold on;
    plot_ranges(vertcat(table_of_parameters.r_op_ranges), vertcat(table_of_parameters.theta_op_ranges), length(table_of_parameters));
    plot([table_of_parameters.r_op_points] .* cos([table_of_parameters.theta_op_points]), [table_of_parameters.r_op_points] .* sin([table_of_parameters.theta_op_points]), 'o'); grid on; axis equal; hold off;
end