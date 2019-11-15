function projected_pixels  = get_projected_pixel(first_term, second_term_with_disparity_i,...
    H, W)

% calculate x_prime_h and normalize last term to be 1
x_prime_h = first_term + repmat(second_term_with_disparity_i,1,H*W);
x_prime_h(1,:) = round(x_prime_h(1,:)./x_prime_h(3,:));
x_prime_h(2,:) = round(x_prime_h(2,:)./x_prime_h(3,:));
x_prime_h(3,:) = 1;
% fix boundary cases
x_prime_h(2,x_prime_h(2,:) <1) = 1;
x_prime_h(2,x_prime_h(2,:)>H) = H;
x_prime_h(1,x_prime_h(1,:) <1) = 1;
x_prime_h(1,x_prime_h(1,:)>W) = W;

projected_pixels = x_prime_h(1,:)+(x_prime_h(2,:)-1)*W;

end