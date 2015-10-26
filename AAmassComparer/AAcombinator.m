function [combinations, combMasses] = AAcombinator(symbols, existingCombinations, masses)

R = length(existingCombinations(1))+1;
N = length(symbols);
combLength = factorial(N+R-1)/(factorial(N-1)*factorial(R));

combMasses = zeros(combLength,1);
currentIndex = 1;

for i=1:length(symbols)
    for j=1:length(existingCombinations)
        if lowestIn(symbols{i}, existingCombinations{j})
            tempComb = strcat(symbols{i}, strcat(',', existingCombinations{j}));
            combinations{currentIndex} = tempComb;
            combMasses(currentIndex) = calcMass(tempComb, masses, symbols);
            currentIndex = currentIndex + 1;
        end
    end
end            
end


    
function [lowest] = lowestIn(symbol, comb)
lowest = symbol <= comb;
lowest = lowest(1);
end

function [massOut] = calcMass(comb, masses, symbols)
    aa = strsplit(comb, ',');
    massOut = 0;
    for i=1:length(aa)
        ind = find(strcmp(symbols, aa(i)));
        massOut = massOut + masses(ind);
    end
end

