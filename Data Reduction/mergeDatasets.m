dataset1 = reduced; % the larger dataset
dataset2 = outputdata; % the smaller dataset

mz1 = reducedmz;
mz2 = mz_list;

no1 = length(mz1);
no2 = length(mz2);

mzs = zeros(no1+no2, 1);
datacube = zeros(15, 11, no1+no2);
datacube(:,:,1:no1) = dataset1;
mzs(1:no1) = mz1;

idx = no1 + 1;
for i=1:no2
   if ~ismember(mz2(i), mzs)
      datacube(:,:,idx) = dataset2(:,:,i);
      mzs(idx) = mz2(i);
      idx = idx + 1;
   end
end

mzs(mzs==0) = [];
datacube = datacube(:,:,1:length(mzs));

[mzs, indices] = sort(mzs);
datacube = datacube(:,:,indices);
