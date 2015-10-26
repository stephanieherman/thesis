function simRTB = createSimilarityMatrix(data)

s = size(data);
noImg = s(3);
tic;
simRTB = zeros(noImg);

N = noImg-1;
p = ProgressBar(N);

for m=1:N
   temp = zeros(1,noImg);
   compImg = data(:,:,m);
   parfor n=m:noImg
       if m ~= n
           scoreRTB = calcRangedMoS(compImg, data(:,:,n));
           temp(n) = scoreRTB;
       end
   end
   simRTB(m,:) = temp;
   p.progress;
end
p.stop;

% Only for real run

for i=1:noImg
   simRTB(:,i) = simRTB(i,:); 
end
simRTB(simRTB == 0) = NaN;
time = toc;
figure
imagesc(simRTB);
colorbar;
colormap('jet');
set(gca, 'YDir', 'normal')
title('Similarity matrix')
end
