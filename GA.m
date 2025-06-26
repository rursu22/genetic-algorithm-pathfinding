map = imbinarize(imread("random_map.bmp")); %Read the map

iterations = 200; %The number of iterations that we do
population = 150; %The amount of paths we are going to have
amountOfPoints = 7; %The amount of points each path is going to have, + 2 for start and end

fittest = zeros(iterations, 1); %Holds the fittest in each iteration
start = [1 1]; %Start coordinates
finish = [500 500]; %End coordinates

%Holds the prompt regarding selection
promptSelection = "Choose one selection method: \n" + ...
    "[0] RWS\n" + ...
    "[1] Tournament\n" + ...
    "[2] Rank-based\n";

%Holds the prompt regarding crossover
promptCrossover = "Choose one cross-over method: \n" + ...
    "[0] 2 Point Crossover\n" + ...
    "[1] Uniform Crossover\n";

%Holds the prompt regarding mutation
promptMutation = "Choose one mutation method: \n" + ...
    "[0] Swap\n" + ...
    "[1] Uniform\n";


selection = input(promptSelection); %Ask the user to choose selection algorithm
crossover = input(promptCrossover); %Ask the user to choose crossover algorithm
mutation = input(promptMutation); %Ask the user to choose mutation algorithm

tic % Start the timer
% Population Generation
solutions = round(rand(population, amountOfPoints * 2) * 499 + 1); % Create a population x amountOfPoints * 2 array with random values between 1-500
% Add the Fitness column
solutions = [solutions zeros(population, 1)]; %Add a column at the end of each row for fitness

% Calculate fitness
for currentIteration = 1:iterations %Loop through iterations
    for currentChromosome = 1:population %Loop through population
         solutions(currentChromosome, amountOfPoints * 2 + 1) = calcFitness(solutions(currentChromosome, 1:amountOfPoints * 2), map); %Calculate the fitness for each chromosome or path and store the value in the fitness column
    end
%     % elite, keep best 30%
    solutions = sortrows(solutions, amountOfPoints * 2 + 1); %Sort the rows from least to most fitness
    fittest(currentIteration,1) = solutions(1,amountOfPoints * 2 + 1); %Fittest is the one with the least score, as less distance is better.
 
    populationNew = zeros(population, amountOfPoints * 2); %Create a new population array
% 
    populationNewSize = round(0.3 * population); %The initial size of the new population is going to be 30% fittest of the population before it
    populationNew(1:populationNewSize, :) = solutions(1:populationNewSize, 1:amountOfPoints * 2); %Copy the values over to the new population for the 30% paths
% 
    while(populationNewSize < population) %While the new population isn't filled yet
        if selection == 0 %If the user selected RWS
            adjustedFitness = 1 ./ solutions(:, amountOfPoints * 2 + 1); %Adjust the weights so that the first element, which is the best but has the lowest fitness, has the highest probability
            weights = adjustedFitness / sum(adjustedFitness); %Get the weights for our current population
            choices = RouletteWheelSelection(weights); %Do Roulette Wheel Selection with our weights
            choice1 = choices(1); %Get the first choice
            choice2 = choices(2); %Get the second choice
        end 
        if selection == 1 %If the user selected Tournament
            choices = tournamentSelection(solutions, 4); %Create a tournament with 4 individuals each
            choice1 = choices(1); %Get the first choice
            choice2 = choices(2); %Get the second choice
        end
        if selection == 2 %If the user selected Rank selection
            choices = rankSelection(solutions, 2); %Create a new rank selection, with 2 chosen individuals
            choice1 = choices(1); %Get the first choice
            choice2 = choices(2); %Get the second choice
        end

        offspring1 = solutions(choice1, 1:amountOfPoints * 2); %Create the first offspring and get its values
        offspring2 = solutions(choice2, 1:amountOfPoints * 2); %Create the second offspring and get its values
        if(rand < 0.8) % 80% crossover chance
            if crossover == 0 %If the user selected 2 Point Crossover
               % 2 Point CrossOver
               randIndex = randi([1,amountOfPoints - 2], 1) * 2 - 1; %Get a random index between 1-amountOfPoints, -2 so that we don't get the last value and we leave space for 1 other value, double it and subtract 1 to get the right xy point start.
               randIndex2 = randi([1,amountOfPoints - 1], 1) * 2; %Get a random index between 1-amountOfPoints, -1 so that we don't get the last value otherwise it would be 1-point, double it to get the right xy point end.
               while(randIndex2 <= randIndex) %If the second index is smaller or equal to the first index
                   randIndex2 = randi([1,amountOfPoints - 1] , 1) * 2; %Generate the second index again
               end
               offspring1 = [offspring1(1,1:randIndex) offspring2(1,randIndex + 1:randIndex2) offspring1(1,randIndex2 + 1: amountOfPoints * 2)]; %Get the first elements up to randIndex1 from the first offspring1, then from randIndex1 + 1 to randIndex2 from offspring2, then from randIndex2 + 1 to the end from offspring1 
               offspring2 = [offspring2(1,1:randIndex) offspring1(1,randIndex + 1:randIndex2) offspring2(1,randIndex2 + 1: amountOfPoints * 2)];  %Get the first elements up to randIndex1 from the first offspring2, then from randIndex1 + 1 to randIndex2 from offspring1, then from randIndex2 + 1 to the end from offspring2
            end
               % Uniform Crossover
            if crossover == 1 %If the user selected uniform crossover
                temp = offspring1; %Save the first offspring in a temp variable
                for i = 1:amountOfPoints %Loop through the number of points
                    if rand() < 0.5 %If the random value is less than 0.5
                        offspring1(1,i * 2) = offspring2(1, i * 2); %The value at index i * 2, or the y, of offspring1 gets changed to that of offspring2
                        offspring1(1,i * 2 - 1) = offspring2(1, i * 2 - 1); %The value at index i * 2 - 1, or the x, of offspring1 gets changed to that of offspring2
                    else
                        offspring2(1, i * 2) = temp(1, i * 2); %The value at index i * 2, or the y, of offspring2 gets changed to that of offspring1
                        offspring2(1, i * 2 - 1) = temp(1, i * 2 - 1); %The value at index i * 2 - 1, or the x, of offspring2 gets chnaged to that of offspring1
                    end
                end
            end
        end

        if(rand < 0.4) %40% chance to mutate
            if mutation == 0 %If the user chose Swap mutation
                % Swap Mutation
               randIndex = randi([1, amountOfPoints - 1], 1) * 2 - 1 ; %Get a random index between 1-amountOfPoints, -2 so that we don't get the last value and we leave space for 1 other value, double it and subtract 1 to get the right xy point start.
               randIndex2 = randIndex + 2; %Get the next xy point
               temp = offspring1(1,randIndex); %Store the value at randIndex in a temp variable because it will be overwritten
               temp2 = offspring1(1,randIndex + 1); %Store the value at randIndex +1 in a temp variable because it will be overwritten
               offspring1(1,randIndex) = offspring1(1,randIndex2); %Change the value at randIndex to the value at randIndex2
               offspring1(1,randIndex+1) = offspring1(1,randIndex2+1);%Change the value at randIndex + 1 to the value at randIndex2 + 1
               offspring1(1,randIndex2) = temp; %Change the value at randIndex2 to the temp value stored before
               offspring1(1,randIndex2 + 1) = temp2; %Change the value at randIndex2 + 1 to the temp value stored before
            end
           if mutation == 1 %If the user chose swap mutation
               % Uniform Mutation
               randIndex = randi([1,amountOfPoints * 2],1); %Get a random index in the path
               changeValue = randi([1,60],1) - 30; %Get a random value between -30, 30
               offspring1(1, randIndex) = min(max(offspring1(1, randIndex) - changeValue, 1), 500); %Clamp that value between 1-500
           end
            
        end

        if(rand < 0.4) %40% chance to mutate
            if mutation == 0 %If the user chose Swap mutation
               % Swap Mutation
               randIndex = randi([1, amountOfPoints - 1], 1) * 2 - 1 ; %Get a random index between 1-amountOfPoints, -2 so that we don't get the last value and we leave space for 1 other value, double it and subtract 1 to get the right xy point start.
               randIndex2 = randIndex + 2; %Get the next xy point
               temp = offspring2(1,randIndex); %Store the value at randIndex in a temp variable because it will be overwritten
               temp2 = offspring2(1,randIndex + 1); %Store the value at randIndex +1 in a temp variable because it will be overwritten
               offspring2(1,randIndex) = offspring2(1,randIndex2); %Change the value at randIndex to the value at randIndex2
               offspring2(1,randIndex+1) = offspring2(1,randIndex2+1);%Change the value at randIndex + 1 to the value at randIndex2 + 1
               offspring2(1,randIndex2) = temp; %Change the value at randIndex2 to the temp value stored before
               offspring2(1,randIndex2 + 1) = temp2; %Change the value at randIndex2 + 1 to the temp value stored before
            end
            if mutation == 1 %If the user chose uniform mutation
               % Uniform Mutation
                
               randIndex = randi([1,amountOfPoints * 2],1); %choose a random index value
               changeValue = randi([1,60],1) - 30; %choose a value between 1-60 and subtract 30 so that we can get negative values
               offspring2(1, randIndex) = min(max(offspring2(1,randIndex) - changeValue, 1), 500); % clamps the value between 1 and 500
            end
        
        end

        populationNewSize = populationNewSize+1; %Increase the new population size because we are going to be adding the first offspring
        populationNew(populationNewSize, :) = offspring1; %Add the first offspring
        if (populationNewSize < population) %If we still don't have enough population
           populationNewSize = populationNewSize+1; %Increase the new population size again
           populationNew(populationNewSize, :) = offspring2; %Add the second offspring
        end     
    end
    solutions(:,1:amountOfPoints * 2) = populationNew; %Merge the initial population with the new population
end
endTime = toc; %End the timer
"Total Euclidean Distance"
euclideanDistance = calcEuclideanDistance(solutions(1, 1:amountOfPoints * 2)) %Calculate the total euclidean distance of the best path and display it
"Total Algorithm Time"
endTime %Display the timer

evenElements = solutions(1, 2:2:amountOfPoints * 2)'; %Get the even elements, or the ys, of the fittest point and transpose them so that they are in the right shape
oddElements = solutions(1, 1:2:amountOfPoints * 2)'; %Get the odd elements, or the xs, of the fittest point and transpose them so that they are in the right shape

solution = [oddElements evenElements]; %Concatenate the evenElements and the oddElements to form an amountOfPoints x 2 solution.

figure(2)
path = [start; solution; finish];%Create the full path along with the start and finish
imshow(map); %Show the map image
rectangle('position',[1 1 size(map)-1],'edgecolor', 'k'); %Create the outline of the map
line(path(:,2), path(:,1)); %Create lines between the points in the path

figure(3)
plot(fittest(:,:)); %Plot the fittest individuals from all iterations. Lower fitness is better
