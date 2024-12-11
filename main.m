function main()
    x_orig = im2double(imread('house.tif'));
    if size(x_orig, 3) == 3
        x_orig = rgb2gray(x_orig);
    end

    kernel = fspecial('gaussian', [7 7], 2);
    A = @(x) imfilter(x, kernel, 'conv', 'circular');
    A_transpose = @(x) imfilter(x, kernel, 'conv', 'circular');

    % Generate noisy image b
    noise_sigma = 0.05;
    b = A(x_orig) + noise_sigma * randn(size(x_orig));
    b = min(max(b, 0), 1);

    x0 = b; 
    s0 = x0;

    % Parameters
    % For TV
    lambda_tv = 0.1;
    tv_iters = 50;

    % General
    lambda = 0.1; % Regularization for obj
    num_iter = 50;
    step = 0.01;

    obj = zeros(1, num_iter);
    psnr_list = zeros(1, num_iter);
    residues = zeros(1, num_iter);

    for k = 1:num_iter
        x_prev = x0;

        grad = A_transpose(A(x0) - b);
        z = x0 - step * grad;

        s = tv_denoiser(z, lambda_tv, tv_iters);
        s = min(max(s, 0), 1); 

        theta = 2 / (k + 2); % From Nasterov
        x0 = (1 - theta) * s + theta * s0;
        s0 = s;

        f = eval_fidelity_deblurring(x0, A, b);
        g = eval_regularizer_tv(x0);

        obj(k) = f + lambda * g;
        psnr_list(k) = psnr(x0, x_orig);
        residues(k) = norm(x0 - x_prev, 'fro');
    end

    visualize_results(x_orig, b, x0, psnr_list, residues, obj);
end