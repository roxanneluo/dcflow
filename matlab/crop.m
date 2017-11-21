function result = crop(im, desired_size)
    im_size = size(im); im_size = im_size(1:2);
    result = imresize(im, max(desired_size./im_size));
    new_size = size(result); new_size = new_size(1:2);
    bl = [1, (new_size(2)-desired_size(2))/2];
    result = imcrop(result, [bl(2), bl(1), desired_size(2), desired_size(1)]);
end