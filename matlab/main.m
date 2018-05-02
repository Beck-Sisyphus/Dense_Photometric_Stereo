% 20180430 Beck Pang
% Initialize the shape from shaping
clc; clear;
src_path = '../../data/data10/';
icosahedron_divide_ratio = 5;
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
[denominator_image, denominator_light, denominator_index] = select_denominator_image...
    (rank_L, rank_H, m, n, src_images, unique_light_vec);

%%% 4.4 Local normal estimation by ratio images
normal_est_image = local_normal_estimation(m, n, src_images, denominator_image, unique_light_vec, denominator_light);

imshow( -1/sqrt(3) * normal_est_image(:,:,1) + 1/sqrt(3) * normal_est_image(:,:,2) + 1/sqrt(3) * normal_est_image(:,:,3) / 1.1);

%% shape from shapelets
scale = 4;
slant = zeros(m, n);
tilt  = zeros(m, n);

for i = 1:m
    for j = 1:n
        T = normal_est_image(m + 1 - i, j, :);
        x = T(1);
        y = T(2);
        z = T(3);
        dzdx = - x / z;
        dzdy = - y / z;
        [slant(i, j), tilt(i, j)] = grad2slanttilt(dzdx, dzdy);
    end
end

recsurf = shapeletsurf(slant, tilt, 8, 1, 2, 'slanttilt');
recsurf = recsurf / scale;

% plot
[x, y] = meshgrid(1:n, 1:m);
figure;
surf(x, y, recsurf, 'EdgeColor', 'none');
camlight right;
lighting phong;
axis equal;
axis vis3d;
axis off;

%% Results 
% dataset   scale   samples denominator_index   time
% data02        2       220     206     1.745762
% data03        4       344     298     5.750543 
% data04        4       354     354     6.741049
% data05        4       334     326     8.101798
% data06        4       348     348     9.162170
% data07        6       365     351     8.628281 
% data08        6       359     346     9.654362
% data09        6       365     299     11.449866
% data10        4       373     373     12.705782