%%% 4.4 Local normal estimation by ratio images
%%% Input: source images, source light vector
%%% Input: denominator_image, denominator_light
%%% Output: normal estimated image, (m, n, 3)
function normal_est_image = local_normal_estimation(m, n, src_images, denominator_image, unique_light_vec, denominator_light)
tic;
unique_index_size = length(unique_light_vec);
for k = 1:unique_index_size
    src_images(:, :, k) = src_images(:, :, k)./denominator_image;
end

normal_est_image = zeros(m, n, 3);

for i = 1:m
    for j = 1:n
        normal_est_A = reshape(src_images(i, j, :), [], 1) * denominator_light(1) - unique_light_vec(:, 1);
        normal_est_B = reshape(src_images(i, j, :), [], 1) * denominator_light(2) - unique_light_vec(:, 2);
        normal_est_C = reshape(src_images(i, j, :), [], 1) * denominator_light(3) - unique_light_vec(:, 3);
        normal_est = [normal_est_A normal_est_B normal_est_C];
        [~, ~, normal_est_V] = svd(normal_est);
        x = normal_est_V(:, 3);
        if x(3) < 0
            x = -x;
        end
        normal_est_image(i, j, :) = x;
    end
end
toc;

end