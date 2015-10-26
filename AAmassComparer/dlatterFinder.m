

numbmz = size(mzpairs1);
found = zeros(numbmz(1), 1);
idx = 1;


for i = 1:numbmz(1)-1
    for j=1:numbmz(1)
        if round(mzpairs1(i,2)) == round(mzpairs1(j,1))
            found(idx) = i;
            found(idx+1) = j;
            idx = idx + 2;
        end
    end
end

found(found == 0) = [];

latter = unique(mzpairs1(found, :), 'rows');

mztemp = unique(latter);

