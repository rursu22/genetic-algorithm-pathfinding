function fitness = calcFitness(points, map) %Create a function that returns fitness based on some points and the map

intersectingPoints = 0; %Initialize the variable that will hold the score for intersectingPoints
distance = 0; %Initialise the variable that will hold the score for distance between points;
points = [1 1 points 500 500]; %Add the start and end to the points so that they can also be taken into account
i = 1; %Initialise the incrementor
while i < length(points) - 1 
    % Bresenham algorithm
    y1 = points(1, i); %Get the first point's y
    x1 = points(1, i+1); %Get the first point's x
    y2 = points(1, i+2); %Get the second point's y
    x2 = points(1, i+3); %Get the second point's x
    
    % Distance calculation
    distanceBetweenPoints = sqrt((y2-y1)^2 + (x2 - x1) ^ 2);  % Calculate euclidean distance between each point
    distanceP1End = sqrt((500 - y1)^2 + (500 - x1) ^ 2); %Calculate euclidean distance between first point and end
    distanceP2End = sqrt((500 - y2)^2 + (500 - x2) ^ 2); %Calculate euclidean distance between second point and end
    if(distanceBetweenPoints <= 100) %We want to favor shorter distances between points
        distance = distance + distanceBetweenPoints * 0.5; %We reward it by lowering its score by a lot
    else
        distance = distance + distanceBetweenPoints * 5; %We punish it by increasing its score by a lot
    end

    if( x1 < x2) %If we are going foward on the x axis
        sx = 1; %sx acts as a direction vector, going forward
    else
        sx = -1; %sx acts as a direction vector, going backwards
    end

    if( y1 < y2) %If we are going downwards on the y axis
        sy = 1; %sy acts as a direction vector, going downwards
    else
        sy = -1; %sy acts as a direciton vector, going upwards
    end

    dx = abs(x2 - x1); %Calculate change in x
    dy = -abs(y2 - y1); %Calculate change in y
    
    err = dx + dy; %Calculate the error
    while true
        if map(y1,x1) == 0 %If the current point intersects an obstacle point on the map
            intersectingPoints = intersectingPoints + 1; %Add 1 to the intersecting points
        end
        if(x1 == x2 && y1 == y2) %If we reach the destination, stop
            break
        end
        e2 = 2 * err; %Create another error and make it 2x previous error
        if(e2 >= dy) %If this error is bigger than the change in y
            if x1 == x2 %If we reached the point on the x axis, stop
                break
            end
            err = err + dy; %Add dy to the error
            x1 = x1 + sx; %Move x1 on the direction that we found earlier
        end

        if(e2 <= dx) %If this error is smaller than the change in x
            if y1 == y2 %If we reached the point on the y axis, stop
                break
            end
            err = err + dx; %Add dy to the error
            y1 = y1 + sy; %Move y1 on the direction that we found earlier
        end
    end
    i = i + 2; %Move the loop to the next point over
end

if distance <= 500 %If the total distance is lower than 500
    distance = distance * 0.5; %Reward it
else
    distance = distance * 5; %Punish it
end
% hold off; 

fitness = distance * ((intersectingPoints + 150) * 1); %Construct the fitness function so that it gets penalised by the amount of points that intersect the obstacles. The more obstacles intersected, the higher, or worse, the score.