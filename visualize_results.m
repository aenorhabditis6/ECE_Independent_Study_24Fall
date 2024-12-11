function visualize_results(x_orig, b, x_hat, psnr_vals, residues, obj_vals)
    figure('Units', 'Normalized', 'Position', [0.2, 0.6, 0.6, 0.4]);
    subplot(1, 3, 1); imshow(x_orig); title('Ground-truth image');
    subplot(1, 3, 2); imshow(b); title('Observed image');
    subplot(1, 3, 3); imshow(x_hat); title('Restored image');
    drawnow;

    figure('Units', 'Normalized', 'Position', [0.1, 0.0, 0.8, 0.4]);
    subplot(1, 3, 1); plot(psnr_vals, 'LineWidth', 2.5); grid on; axis tight;
    xlabel('Iteration'); title('PSNR');
    subplot(1, 3, 2); plot(log(residues), 'LineWidth', 2.5); grid on; axis tight;
    xlabel('Iteration'); title('Residuals (log scale)');
    subplot(1, 3, 3); plot(obj_vals, 'LineWidth', 2.5); grid on; axis tight;
    xlabel('Iteration'); title('Objective Value');
    drawnow;
end