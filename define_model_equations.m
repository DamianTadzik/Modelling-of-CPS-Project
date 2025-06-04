function model_equations = define_model_equations()
%DEFINE_MODEL_EQUATIONS Fucntion calculates and returns the state space
%equations and the equations for equilibrium calculation
%   tau is the torque applied to rotational joint
%   f is the force applied
%   theta is the angular position
%   r is the arm transiatonal position

    %% Lagrange equations
    syms r(t) theta(t) m g f(t) tau(t)
    syms b1 b2
    q = [theta; r];
    Q = [tau; f];
    % Moment of inertia
    J = m * r^2;
    % Kinetic energy
    T = 0.5 * J * diff(theta, 1)^2 + 0.5 * m * diff(r, 1)^2;
    % Potential energy
    V = m * g * r * sin(theta);
    % Energy dissipation
    P = 0.5 * b1 * diff(theta, 1, t)^2 + 0.5 * b2 * diff(r, 1, t)^2;
    % Lagrange equation
    L = T - V;
    % Differentiations
    diff_t_q_prim = diff(jacobian(L, diff(q, t)), t).';
    diff_q = jacobian(L, q).';
    diff_q_prim = jacobian(P, diff(q, t)).';
    % Final differential equation (u = d/dt(dL/dq') - dL/dq + dP/dq')
    eqn = Q == diff_t_q_prim - diff_q + diff_q_prim;

    %% Transition to the state space variables from 'normal' variables
    syms x1(t) x2(t) x3(t) x4(t)
    x = [x1 == theta; x2 == diff(theta); x3 == r; x4 == diff(r)]; % [theta, theta_dot, r, r_dot]
    subs_eqs = subs(eqn, [theta, diff(theta), r, diff(r)], [x1, x2, x3, x4]);
    subs_eqs = subs(subs_eqs, [diff(x1,2), diff(x3,2)], [diff(x2), diff(x4)]);
    subs_eqs = subs(subs_eqs, [diff(x1), diff(x3)], [x2, x4]);
    [1,0]*subs_eqs;
    [0,1]*subs_eqs;
    ss_eqs = [diff(x1) == x2; isolate([1,0]*subs_eqs, diff(x2, 1, t));
              diff(x3) == x4; isolate([0,1]*subs_eqs, diff(x4, 1, t))];

    %% Finding the equilibrium equations 
    subs_eqs = subs(ss_eqs, [diff(x1), diff(x2), diff(x3), diff(x4)], [0, 0, 0, 0]);
    subs_eqs = subs(subs_eqs, [x2(t) x4(t)], [0 0]);
    subs_eqs = [isolate([0 1 0 0]*subs_eqs, tau);
                isolate([0 0 0 1]*subs_eqs, f)];

    %% Returning wanted equations
    model_equations.state_space_equations = ss_eqs;
    model_equations.equlibrium_equations = subs_eqs;
    model_equations.variables_definition = x;
end