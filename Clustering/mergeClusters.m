function [clusters, cluster_similarity] = mergeClusters(clusters, similarityM, mergethreshold)

Cno = max(clusters);
%  calculate cluster similarities (step 4)
cluster_similarity = zeros(Cno, Cno);
for m=1:Cno
    for n=1:Cno
        if m ~= n
            membersM = find(clusters == m);
            membersN = find(clusters == n);
            Mno = length(membersM);
            Nno = length(membersN);
            comb = Nno*Mno;
            SumScore = 0;
            for s=1:Mno
                for t=1:Nno
                    SumScore = SumScore + similarityM(membersM(s),membersN(t));
                end
            end
            SimScore = SumScore/comb;
            cluster_similarity(m,n) = SimScore;
            cluster_similarity(n,m) = SimScore;
        else 
            cluster_similarity(m,n) = 0;
        end
    end
end
               
% merge initial clusters
for j= 1:length(cluster_similarity(1,:))
    [maxValue, maxInd] = sort(cluster_similarity(j,:), 'descend');
    if maxValue(1) > mergethreshold
        maxValue = find(maxValue == maxValue(1));
        for k=1:length(maxValue)
            clusters(clusters == maxInd(k)) = j;  
        end
    end
end

U = unique(clusters);
for r=1:length(U)
    clusters(clusters == U(r)) = r;
end
end