class = find(clusters==272);
mz_list = mzs(class);
%mz_list = mztemp;
AAmasses = [71.04,156.10,114.04,115.03,103.01,129.04,128.07,57.02,137.06,113.08,131.04,147.07,97.05,87.03,101.04,186.08,163.06,99.07,147.04];
AAnames = {'A', 'R', 'N', 'D', 'C', 'E', 'Q', 'G', 'H', 'L', 'M', 'F', 'P', 'S', 'T', 'W', 'Y', 'V', 'm'}; 
%Q=K & I=L
%m=Methionine sulfoxide
clear AAmatches1
clear mzpairs1
% calculate delta mz values 
NoMZ = length(mz_list);
deltaMZ = zeros(NoMZ, NoMZ);

for i=1:NoMZ
    for j=i:NoMZ
        if i == j 
            deltaMZ(i,j) = 0;
        else
            deltaMZ(i,j) = abs(mz_list(i)-mz_list(j));
            deltaMZ(j,i) = 0;
        end
    end
end


% ------------------- check for matches with singular aa:s
matches1 = zeros(NoMZ,NoMZ);

for i=1:18
    m = find(deltaMZ < AAmasses(i)+0.1 & deltaMZ >= AAmasses(i)-0.1);
    matches1(m) = i;
end

[r,c] = find(matches1);
mzpairs1 = zeros(length(find(matches1)),2);
for i=1:length(find(matches1))
    fprintf('single match found between mz value %d and %d:', round(mz_list(c(i))), round(mz_list(r(i))));
    disp(AAnames(matches1(r(i), c(i))));
    mzpairs1(i,:) = [mz_list(r(i)), mz_list(c(i))];
    AAmatches1(i,1) = AAnames(matches1(r(i), c(i)));
end

s = size(mzpairs1);
fprintf('single: %d ', s(1)); 




