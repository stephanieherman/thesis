function [MZOut, matchNames] = AAmatcher(deltaMZ, mz_list, combNames, combMasses)

pos = 1;
MZOut = zeros(length(combNames),2);
matchNames = {};
for i=1:length(deltaMZ(1,:))
    for j=1:length(deltaMZ(1,:))
        if i~=j
            match = find(combMasses >= deltaMZ(i,j)-0.1 & combMasses < deltaMZ(i,j)+0.1);
            if ~isempty(match)
                fprintf('match(es) found between mz value %d and %d:', round(mz_list(j)), round(mz_list(i)));
                MZOut(pos,:) = [mz_list(j), mz_list(i)];
                for n=1:length(match)
                    matchNames{pos,n} = combNames(match(n));
                    fprintf('\b');
                    disp(combNames(match(n)));
                    fprintf('\b');
                end
                fprintf('\n');
                pos = pos+1;
            end
        end
    end
end
MZOut(~any(MZOut,2),:) = [];    

end