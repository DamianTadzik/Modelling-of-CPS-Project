function plot_area(r_min, r_max, theta_min, theta_max)
        
    % --- Plot gray background (sector) ---
    th = linspace(theta_min, theta_max, 200);
    r1 = r_min; r2 = r_max;
    x_outer = r2 * cos(th);
    y_outer = r2 * sin(th);
    x_inner = r1 * cos(fliplr(th));
    y_inner = r1 * sin(fliplr(th));
    x_poly = [x_outer, x_inner];
    y_poly = [y_outer, y_inner];
    fill(x_poly, y_poly, [0.9 0.9 0.9], 'EdgeColor', 'none');  % Background fill
end

