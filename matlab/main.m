% 20180430 Beck Pang
% Initialize the shape from shaping
clc; clear;
src_path = '../../data/data02/';
icosahedron_divide_ratio = 4;
rank_L = 0.7;
rank_H = 0.9;

%% Section 4, build the simple system
%%% load light vector
light_vec_path = fopen(strcat(src_path,'lightvec.txt'));
light_vec_src = textscan(light_vec_path, '%f %f %f');
light_vec = [light_vec_src{1} light_vec_src{2} light_vec_src{3}];

%%% 4.2 Resampling the light vector
[unique_light_vec, unique_index] = resampling_light_vector(icosahedron_divide_ratio, light_vec);

%%% Load the images with only the unique light vector
[src_images, m, n] = load_images_with_unique_light_vector(src_path, unique_index);

%%% 4.3 Select the denominator image by image intensity ranking
[denominator_image, denominator_light] = select_denominator_image...
    (rank_L, rank_H, m, n, src_images, unique_light_vec);

%%% 4.4 Local normal estimation by ratio images
normal_est_image = local_normal_estimation(m, n, src_images, denominator_image, unique_light_vec, denominator_light);

% imshow( -1/sqrt(3) * normal_est_image(:,:,1) + 1/sqrt(3) * normal_est_image(:,:,2) + 1/sqrt(3) * normal_est_image(:,:,3) / 1.1);