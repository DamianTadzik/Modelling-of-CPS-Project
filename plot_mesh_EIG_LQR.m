function plot_mesh_EIG_LQR(table_of_controller_parameters, table_of_model_parameters)

    figure;
    for i = 1:length(table_of_controller_parameters)
        P = table_of_controller_parameters(i).P;
        P1 = ones(2,2) * P(1);
        P2 = ones(2,2) * P(2);
        P3 = ones(2,2) * P(3);
        P4 = ones(2,2) * P(4);

        r_op_range = table_of_model_parameters(i).r_op_ranges;
        theta_op_range = table_of_model_parameters(i).theta_op_ranges;

        x = [r_op_range .* cos(theta_op_range); [r_op_range(1), r_op_range(2)] .* cos([theta_op_range(2) theta_op_range(1)])];
        y = [r_op_range .* sin(theta_op_range); [r_op_range(1), r_op_range(2)] .* sin([theta_op_range(2) theta_op_range(1)])];
        temp_x_2 = x(1,2);
        temp_x_4 = x(2,2);
        x(1,2) = temp_x_4;
        x(2,2) = temp_x_2;

        temp_y_2 = y(1,2);
        temp_y_4 = y(2,2);
        y(1,2) = temp_y_4;
        y(2,2) = temp_y_2;

        % mesh(x, y, k11); hold on;

        % Create subplots
        subplot(1, 4, 1);
        mesh(x, y, P1); hold on;
        title('P1'); 
        
        subplot(1, 4, 2);
        mesh(x, y, P2); hold on;
        title('P2');
        
        subplot(1, 4, 3);
        mesh(x, y, P3); hold on;
        title('P3');
        
        subplot(1, 4, 4);
        mesh(x, y, P4); hold on;
        title('P4');
    end
end
