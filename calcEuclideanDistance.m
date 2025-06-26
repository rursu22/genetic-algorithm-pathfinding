function totalDistance = calcEuclideanDistance(points)

points = [1 1 points 500 500]; %Add the start and end to make sure that we don't miss any lines
totalDistance = 0; %Initialize the total distance variable
i = 1; %Initialize the incrementor

while i < length(points) - 1

    y1 = points(1, i); %y of the first point
    x1 = points(1, i+1); %x of the first point
    y2 = points(1, i+2); %y of the second point
    x2 = points(1, i+3); %x of the second point

    distanceBetweenPoints = sqrt((y2-y1)^2 + (x2 - x1) ^ 2);  % Calculate euclidean distance

    totalDistance = totalDistance + distanceBetweenPoints; %Add it to the total distnance

    i = i + 2; %Increment
end

totalDistance = round(totalDistance); %Make it a whole number so that it's easy to read