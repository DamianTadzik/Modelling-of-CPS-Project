function table_of_parameters = linearize_model_at_multiple_points(model_equations, model_parameters, n_of_thetas, n_of_rs)
%LINEARIZE_MODEL_AT_MULTIPLE_POINTS Summary of this function goes here
%   Detailed explanation goes here
    syms m g b1 b2
    syms x1(t) x2(t) x3(t) x4(t) f(t) tau(t)

    Jacobian_A = (jacobian(rhs(model_equations.state_space_equations), [x1 x2 x3 x4]));
    Jacobian_B = (jacobian(rhs(model_equations.state_space_equations), [f tau]));
    
    s = struct('theta_op_ranges', {}, 'r_op_ranges', {}, 'theta_op_points', {}, 'r_op_points', {}, 'f_op_points', {}, 'tau_op_points', {}, 'matrices_A', {}, 'matrices_B', {});
    
    n_thetas = n_of_thetas;
    bit_of_theta = (model_parameters.theta_max - model_parameters.theta_min) / n_thetas;
    theta_op_ranges = [model_parameters.theta_min, model_parameters.theta_min + bit_of_theta];
    for i = 1:n_thetas-1
        theta_op_ranges = [theta_op_ranges; theta_op_ranges(i,:)+bit_of_theta];
    end
    theta_op_ranges;

    n_rs = n_of_rs;
    bit_of_r = (model_parameters.r_max - model_parameters.r_min) / n_rs;
    r_op_ranges = [model_parameters.r_min, model_parameters.r_min + bit_of_r];
    for i = 1:n_rs-1
        r_op_ranges = [r_op_ranges; r_op_ranges(i,:)+bit_of_r];
    end
    r_op_ranges;

    for i = 1:n_rs
        for j = 1:n_thetas
            k = (i-1) * n_thetas + j;
    
            % Save the ranges to the structure    
            s(k).theta_op_ranges = theta_op_ranges(j,:);
            s(k).r_op_ranges = r_op_ranges(i,:);
    
            % Calculate and save the operation points to the sturcture
            s(k).theta_op_points = sum(s(k).theta_op_ranges)  / 2;
            s(k).r_op_points = sum(s(k).r_op_ranges) / 2;
    
            % Calculate the equilibrium force and torque, and save the
            op_point_f0_tau0 = subs(model_equations.equlibrium_equations, [m g x1(t) x3(t)], [model_parameters.m model_parameters.g s(k).theta_op_points s(k).r_op_points]);
            s(k).f_op_points = double(rhs(vpa([0 1]*op_point_f0_tau0)));
            s(k).tau_op_points = double(rhs(vpa([1 0]*op_point_f0_tau0)));
        
            % Calculate linearized matrices and save them
            s(k).matrices_A = double(vpa(subs(Jacobian_A, [m g b1 b2 x1(t) x2(t) x3(t) x4(t) tau(t)], [model_parameters.m model_parameters.g model_parameters.b1 model_parameters.b2 s(k).theta_op_points 0 s(k).r_op_points 0 s(k).tau_op_points])));
            s(k).matrices_B = double(vpa(subs(Jacobian_B, [m x3(t)], [model_parameters.m s(k).r_op_points])));
    
            s(k).eig_A = complex(eig(s(k).matrices_A));
        end
    end
    % s_bus0 = Simulink.Bus.createObject(s);
    table_of_parameters = s;
end