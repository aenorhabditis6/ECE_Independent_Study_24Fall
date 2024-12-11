function denoised_img = choose_denoiser(noisy_img, denoiser_type, varargin)
    % Apply selected denoiser to the input image
    % noisy_img    : Input noisy image to be denoised
    % denoiser_type: Type of denoiser to apply. Choices include:
    %                'Gaussian', 'Bilateral', 'TV', 'Wavelet', 'JNLM'
    % varargin     : Additional parameters required for specific denoisers
    %
    % Output:
    % denoised_img : Denoised image

    denoiser_type = lower(denoiser_type);

    switch denoiser_type
        case 'gaussian'
            if isempty(varargin)
                sigma = 1;
            else
                sigma = varargin{1};
            end
            denoised_img = imgaussfilt(noisy_img, sigma);

        case 'bilateral'
            if numel(varargin) < 2
                spatial_sigma = 2;
                intensity_sigma = 0.1;
            else
                spatial_sigma = varargin{1};
                intensity_sigma = varargin{2};
            end
            denoised_img = imbilatfilt(noisy_img, spatial_sigma, intensity_sigma);

        case 'tv'
            % Default values if lambda and num_iter are not provided
            if isempty(varargin)
                lambda = 0.1;
                num_iter = 50;
            elseif numel(varargin) == 1
                lambda = varargin{1};
                num_iter = 50;  % Default num_iter
            else
                lambda = varargin{1};
                num_iter = varargin{2};
            end
            % Call custom TV denoising function
            denoised_img = tv_denoise(noisy_img, lambda, num_iter);

        case 'wavelet'
            if isempty(varargin)
                neighborhood_size = [5, 5];
            else
                neighborhood_size = varargin{1};
            end
            denoised_img = wiener2(noisy_img, neighborhood_size);

        case 'jnlm'
            if numel(varargin) < 4
                error('JNLM requires guide image, patch radius, search radius, and smoothing parameter h.');
            end
            guide_img = varargin{1};
            patch_radius = varargin{2};
            search_radius = varargin{3};
            h = varargin{4};
            [denoised_img, ~] = JNLM(noisy_img, guide_img, patch_radius, search_radius, h);

        otherwise
            error('Unknown denoiser type. Choose "Gaussian", "Bilateral", "TV", "Wavelet", or "JNLM".');
    end
end