function choices = rankSelection(population, numSelected) %Function that returns numSelect individuals from the population based on their rank
    populationSize = size(population, 1); %Get the size of the population
    choices = zeros(1, numSelected); % Indices of selected individuals
    
    ranks = populationSize:-1:1; % Assign ranks to the individuals
    selectionProbabilities = ranks / sum(ranks); %Assign probabilities based on rank to the individuals
    
    for i = 1:numSelected
        choices(i) = find(rand <= cumsum(selectionProbabilities), 1); %Select an individual based on its probability
    end
end