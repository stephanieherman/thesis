function [clustersOut] = clustering(data, simRTB, initialthreshold, mergethreshold)

% data, if you want to plot your images according to clusters
% simRTB - similarity  matrix
% initialthreshold, typically 0.6
% mergethreshold, typically 0.4

close all;
simMatrix = simRTB;
simMatrix(isnan(simMatrix)) = 0;

clusters = zeros(length(simMatrix(1,:)),1);

% create cluster 1
clusters(1) = 1;
[maxValue, maxInd] = sort(simMatrix(1,:),'descend');
if maxValue(1) > initialthreshold
    maxValue = find(maxValue == maxValue(1));
    for i=1:length(maxValue)
        clusters(maxInd(i)) = 1;
    end
end

% create the rest of the initial clusters
Cno = 1;
for m= 2:length(simMatrix(1,:))
   if clusters(m) == 0
       Cno = Cno + 1;
       clusters(m) = Cno;
       [maxValue, maxInd] = sort(simMatrix(m,:), 'descend');
       if maxValue(1) > initialthreshold
            maxValue = find(maxValue == maxValue(1));
            for i=1:length(maxValue)
            clusters(maxInd(i)) = Cno;
            end
       end
   end   
end

% merge cluster
disp(sprintf('Run 1; Number of clusters: %d', Cno));
PreCno = 1000000;
runs = 1;

while PreCno > Cno
    runs = runs + 1;
    PreCno = Cno;
    [clusters, cluster_similarity] = mergeClusters(clusters, simMatrix, mergethreshold);
    Cno = max(clusters);
    disp(sprintf('Run %d; Number of clusters: %d', runs, Cno));
end
% delete clusters with single members
finCno = Cno;
for i=1:Cno
    No = find(clusters == i);
    if length(No) < 2
        clusters(No) = 0;
        finCno = finCno - 1;
    end
end


temp = finCno;
clustersOut = zeros(length(clusters), 1);
for i=1:temp
    maxInd = find(clusters == max(clusters));
    clusters(maxInd) = 0;
    clustersOut(maxInd) = finCno;
    finCno = finCno - 1;
end
disp(sprintf('Final number of clusters: %d', max(clustersOut)));
% for i=1:max(clusters)
%     figure
%     suptitle(sprintf('Cluster #%d', i))
%     ind = find(clusters == i);
%     for j=1:length(ind)
%         ion_image=data(:,:,ind(j));
%         subplot(round(length(ind)/5),6,j)
%         h=imagesc(ion_image);
%         set(h,'alphadata',~isnan(ion_image))
%         axis image
%         axis off
%     end
%     
% end



end



