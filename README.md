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
The ```icosahedron_cosntruction.m``` and ```subdivide.m``` handle the generation of the creation of a subdivided half icosahedron to uniformly resample the light vector. And ```resampling_light_vector.m``` find the one light vectors closest to the resample base. 
<img src="https://github.com/Beck-Sisyphus/Dense_Photometric_Stereo/blob/master/results/icosahedron.jpg">

### Load the images with only the unique light vector


### Select the denominator image
 by image intensity ranking

### Local normal estimation 
by ratio images

## Plot the normal image using shape from shapelet reconstruction
Select the scale for each image. Then create the slant and tilt, the toolbox handles for us. Notice that the final image will rotate by 90
