function MoCorr = calcMoCorr(imgA, imgB)
    dim = length(imgA(:,1))*length(imgA(1,:));
        
    imgA(isnan(imgA)) = 0;
    imgB(isnan(imgB)) = 0;
    
    % hot spot removal
    qA = quantile(imgA(:),0.99);
    imgA(imgA>qA) = qA;
    qB = quantile(imgB(:),0.99);
    imgB(imgB>qB) = qB;
    
    % normalize to [0,1]
    img_normA = imgA./(max(max(imgA))); 
    img_normB = imgB./(max(max(imgB))); 
    
    % flatten images
    flat_A = reshape(img_normA, dim, 1);
    flat_B = reshape(img_normB, dim, 1);
    
    A_B = [flat_A, flat_B];
    
    % compute correlation coefficient
    C = corrcoef(A_B);
    MoCorr = C(1,2);
end