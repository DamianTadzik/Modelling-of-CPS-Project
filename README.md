# Modelling-of-CPS-Project

## Assumptions

2 dof simple robotic arm, consisting of rotational joint connected with translational. Arm is about 1 meter in lenght. All the parameters should be defined in the define_model_parameters.m script

## Coding convention

Code and calculations should be encapsulated in the matlab functions, so it does not produce trash variables in the main workspace.

REMEMBER! It is better to have long explicit name of the function than short and magic.

Do not use .mlx format because it is not good for versioning.

## Goals

Main goal is to define two points A and B, and then to make the robot to go from A to B and then from B to A.


## Steps to follow

1. Mathematical model preparation (simplified with point mass, and no additional inertia)
    - [x] Model calculated from lagrange equations in the define_model_equations.m function
    - [x] Model parameters defined in the separate define_model_parameters.m function
    - [ ] Prepare nonlinear and linearized model in Simulink
2. Linearization in selected points
    - [x] Function that linearizes model in specific ranges linearize_model_at_multiple_points.m
    - [ ] 
3. Controller selection and implementation
    - [ ] Implement a LQ controller
    - [ ] Choose a quality criterion
    - [ ]
4. Controller optimization
    - [ ] Optimization in the single point
    - [ ] Optimization in all selected points
    - [ ]
5. Simscape validation
    - [ ] Implement the simscape model and use instead of linear one
    - [ ]


## Authors
inż. Damian Brzana, inż. Marek Janaszkiewicz, inż. Oskar Brandys

Modelling of CPS 2024/2025, dr hab. inż. Adam Piłat
