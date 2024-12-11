function f = eval_fidelity_deblurring(x, A, b)
    % EVAL_FIDELITY_DEBLURRING - Computes the data fidelity term.
    % Input:
    %   x - Current estimate of the image.
    %   A - Degradation operator.
    %   b - Observed image.
    % Output:
    %   f - Value of the data fidelity term.

    residual = A(x) - b;
    f = 0.5 * sum(residual(:).^2);
end