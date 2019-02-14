classdef Settings
    %SETTINGS Stores constraints and other important info for the
    %calculation of the trajectories
    
    properties
        g; % m/s^2
        maxForcePerMotor; % N
        minForcePerMotor; % N
        
        initialMass; %kg
        Isp;
        inertiaTensor; % 3x3 inertia tensor
        
        thrusterLeverArm = 2; % meters (the distant from the com to each thruster)
        thrusterCount = 8;
        thrusterMap; % used to map moments and total body z force to individual thruster outputs.
    end
    
    methods
        
    end
end

