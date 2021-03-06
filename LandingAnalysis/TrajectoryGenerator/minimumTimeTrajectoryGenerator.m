function [ Trajectory, totalFlightTime, segmentLogs] = minimumTimeTrajectoryGenerator( start, mid, final, MIDPOINT_MODE, settings, ITERATIONS)
%UNTITLED7 Summary of this function goes here
%   This will generate a trajectory that is fly-able by the spacecraft it may
%   take a second.
%   The format for start and end is [x_0, x_1, x_2, x_3, x_4]
%                                   [y_0, y_1, y_2, y_3, y_4]
%                                   [z_0, z_1, z_2, z_3, z_4]
%
%   the format for mid is [x_0, x2_0, ...]    [x_0, x2_0]
%                         [y_0, y2_0, ...]    [y_0, y2_0]
%                         [z_0, z2_0, ...]    [z_0, z2_0]
%                         [x_1, x2_1, ...]
%                         [y_1, y2_1, ...]
%                         [z_1, z2_1, ...]
%                    MODE:     'VEL'            'NO_VEL'    'NONE'
%                   

%define Trajectory
[~, midCols] = size(mid);
Trajectory = zeros(3, 11, midCols + 1);

segmentLogs = {};

%if this is in velocity mode
if strcmp(MIDPOINT_MODE, 'VEL') == 1
    
    finalMass = 0;
    log = TrajectorySegmentLog();
    
    if midCols ~= 0
        
        
        [Trajectory(:, :, 1), finalMass, log] = polynomialTrajectorySolver([start(1, :), mid(1, 1), mid(4, 1), 0, 0, 0], [start(2, :), mid(2, 1), mid(5, 1), 0, 0, 0], [start(3, :), mid(3, 1), mid(6, 1), 0, 0, 0], settings, ITERATIONS);
        
        segmentLogs{end+1} = log;
        settings.initialMass = finalMass;
        
        for z_index = (1:1:midCols);
            if ~(z_index == midCols)
                [Trajectory(:, :, z_index + 1), finalMass, log] = polynomialTrajectorySolver([mid(1, z_index), mid(4, z_index), 0, 0, 0, mid(1, z_index + 1), mid(4, z_index + 1), 0, 0, 0], [mid(2, z_index), mid(5, z_index), 0, 0, 0, mid(2, z_index + 1), mid(5, z_index + 1), 0, 0, 0], [mid(3, z_index), mid(6, z_index), 0, 0, 0, mid(3, z_index + 1), mid(6, z_index + 1), 0, 0, 0], settings, ITERATIONS);
                segmentLogs{end+1} = log;
                settings.initialMass = finalMass;
            else
                [Trajectory(:, :, z_index + 1), finalMass, log] = polynomialTrajectorySolver([mid(1, z_index), mid(4, z_index), 0, 0, 0, final(1, :)], [mid(2, z_index), mid(5, z_index), 0, 0, 0, final(2, :)], [mid(3, z_index), mid(6, z_index), 0, 0, 0, final(3, :)], settings, ITERATIONS);
                segmentLogs{end+1} = log;
                settings.initialMass = finalMass;
            end
        end
    else
        [Trajectory(:, :, 1), finalMass, log] = polynomialTrajectorySolver([start(1, :), final(1, :)], [start(2, :), final(2, :)], [start(3, :), final(3, :)], settings, ITERATIONS);
        segmentLogs{end+1} = log;
        settings.initialMass = finalMass;
    end
    
elseif strcmp(MIDPOINT_MODE, 'NO_VEL') == 1
    
else
    
end

finalMass;
totalFlightTime = sum(Trajectory(1, 11, :));
segmentLogs;

end

