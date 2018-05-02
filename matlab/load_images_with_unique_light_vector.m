%%% Helper function to load images with only the unique light vector
function [src_images, m, n] = load_images_with_unique_light_vector(src_path, unique_index)
image_files_path = dir(fullfile(src_path,'*.bmp'));

% get the basics of an image
% num_images = length(image_files_path);
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

end