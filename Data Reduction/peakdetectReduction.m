% A rough prefiltering step, where images that does not contain a single
% peak that is above 5*average, is removed (step 2)
data = datacube;
mz_list = mzs;

s = size(data);
no = s(3);
dim = s(1)*s(2);
output = zeros(1,2);
ind = 1;
idx = zeros(1,no);

% find significant imgs

for i=1:no
    img = data(:,:,i);
    img(isnan(img)) = 0; % replace NaN:s
    q = quantile(img(:),0.99); % remove hotspots
    img(img>q) = q;
    flat = reshape(img, 1, dim);
    m = mean(flat); % calc mean intensity in image
    peaks = find(flat > 10*m); % find pixels with peak aka over threshold
    if length(peaks) > 1
        idx(ind) = i;
        ind = ind + 1;
    end   
end

idx = idx(find(idx~=0));
mz_list = mzs(idx);
datafilt = datacube(:,:,idx);

% calculate sumInt
no = length(mz_list);
intSum = zeros(1,no);

parfor i=1:no
    img = datafilt(:,:,i);
    img(isnan(img)) = 0;
    intSum(i) = sum(img(:));
end

% score data
numb = size(datafilt);
fprintf('Number of passed images: %d', numb(3));
sim = createSimilarityMatrix(datafilt);
[i,j] = find(sim>0.7);

merge = length(i);
remove = [];

if merge > 0
    for n = 1:merge
        if abs(mz_list(i(n))-mz_list(j(n))) <= 56            
            if intSum(i(n)) > intSum(j(n))
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
    end
    mz_list(remove) = [];
    s = size(datafilt);
    outputdata = zeros(s(1),s(2),s(3)-length(remove));
    idx = 1;
    for i = 1:s(3)
        if ~ismember(i, remove)
            outputdata(:,:,idx) = datafilt(:,:,i);
            idx = idx + 1;
        end
    end
else
    outputdata = datafilt;
end


         
         
         
         
    