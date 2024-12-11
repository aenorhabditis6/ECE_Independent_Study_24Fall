function u = tv_denoiser(b, lambda_tv, tv_iters)
    % TV Denoiser using Chambolle's algorithm.
    %   f: Noisy input image.
    %   lambda_tv: Regularization parameter.
    %   tv_iters: Number of iterations.
    %   u: enoised image.

    tau = 0.125;  
    % Step size for dual variable update
    u = b;
    px = zeros(size(b));
    py = zeros(size(b));

    for i = 1:tv_iters
        % Compute gradients of u
        ux = [diff(u, 1, 2), u(:,1) - u(:,end)];
        uy = [diff(u, 1, 1); u(1,:) - u(end,:)];

        % Update dual variables
        px_new = px + tau * ux;
        py_new = py + tau * uy;

        % Compute projection onto the unit ball
        norm_p = max(1, sqrt(px_new.^2 + py_new.^2));
        px = px_new ./ norm_p;
        py = py_new ./ norm_p;

        % Divergence of the dual variables
        div_p = [px(:,end) - px(:,1), -diff(px,1,2)] + [py(end,:) - py(1,:); -diff(py,1,1)];

        % Update the primal variable
        u = b - lambda_tv * div_p;
    end
end
