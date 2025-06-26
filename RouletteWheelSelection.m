function choices = RouletteWheelSelection(weights) %Function that calculates winners based on probabilities
  weights = flip(weights,1); %Flip the weights so that the best are at the bottom
  size = height(weights);
  accumulation = cumsum(weights); %Get the probabilities of each chromosome being selected between 0 and 1
  choices = zeros(1, 2); % Indices of selected individuals
    
    for i = 1:2
        % Spin the roulette wheel
        spin = rand(); %Get a random number between 1 and 0
        
        % Find the selected individual using cumulative probabilities
        currentSelection = find(accumulation >= spin, 1); %Find the nearest larger number than the random number found
        currentSelection = abs(size + 1 - currentSelection); %Wrap around so that it maps to the actual index in the population.
        % Store the selected individual's index
        choices(i) = currentSelection; %Save the selected index
    end