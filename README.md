# Modelling-of-CPS-Project

## Assumptions

2 dof simple robotic arm, consisting of rotational joint connected with translational. Arm is about 1 meter in lenght. All the parameters should be defined in the define_model_parameters.m script


## Coding convention

Code and calculations should be encapsulated in the matlab functions, so it does not produce trash variables in the main workspace.

REMEMBER! It is better to have long explicit and self explanatory name of the function than short and magic.

Do not use .mlx format because it is not good for versioning.


## Goals

Main goal is to define two points A and B, and then to make the robot to go from A to B and then from B to A.


## Steps to follow

1. Mathematical model preparation (simplified with point mass, and no additional inertia)
    - [x] Model calculated from lagrange equations in the define_model_equations.m function
    - [x] Model parameters defined in the separate define_model_parameters.m function
    - [x] Prepare nonlinear model in Simulink
    - [x] Prepare script to setup the model
    - [x] Script to run and to visualize the model (currently it is not the best visualization but ok)
2. Linearization in selected points
    - [x] Function that linearizes model in specific ranges linearize_model_at_multiple_points.m
    - [x] K matrix calculated for each of those points
3. Controller selection and implementation
    - [x] Trajectories implemented
    - [x] Implement a LQ controller
    - [ ] Implement a gain schedulling for this controller
    - [x] Choose a quality criterion and implement
    - [ ] OPTIONAL Implement different type of controller to better learn the subject 
    - [x] Control signal needs constrains or even the actuator model (saturation and rate limiters defined in model params)
    - [?] Think of better learning trajectory for a controller :> 
    - [ ]
4. Controller optimization
    - [x] Optimization in the single point (what should we optimize, matrices Q and R?)
    - [ ] Optimization in not all points, just in few and then somehow extrapolate
    - [ ] Save optimization results in a structure ;>
    - [ ] Save logs from optimization in a file
5. (Simscape) validation
    - [x] Use XY graph to visualize trajectories and robot movement in state space and in time plots :>
    - [ ] Implement the simscape model and use instead of linear one
    - [ ] Try to visualize with simscape, not with the script mayybe :>>


## How to use?

1. Read the README.md XD
2. you can play with robot and controller parameters in:
    - ```define_model_parameters.m``` mass, g, lenght etc...
    - ```calculate_lqr_controllers.m``` Q and R matrices...
3. Run ```startup.m```
4. Select wanted controller, model type and initial condition in ```run_the_robot_model.m```
5. Run whole ```run_the_robot_model.m``` script to see a visualization 

## Authors
inż. Damian Brzana, inż. Marek Janaszkiewicz, inż. Oskar Brandys

Modelling of CPS 2024/2025, dr hab. inż. Adam Piłat


# NOTEPAD:

function J = cost_fun(x)
    % x = [q1 q2 q3 q4 r1 r2]
    assignin('base', 'q1', x(1));
    assignin('base', 'q2', x(2));
    assignin('base', 'q3', x(3));
    assignin('base', 'q4', x(4));
    assignin('base', 'r1', x(5));
    assignin('base', 'r2', x(6));

    % Uruchom symulację
    out = sim('twoj_model.slx', 'SimulationMode', 'normal', ...
              'StopTime', '10', 'SaveOutput', 'on');

    % Zakładamy że masz np. w modelu wyjście zapisane jako `y`
    y = out.yout.signals.values;
    t = out.yout.time;
    
    % Można np. obliczyć błąd względem refa
    ref = ones(size(t));  % przykład – zależy co masz
    e = ref - y;

    J = sum(e.^2);  % klasyczna całka z uchybu kwadratowego
end
🔄 Krok 3: Uruchom optymalizację
matlab
Kopiuj
Edytuj
x0 = [1 1 1 1 0.1 0.1];
lb = [0.01 0.01 0.01 0.01 0.001 0.001];
ub = [100 100 100 100 10 10];
opts = optimoptions('fmincon', 'Display', 'iter');
[xopt, Jopt] = fmincon(@cost_fun, x0, [], [], [], [], lb, ub, [], opts);
Albo:

matlab
Kopiuj
Edytuj
[xopt, Jopt] = ga(@cost_fun, 6, [], [], [], [], lb, ub);
