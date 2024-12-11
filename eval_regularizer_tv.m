function g = eval_regularizer_tv(x)
    % EVAL_REGULARIZER_TV - Computes the total variation (TV) regularizer.
    % Input:
    %   x - Input image.
    % Output:
    %   g - Value of the TV regularization term.

    % grad_x = [diff(x, 1, 2), zeros(size(x,1),1)];
    % grad_y = [diff(x, 1, 1); zeros(1,size(x,2))];

    % Periodic boundary
    grad_x = x - circshift(x, [0, 1]);
    grad_y = x - circshift(x, [1, 0]);

    % Numerical stability
    epsilon = 1e-8;

    tv_norm = sum(sum(sqrt(grad_x.^2 + grad_y.^2 + epsilon)));
    g = tv_norm;
end