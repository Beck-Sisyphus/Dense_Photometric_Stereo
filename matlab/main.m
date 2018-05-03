% 20180430 Beck Pang
% Initialize the shape from shaping
clc; clear;
src_path = '../../data/data08/';
addpath('./gco/matlab');
icosahedron_divide_ratio = 5;
rank_L = 0.7;
rank_H = 0.9;

%% Section 4, build the simple system
%%% load light vector
light_vec_path = fopen(strcat(src_path,'lightvec.txt'));
light_vec_src = textscan(light_vec_path, '%f %f %f');
light_vec = [light_vec_src{1} light_vec_src{2} light_vec_src{3}];

%%% 4.2 Resampling the light vector
[unique_icosa_ver, unique_light_vec, unique_index] = resampling_light_vector(icosahedron_divide_ratio, light_vec);

%%% Load the images with only the unique light vector
[src_images, m, n] = load_images_with_unique_light_vector(src_path, unique_index);

%%% 4.3 Select the denominator image by image intensity ranking
[denominator_image, denominator_light, denominator_index] = select_denominator_image...
    (rank_L, rank_H, m, n, src_images, unique_light_vec);

%%% 4.4 Local normal estimation by ratio images
normal_est_image = local_normal_estimation(m, n, src_images, denominator_image, unique_light_vec, denominator_light);

% imshow( -1/sqrt(3) * normal_est_image(:,:,1) + 1/sqrt(3) * normal_est_image(:,:,2) + 1/sqrt(3) * normal_est_image(:,:,3) / 1.1);

%% Graph cut method
lambda = 0.5;
sigma  = 0.5;

tic;

ico_vertice = icosahedron_construction(1 / icosahedron_divide_ratio);
[image_width,image_length,~] = size(normal_est_image);
ico_size = size(ico_vertice);

normal_label = zeros(m, n);
for i = 1:m
    for j = 1:n
        d = (ico_vertice(:, 1) - normal_est_image(i, j, 1)).^2 + ...
            (ico_vertice(:, 2) - normal_est_image(i, j, 2)).^2 + ...
            (ico_vertice(:, 3) - normal_est_image(i, j, 3)).^2;
        [~, index] = min(d);
        normal_label(i, j) = index;
    end
end
label = reshape(normal_label, 1, [])';

normal_vec_flat = zeros(m * n, 3);
for p = 1:3
    normal_vec_flat(:, p) = reshape( normal_est_image(:, :, p), [m * n, 1]);
end

h = GCO_Create(m * n, ico_size); % (NumSites, NumLabels)
GCO_SetLabeling(h, label);

data_cost = int32( pdist2( ico_vertice, normal_vec_flat ));
GCO_SetDataCost(h, data_cost);

smooth_cost = pdist2( ico_vertice, ico_vertice);
smooth_cost = int32 ( lambda * log10 ( 1 + smooth_cost / (2*sigma*sigma)));
GCO_SetSmoothCost(h, smooth_cost);

si = zeros( (m - 1) * n + (n - 1) * m, 1);
for i = 1:n
    for j = 1:m-1
        si(j + (i-1) * (m-1)) = j + (i-1) * m;
    end
end
for i = 1:n-1
    for j = 1:m
        si((m-1) * n + (i-1) * m + j) = j + (i-1)*m;
    end
end

sj = zeros((m-1) * n + (n-1) * m, 1);
sv = ones ((m-1) * n + (n-1) * m, 1);

for i = 1:n
    for j = 1:m-1
        sj(j + (i-1) * (m-1)) = j+1 + (i-1) * m;
    end
end

for i = 1:n-1
    for j = 1:m
        sj( (m-1) * n + (i-1) * m + j) = j + i * m;
    end
end

S = sparse(si, sj, sv, n * m, n * m);
GCO_SetNeighbors(h, S);
GCO_Expansion(h);
labeling = GCO_GetLabeling(h);
GCO_Delete(h);

refined_normal = zeros(m, n, 3);
for i = 1:m
    for j = 1:n
        refined_normal(i, j, :) = ico_vertice( labeling( (j-1)*m + i), :);
    end
end

toc;

%% shape from shapelets
scale = 4;
slant = zeros(m, n);
tilt  = zeros(m, n);

for i = 1:m
    for j = 1:n
%         T = normal_est_image(m + 1 - i, j, :);
        T = refined_normal(m + 1 - i, j, :);
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