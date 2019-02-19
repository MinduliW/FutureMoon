function [] = analyzeLunarDeploymentDescent(propMass, payloadMass, initialX)
%% VEHICLE PARAMETERS
landingConstraints.payloadMass = 2000;
landingConstraints.propellantMass = 3000;
landingConstraints.maxForcePerMotor = 12000;
landingConstraints.minForcePerMotor = 0;
landingConstraints.Isp = 300;
landingConstraints.g = 1.62;
landingConstraints.vehicleRadius = 3;
landingConstraints.vehicleHeight = 3;

%% TRAJECTORY CONSTRAINTS
                                 
entrySpeed = 1690;
exitDelta = [-100;-10;0];
entryAlt = 100000;

% [[pos;vel], [pos;vel]]
landingConstraints.trajectoryConstraints = [];
landingConstraints.trajectoryConstraints(1:6, end+1) = [[initialX;0;entryAlt]; [entrySpeed;0;0]];
landingConstraints.trajectoryConstraints(1:6, end+1) = [0;0;10; 0;0;0];
landingConstraints.trajectoryConstraints(1:6, end+1) = [[[0;0;1] + exitDelta]; [0;0;-0.1]];
landingConstraints.trajectoryConstraints(1:6, end+1) = [exitDelta; [0;0;-0.1]];

%% DON'T TOUCH
landingConstraints.thrusterLeverArm = landingConstraints.vehicleRadius;

R = landingConstraints.vehicleRadius;
H = landingConstraints.vehicleHeight;

mass = landingConstraints.payloadMass + landingConstraints.propellantMass/2;
Ixx = 1/4 * mass * R^2 + 1/12*mass*H^2;
Iyy = Ixx;
Izz = 1/2*mass*R^2;

landingConstraints.inertiaTensor = diag([Ixx, Iyy, Izz]);

landingConstraints.initialMass = landingConstraints.payloadMass + landingConstraints.propellantMass;


thrusterTheta = 5 * pi/180; % rad (the split between the thrusters)
landingConstraints.thrusterCount = 8/2; % this is because of an equality constrain imposed.

c = cos(thrusterTheta/2);
s = sin(thrusterTheta/2);

landingConstraints.thrusterMap = 2 * [1, 1, 1, 1;
                                      0, c, 0, -c;
                                      -c, 0, c, 0;
                                      -s, s, -s, s];
                                  
%% COMPUTE TRAJECTORY
computeLandingTrajectory(landingConstraints);
end