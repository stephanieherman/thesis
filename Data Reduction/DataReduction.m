data = datacube;
mz = mzs;
start = min(mz);
stop = max(mz);

reduceddata = zeros(12,16,length(mz));
reducedmz = zeros(1,length(mz));
count = 1;

for init = start:20:stop
    pos = find(mz<init+20 & mz>=init); % create interval/window
    disp(init);
    no = length(pos);
    if no > 0
        tempdata = data(:,:,pos);
        tempmz = mz(pos);
        intSum = zeros(1,no);

        parfor i=1:no
            img = tempdata(:,:,i);
            img(isnan(img)) = 0;
            intSum(i) = sum(img(:));
        end
        threshold = 3*median(intSum);
        if threshold<max(intSum) 
            ind = find(intSum>threshold); % find imgs of interest
            fprintf('Passed: %d (%d out of %d )', length(ind), length(ind)/length(intSum)*100, length(intSum));
        
            inputdata = tempdata(:,:,ind); % save data that is > threshold
            outputmz = tempmz(ind);
            inputSum = intSum(ind);
            if length(outputmz) > 1
                % calculate similaritys and find those above 70%
                sim = createSimilarityMatrix(inputdata);
                [i,j] = find(sim>0.7);

                merge = length(i);
                remove = [];
                if merge > 0
                    for n = 1:merge
                        imgs = inputdata(:,:,[i(n), j(n)]);
                        if inputSum(i(n)) > inputSum(j(n))
        
                            % checka om det j(n) redan finns där!
                            if ~ismember(j(n), remove)
                                remove = [remove, j(n)];
                            end
                        else
                            if ~ismember(i(n), remove)
                                remove = [remove, i(n)];
                            end
                        end
                    end
                    outputmz(remove) = [];
                    s = size(inputdata);
                    outputdata = zeros(s(1),s(2),s(3)-length(remove));
                    idx = 1;
                    for i = 1:s(3)
                        if ~ismember(i, remove)
                            outputdata(:,:,idx) = inputdata(:,:,i);
                            idx = idx + 1;
                        end
                    end
                else
                    outputdata = inputdata;
                end
            else
                outputdata = inputdata;
            end  
            number = length(outputmz);
            reduceddata(:,:,count:(count-1) + number) = outputdata;
            reducedmz(count:(count-1) + number) = outputmz;
            outputmz = [];
            count = count + number;

        else
            disp('Only background noise present');
        end     
    end
    amount = length(nonzeros(reducedmz));
    fprintf('Number of images: %d', amount);
end        

reducedmz(reducedmz==0) = [];





