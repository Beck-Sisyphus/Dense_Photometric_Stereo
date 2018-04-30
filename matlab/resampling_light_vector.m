function [unique_light_vec, unique_index] = resampling_light_vector(icosahedron_divide_ratio, light_vec)
icosa_ver = icosahedron_construction(1 / icosahedron_divide_ratio);
icosa_size = size(icosa_ver, 1);
% resampled_ver = zeros(icosa_size, 3);
resampled_index  = zeros(icosa_size, 1);
light_x = light_vec(:, 1);
light_y = light_vec(:, 2);
light_z = light_vec(:, 3);
for i = 1:icosa_size
    icosa_x = icosa_ver(i, 1);
    icosa_y = icosa_ver(i, 2);
    icosa_z = icosa_ver(i, 3);
    
    distance =  (light_x - icosa_x).^2 + (light_y - icosa_y).^2 + (light_z - icosa_z).^2;
    [~, order] = sort(distance);
    resampled_index(i)  = order(1);
%     resampled_ver(i, :) = [light_x(order(1)), light_y(order(2)), light_z(order(3))];
end
% scatter3(resampled_ver(:,1), resampled_ver(:,2), resampled_ver(:,3));

% get sorted unique index and light vectors
unique_index = unique(resampled_index);
unique_index_size = length(unique_index);
unique_light_vec  = zeros(unique_index_size, 3);
for i = 1:unique_index_size
    unique_light_vec(i, :) = [light_x(unique_index(i)) light_y(unique_index(i)) light_z(unique_index(i))];
end
end