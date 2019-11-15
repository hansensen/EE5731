function dist = get_l2_dist(img1, img2)
    dist = sqrt(sum((img2 - img1).^2,3));
end