% 20180430 Beck Pang
% Initialize the shape from shaping
clc; clear;
src_path = '../../data/data02/';
icosahedron_divide_ratio = 4;

%% load light vector
light_vec_path = fopen(strcat(src_path,'lightvec.txt'));
light_vec_src = textscan(light_vec_path, '%f %f %f');
light_vec = [light_vec_src{1} light_vec_src{2} light_vec_src{3}];


%% Resampling the light vector
[unique_light_vec, unique_index] = resampling_light_vector(icosahedron_divide_ratio, light_vec);

%% Load the images with only the unique light vector
image_files_path = dir(fullfile(src_path,'*.bmp'));

% get the basics of an image
num_images = length(image_files_path);
[m, n, ~] = size(imread(fullfile(src_path, image_files_path(1).name)));

% store the src image from color to black and white
% read the images after getting the unique vectors
unique_index_size = length(unique_index);
src_images = zeros(m, n, unique_index_size);

for i = 1:unique_index_size
    image_rgb = imread(fullfile(src_path, image_files_path(unique_index(i)).name));
    image_gray = rgb2gray(image_rgb);
    src_images(:, :, i) =  image_gray;
end
