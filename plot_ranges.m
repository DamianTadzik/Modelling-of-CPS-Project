function plot_ranges(r_op_ranges, theta_op_ranges, number_of_ranges)

    % --- Loop through all ranges ---
    for k = 1:number_of_ranges

        theta_lo = theta_op_ranges(k, 1);
        theta_hi = theta_op_ranges(k, 2);
        r_lo = r_op_ranges(k, 1);
        r_hi = r_op_ranges(k, 2);

        % Create sector slice for this range
        th = linspace(theta_lo, theta_hi, 100);
        x_outer = r_hi * cos(th);
        y_outer = r_hi * sin(th);
        x_inner = r_lo * cos(fliplr(th));
        y_inner = r_lo * sin(fliplr(th));

        x_poly = [x_outer, x_inner];
        y_poly = [y_outer, y_inner];

        % Random-ish color for visibility
        fill(x_poly, y_poly, [0.4 0.4 0.9], ...
            'EdgeColor', [0.1 0.1 0.3], ...
            'FaceAlpha', 0.1, ...
            'LineWidth', 1.0);

    end
end

