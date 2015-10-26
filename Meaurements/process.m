%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%The function process normalizes the data (depending on the highest value) and then
%transforms each image into a binary vector, depending on a certain threshold
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output=process(img_cube)

vec_length = length(img_cube(:,1,1))*length(img_cube(1,:,1));
output = zeros(length(img_cube(1,1,:)), vec_length);

%Normalizing the data of each image and transforming the values to either 0
%or 1, depending on a threshold
for i=1:length(img_cube(1,1,:))
    img = img_cube(:,:,i); %extract one image
    %img(isnan(img)) = 0; % Set all NaN's in the image as zeros
    
    % hot spot removal
    q = quantile(img(:),0.99);
    img(img>q) = q;
    
    img_norm = img./(max(max(img))); % Normalize to [0,1]
    
    % set threshold
    threshold = median(img_norm(img_norm>0));
    %threshold = 1; %4 * min_intensity;
    
    for x=1:length(img_norm(:,1))
        for y=1:length(img_norm(1,:))
            if img_norm(x,y) >= threshold
                img_norm(x,y) = 1;
            else
                img_norm(x,y) = 0;
        end
        end
    end
    flatten_img = reshape(img_norm, vec_length, 1);
    output(i,:) = flatten_img;
end

disp('Images normalized and transformed to binary vectors');

end


