function table_of_controller_parameters = calculate_lqr_controllers(table_of_model_parameters)
    %CALCULATE_LQR_CONTROLLERS Calculates LQR gains for each model in the table

    Q = 2*[20, 0, 0, 0; % Penalize the angular position error
         0, 40, 0, 0; % Penalize the angular velocity error
         0, 0, 20, 0; % Penalize the linear position error
         0, 0, 0, 40]; % Penalize the linear velocity error
    R = [1, 0; % Penalize the linear actuation
         0, 1]; % Penalize the angular actuation
    table_of_controller_parameters(1:length(table_of_model_parameters)) = struct('K', [], 'S', [], 'P', []);

    for k = 1:length(table_of_model_parameters)
        A = table_of_model_parameters(k).matrices_A;
        B = table_of_model_parameters(k).matrices_B;
        [K, S, P] = lqr(A, B, Q, R);
        table_of_controller_parameters(k).K = K;
        table_of_controller_parameters(k).S = S;
        table_of_controller_parameters(k).P = P;
    end
end
