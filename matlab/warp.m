function result = warp(im, matches)
    result = zeros(size(im));
    x = matches(:,1); y = matches(:,2); xx = matches(:,3); yy = matches(:,4);
    [H,W,C] = size(result);
    for i = 1:length(x)
       result(yy(i),xx(i),:) = im(y(i), x(i),:);
    end
end