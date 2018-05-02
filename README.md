# Dense_Photometric_Stereo
HKUST COMP 5421 dense photometric stereo using two methods, linear regression and graph cut.

The main algorithm is based on Tai-Pang Wu and Chi-Keung Tang, **Dense Photometric Stereo Using a Mirror Sphere and Graph Cut**, *IEEE Computer Society Conference on Computer Vision and Pattern Recognition* (2005) pp 140-147. You may find the reference with the following link: [Dense Photometric Stereo Using a Mirror Sphere and Graph Cut](https://ieeexplore.ieee.org/document/1467260/).<br>

Graph Cut maxflow algorithm toolbox downloaded from *http://vision.ucla.edu/~brian/gcmex.html*.

Shape from shapelet reconstruction is from Peter Kovesi, **Shapelets Correlated with Surface Normals Produce Surfaces**. *IEEE International Conference on Computer Vision*. (2005) pp 994-1001. Toolbox downloaded from *http://www.csse.uwa.edu.au/~pk/Research/MatlabFns/*.

Main reference code is from Mao Hongzi's work *https://github.com/hongzimao/shapeFromShading*, Thanks to him.

# Code explains
We follows the steps in the paper. First, to construct a simple system, we use only linear regression to generate the normal image. After all the parts are tested, we move on the graph cut based combination optimization to get shaper edges.

## The simple system
### Resampling the light vector
The ```icosahedron_cosntruction.m``` and ```subdivide.m``` handle the generation of the creation of a subdivided half icosahedron to uniformly resample the light vector. And ```resampling_light_vector.m``` find the one light vectors closest to the resample base. To create a icosahedron, we follow the instruction in the ```/reference/uniform_sampling.jpg``` to get each vertices and midpoints from the gloden ratio. To subdivide the icosahedron, a simple method to divide the edge evenly and create a triangle is used. To find the closest light vector, we sorted the light vectors by its distance to the resulted vertices and select the top.

<img src="https://github.com/Beck-Sisyphus/Dense_Photometric_Stereo/blob/master/results/icosahedron.jpg" width="888" height="628">

### Load the images with only the unique light vector
After the light vectors are selected, since the light vector and the data are indexed in the same order, we only read the image indexes the same as the light vectors. 

### Select the denominator image
The denominator image is selected by image intensity ranking. The ideal denominator image is free from shadows and highlight. Using only the gray scale image, the pixel intensity is defined by its pixel value. At each pixel, we sorted through all images and recreate a set of pixel rank images. Then the image is selected by two categories: 
1. To remove shallows, the image should have the maximum number of pixels with each pixel ranking higher than 70th percentiles;
2. To remove highlights, the mean rank amount the image should be lower than 90th percentiles.

### Local normal estimation 
The local normal estimation from the ratio images to remove the unknown light amount. For each pixel, k-1 set of equations are formed. The normal is estimated by linear regression, by minimizing the l2 norm of x * A * A' * x'. Using the singular-value decomposition, and get the eigen vector regarding to the smallest eigen value, we have the normal vector.

## Plot the normal image using shape from shapelet reconstruction
Select the scale for each image. Then create the slant and tilt, the toolbox handles for us. Notice that the final image will rotate by 90

# results
The images could be found in ```/results```


```matlab
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

```
