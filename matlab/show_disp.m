function [disp, min_d, max_d] = show_disp(matches, im_size)
    disp = zeros(im_size);
    x = matches(:,1); y = matches(:,2); xx = matches(:,3); yy = matches(:,4);
    H = im_size(1);
    disp((x-1)*H+y) = yy-y;
    
    min_d = min(min(disp));
    max_d =max(max(disp));
    
    figure();imshow(max_d - disp, jet(max_d - min_d+1));
end