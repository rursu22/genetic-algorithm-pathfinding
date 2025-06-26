function choices = tournamentSelection(population, tournamentSize) %Create a function that returns the choices selected in the tournament
    populationSize = size(population, 1); %Get the population size in the first dimension
    choices = zeros(1, 2); % Indices of two winners

    remaining = 1:populationSize; %Get the indices of the remaining population
    
    for tournament = 1:2 % Perform two tournaments for two winners
        remaining = remaining(randperm(length(remaining))); %Shuffle the remaining individuals
        
        tournamentIndividuals = remaining(1:tournamentSize); %Get tournamentSize individuals
        remaining(1:tournamentSize) = []; % Remove selected indices
        
        tournamentFitness = population(tournamentIndividuals, size(population,2)); % Extract fitness values
        
        [~, bestIndex] = min(tournamentFitness); %Find the best individual, or the one with the lowest fitness

        choices(tournament) = tournamentIndividuals(bestIndex); %Select this individual as one of the winners
    end
end