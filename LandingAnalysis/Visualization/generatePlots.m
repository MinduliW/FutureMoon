function [] = generatePlots(segmentLogs, landingConstraints)
% This function will produce a series of plots from the trajectory
% generated along with an optional landing animation.

posArr  = [];
thrustArr = [];
tArr = [];
qArr = [];
massArr = [];

animate = true;
createGIF = false;

tf = 0;
for log = segmentLogs
    posArr = [posArr, log{1}.pos];
    thrustArr = [thrustArr, log{1}.thrust];
    tArr = [tArr, tf + log{1}.time];
    qArr = [qArr, log{1}.quaternion];
    massArr = [massArr, log{1}.mass];
    tf = tArr(end);
end


figure('Name', 'Mass over time')
plot(tArr, massArr);
title('Mass over time')
xlabel('time (s)');
grid on
ylabel('vehicle mass (kg)');


figure()
subplot(2, 1, 1)
plot(posArr(1, :), posArr(3, :));
grid on
title('Position along whole trajectory')
xlabel('x (m)');
ylabel('z (m)');
xlim([posArr(1, 1) - 10, posArr(1, end) + 1000])
ylim([0, 101000])
daspect([1, 1, 1])
subplot(2, 1, 2)
plot(posArr(1, :), posArr(3, :));
grid on
title('Position during landing')
xlabel('x (m)');
ylabel('z (m)');
xlim([-200, 50])
ylim([-20, 150])
daspect([1, 1, 1])


% draw the thrust history
figure();
hold on
plot(tArr, thrustArr(1, :), 'r-');
plot(tArr, thrustArr(2, :), 'g-');
plot(tArr, thrustArr(3, :), 'b-');
plot(tArr, thrustArr(4, :), 'k-');
grid on
xlabel('time (s)')
ylabel('thrust (N)')
title('Thrust history over trajectory');
legend('Thruster Pair 1', 'Thruster Pair 2', 'Thruster Pair 3', 'Thruster Pair 4');

if animate
    % draw the last 300 logs in 3D
    filename = 'testAnimated.gif';
    anim = figure('Name', 'animation', 'Renderer', 'painters', 'Position', [10 10 500 1000])
    n = 300;
    indices = (length(tArr) - n:length(tArr));
    n = 1;
    for idx = indices
        clf;
        title('Landing Animation');
        view(63, 28);
        daspect([1, 1, 1])
        windowRad = 10000;
        xlim([-windowRad, windowRad] + posArr(1, idx));
        ylim([-windowRad, windowRad] + posArr(2, idx));
        zlim([max(-windowRad, -20), windowRad] + posArr(3, idx));
        hold on
        plot3(posArr(1, indices), posArr(2, indices), posArr(3, indices), 'b--');
        
        drawLander(posArr(1:3, idx), qArr(1:4, idx), thrustArr(1:4, idx), landingConstraints.vehicleRadius, landingConstraints.vehicleHeight);
        xlabel('x (m)');
        ylabel('y (m)');
        zlabel('z (m)');
        grid on
        text(posArr(1, idx) + 10, posArr(2, idx), posArr(3, idx), sprintf('Time: %f', tArr(idx)));
        
        
        drawnow
        if createGIF
            frame = getframe(anim);
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            if n == 1
                imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
            else
                imwrite(imind,cm,filename,'gif','WriteMode','append');
            end
        end
        
        n = n + 1;
    end
    
end

end
