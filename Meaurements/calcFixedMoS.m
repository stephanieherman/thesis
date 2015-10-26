function MoS = calcFixedMoS(imgA, imgB)
    
    dim = length(imgA(:,1))*length(imgA(1,:));
    
    % hot spot removal
    qA = quantile(imgA(:),0.99);
    imgA(imgA>qA) = qA;
    
    qB = quantile(imgB(:),0.99);
    imgB(imgB>qB) = qB;
    
    % normalize to [0,1]
    img_normA = imgA./(max(max(imgA))); 
    img_normB = imgB./(max(max(imgB))); 
    
    % flatten images
    flat_A = reshape(img_normA, 1, dim);
    flat_B = reshape(img_normB, 1, dim);
    
    % find signals above threshold
    signals_A = find(flat_A(:)>median(flat_A(flat_A>0)));
    signals_B = find(flat_B(:)>median(flat_B(flat_B>0)));
        
    % find shared signals
    shared = intersect(signals_A, signals_B);
    MoS = length(shared)/(mean([length(signals_A), length(signals_B)]));
end

        