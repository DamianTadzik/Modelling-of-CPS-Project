function x = calculate_lqr_controller(A, B)
%CALCULATE_LQR_CONTROLLER Calculates the LQR controller parameters
%   Detailed explanation goes here

    Q = eye(4);
    R = eye(2);
    
    for k = 1:(n_thetas*n_rs)
        s(k).lqr = lqr(s(k).matrices_A, s(k).matrices_B, Q, R);
    end

    x = 0;
end

% TODO FINISH ME 