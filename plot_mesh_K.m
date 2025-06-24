function plot_mesh_K(table_of_controller_parameters, table_of_model_parameters)

    figure;
    for i = 1:length(table_of_controller_parameters)
        K = table_of_controller_parameters(i).K;
        k11 = ones(2,2) * K(1,1);
        k12 = ones(2,2) * K(1,2);
        k13 = ones(2,2) * K(1,3);
        k14 = ones(2,2) * K(1,4);
        k21 = ones(2,2) * K(2,1);
        k22 = ones(2,2) * K(2,2);
        k23 = ones(2,2) * K(2,3);
        k24 = ones(2,2) * K(2,4);

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
        subplot(2, 4, 1);
        mesh(x, y, k11); hold on;
        title('k11'); 
        
        subplot(2, 4, 2);
        mesh(x, y, k12); hold on;
        title('k12');
        
        subplot(2, 4, 3);
        mesh(x, y, k13); hold on;
        title('k13');
        
        subplot(2, 4, 4);
        mesh(x, y, k14); hold on;
        title('k14');

        subplot(2, 4, 5);
        mesh(x, y, k21); hold on;
        title('k21'); 
        
        subplot(2, 4, 6);
        mesh(x, y, k22); hold on;
        title('k22');
        
        subplot(2, 4, 7);
        mesh(x, y, k23); hold on;
        title('k23');
        
        subplot(2, 4, 8);
        mesh(x, y, k24); hold on;
        title('k24');
    end

end