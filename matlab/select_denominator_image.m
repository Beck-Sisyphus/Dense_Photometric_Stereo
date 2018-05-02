%%% 4.3 select denominator image
%%% @output: denominator_image, (m, n)
%%% @output: denominator_light, (3, 1)
function [denominator_image, denominator_light, denominator_index] = select_denominator_image(rank_L, rank_H, m, n, src_images, unique_light_vec)
unique_index_size = length(unique_light_vec);
rank_L = rank_L * unique_index_size;
rank_H = rank_H * unique_index_size;
rank_L_count = zeros(unique_index_size, 1);
rank_L_sum   = zeros(unique_index_size, 1);

% [test_B, test_index] = sort(src_images(1, 1, :))
rank_image = zeros(m, n, unique_index_size);
for i = 1:m
    for j = 1:n
        [~, index] = sort(src_images(i, j, :));
        rank_image(i, j, :) = index;
    end
end

for k = 1:unique_index_size
    for i = 1:m
        for j = 1:n
            if rank_image(i, j, k) > rank_L
                rank_L_count(k) = rank_L_count(k) + 1;
                rank_L_sum(k)   = rank_L_sum(k) + rank_image(i, j, k);
            end
        end
    end
end

[~, index] = sort(rank_L_count);
k = unique_index_size;
while rank_L_sum(index(k)) / rank_L_count(index(k)) > rank_H
    k = k - 1;
end

denominator_image = src_images(:, :, index(k));
denominator_light = unique_light_vec(index(k), :);
denominator_index = index(k);
% imshow(uint8(denominator_image));

end