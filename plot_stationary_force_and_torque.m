function  plot_stationary_force_and_torque(model_equations, model_parameters)
    %% define the range of r and theta (x3 and x1) in defined ranges
    syms r(t) theta(t) m g 
    assumeAlso(r(t), 'real'); assumeAlso(r(t)>=model_parameters.r_min); assumeAlso(r(t)<=model_parameters.r_max); 
    assumeAlso(theta(t), 'real'); assumeAlso(theta(t)>=model_parameters.theta_min); assumeAlso(theta(t)<=model_parameters.theta_max); 
    assumptions()
    % Substitute the mass and the acceleration
    final_eqn = subs(model_equations.equlibrium_equations, [m, g], [model_parameters.m, model_parameters.g])

    %% Zakresy zmiennych
    x1_var = linspace(model_parameters.theta_min, model_parameters.theta_max, 100);   % x1 od 0 do pi
    x3_var = linspace(model_parameters.r_min, model_parameters.r_max, 100); % x3 od 0.8 do 1.2
    
    % Tworzenie siatki wartości
    [X1, X3] = meshgrid(x1_var, x3_var);
    
    % Obliczenie funkcji
    tau = (5520653160719109 * cos(X1) .* X3) / 562949953421312;
    warning('The tau(x1, x3) function is not dynamically calculated, pay attention!')
    
    % % Rysowanie wykresu 3D
    % figure;
    % surf(X1, X3, tau);
    % xlabel('x1');
    % ylabel('x3');
    % zlabel('\tau(x1, x3)');
    % title('Wykres funkcji \tau(x1, x3)');
    % colorbar;
    % shading interp;
    
    % Obliczenie funkcji
    f = (5520653160719109 * sin(X1)) / 562949953421312;
    warning('The f(x1) function is not dynamically calculated, pay attention!')

    % % Rysowanie wykresu 3D
    % figure;
    % surf(X1, X3, f);
    % xlabel('x1');
    % ylabel('x3');
    % zlabel('f(x1, x3)');
    % title('Wykres funkcji f(x1, x3)');
    % colorbar;
    % shading interp;
    
    % Rysowanie wykresów na jednym wykresie
    figure;
    hold on;
    surf(X1, X3, tau, 'FaceAlpha', 0.6); % Przezroczystość 60%
    surf(X1, X3, f, 'FaceAlpha', 0.6);     % Przezroczystość 60%
    hold off;
    
    xlabel('x1');
    ylabel('x3');
    zlabel('Wartość funkcji');
    title('Nałożone wykresy \tau(x1, x3) i f(x1, x3)');
    colorbar;
    shading interp;
    legend({'\tau(x1, x3)', 'f(x1,  x3)'});
    view([-18.3 7.4])
    grid on;
    
    % Rysowanie wykresów konturowych na jednym wykresie
    figure;
    hold on;
    contour3(X1, X3, tau, 20, 'b', 'LineWidth', 1.5); % Kontury tau (niebieskie)
    contour3(X1, X3, f, 20, 'r', 'LineWidth', 1.5); % Kontury f (czerwone)
    hold off;
    
    xlabel('x1');
    ylabel('x3');
    zlabel('Wartość funkcji');
    title('Konturowe wykresy \tau(x1, x3) i f(x1, x3)');
    colorbar;
    legend({'\tau(x1, x3)', 'f(x1, x3)'});
    view([45 30]); % Ustawienie kąta widoku
    grid on;
end