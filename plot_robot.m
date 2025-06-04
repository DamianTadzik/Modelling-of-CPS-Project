function plot_robot(r, theta, r_dot, theta_dot, f, tau, time, total_time, r_min, r_max, theta_min, theta_max)
    persistent r_history r_dot_history theta_history theta_dot_history f_history gamma_history time_history
    
    if isempty(r_history) | isempty(r_dot_history) | isempty(theta_history) | isempty(theta_dot_history) | isempty(f_history) | isempty(gamma_history) | isempty(time_history)
        r_history = [];
        r_dot_history = [];
        theta_history = [];
        theta_dot_history = [];
        f_history = [];
        gamma_history = [];
        time_history = [];
    end

    r_history(end+1) = r;
    r_dot_history(end+1) = r_dot;
    theta_history(end+1) = theta;
    theta_dot_history(end+1) = theta_dot;
    f_history(end+1) = f;
    gamma_history(end+1) = tau;
    time_history(end+1) = time;

    persistent fig
    if isempty(fig)
        fig = figure('Name', 'Robot State Animation', 'WindowState', 'maximized');
    end

    %% Plot of the effector movement
    persistent axactuator hplot1 hplot2 hplot3
    if isempty(axactuator)
        axactuator = axes('Parent', fig, 'Position', [.05 .6 .3 .3]);
        hold(axactuator, 'on');
        
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

        % --- Plot robot link ---
        hplot1 = plot([0 0], [0 0], '-o', 'LineWidth', 2, 'Color', 'b'); % Placeholder

        % --- Plot history of end-effector positions ---
        hplot2 = plot(r_history .* cos(theta_history), r_history .* sin(theta_history), '.', ...
                  'Color', 'r', 'MarkerSize', 4);  % History of end-effector

        % --- Display time ---
        hplot3 = text(-1.1, 1.25, '', 'FontSize', 10, 'Color', 'k');  % Placeholder for time display

        % Plot styling settings
        axis(axactuator, [-1.2 1.2 -0.2 1.3]);  % Set axis limits
        grid(axactuator, 'on');
        axis(axactuator, 'equal');  % Keep aspect ratio equal

        % Set title and legend
        title(axactuator, 'Effector Movement');
        % legend(axactuator, 'End-effector History', 'Robot Link');
    else
        % Update robot link position
        set(hplot1, 'XData', [0 r_history(end) * cos(theta_history(end))], ...
                'YData', [0 r_history(end) * sin(theta_history(end))]);
        
        % Update history of end-effector positions
        set(hplot2, 'XData', r_history .* cos(theta_history), 'YData', r_history .* sin(theta_history));
        
        % Update time display
        time_str = sprintf('Time: %.2f / %.2f s', time, total_time);
        set(hplot3, 'String', time_str);
    end

    %% Plot the r vs r_dot and theta vs theta_dot
    persistent axrrdot hplot4
    if isempty(axrrdot)
        % Create axes for r vs r_dot
        axrrdot = axes('Parent', fig, 'Position', [.375 .6 .25 .3]);
        hold(axrrdot, 'on');
        hplot4 = plot(axrrdot, r_history, r_dot_history, 'g.-', 'LineWidth', 1.5, 'MarkerSize', 10);
        xlabel(axrrdot, 'Displacement r [m]');
        ylabel(axrrdot, 'Linear Velocity r dot [m/s]');
        title(axrrdot, 'r dot vs r');
        grid(axrrdot, 'on');
    else
        % Update r vs r_dot plot
        set(hplot4, 'XData', r_history, 'YData', r_dot_history);
    end
    
    persistent axttdot hplot5
    if isempty(axttdot)
        % Create axes for theta vs theta_dot
        axttdot = axes('Parent', fig, 'Position', [.7 .6 .25 .3]);
        hold(axttdot, 'on');
        hplot5 = plot(axttdot, theta_history, theta_dot_history, 'b.-', 'LineWidth', 1.5, 'MarkerSize', 10);
        xlabel(axttdot, 'Angle \theta [rad]');
        ylabel(axttdot, 'Angular Velocity \theta dot [rad/s]');
        title(axttdot, '\theta dot vs \theta');
        grid(axttdot, 'on');
    else
        % Update theta vs theta_dot plot
        set(hplot5, 'XData', theta_history, 'YData', theta_dot_history);
    end
  
    %% Plot the r r_dot and f vs time and theta theta_dot and tau vs time
    persistent axrrdotf h1 h2 h3
    if isempty(axrrdotf)
        % First axes: r, r_dot, f
        axrrdotf = axes('Parent', fig, 'Position', [.05 .3 .9 .2]);
        hold(axrrdotf, 'on');
        h1 = plot(axrrdotf, time_history, r_history, 'r', 'DisplayName','r');
        h2 = plot(axrrdotf, time_history, r_dot_history, 'g', 'DisplayName','r\_dot');
        h3 = plot(axrrdotf, time_history, f_history, 'b', 'DisplayName','f');
        hold(axrrdotf, 'off');
        xlim(axrrdotf, [0 total_time]); 
        title(axrrdotf, 'r, r\_dot, f');
        legend(axrrdotf, 'show');
        grid(axrrdotf, 'on');
    else
        % Update the plots only
        set(h1, 'YData', r_history, 'XData', time_history);
        set(h2, 'YData', r_dot_history, 'XData', time_history);
        set(h3, 'YData', f_history, 'XData', time_history);
    end

    persistent axttdotg h4 h5 h6
    if isempty(axttdotg)
        % Second axes: theta, theta_dot, tau
        axttdotg = axes('Parent', fig, 'Position', [.05 .05 .9 .2]);
        hold(axttdotg, 'on');
        h4 = plot(axttdotg, time_history, theta_history, 'r', 'DisplayName','\theta');
        h5 = plot(axttdotg, time_history, theta_dot_history, 'g', 'DisplayName','\theta\_dot');
        h6 = plot(axttdotg, time_history, gamma_history, 'b', 'DisplayName','\tau');
        hold(axttdotg, 'off');
        xlim(axttdotg, [0 total_time]); 
        title(axttdotg, '\theta, \theta\_dot, \tau');
        legend(axttdotg, 'show');
        grid(axttdotg, 'on');
    else
        set(h4, 'YData', theta_history, 'XData', time_history);
        set(h5, 'YData', theta_dot_history, 'XData', time_history);
        set(h6, 'YData', gamma_history, 'XData', time_history);
    end

    %% Layout debug
    % persistent layout_debug_ax
    % if isempty(layout_debug_ax)
    %     layout_debug_ax = axes('Position', [0 0 1 1], 'Visible', 'off');
    % 
    %     annotation('rectangle', [.1 .1 .8 .2], 'Color', 'r', 'LineWidth', 1);
    %     annotation('rectangle', [.1 .4 .8 .2], 'Color', 'g', 'LineWidth', 1);
    %     annotation('rectangle', [.1 .7 .2 .2], 'Color', 'b', 'LineWidth', 1);
    % end
end
