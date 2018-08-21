# Full Dense Depth Map Image for Known Poisitioned Camera from Lidar Point Cloud

Lidar sensors can supply us great information about circumferences and those information are very crucial for many automatic robotic application such as self-driving car. Although, Lidar sensor gives us 360 degree of view point cloud and it is quite dense, if we want to match any camera images within those point cloud, the depth map for certain camera become pretty sparse and it is far behind to use that matched depth information for any purpose.

In this project, we are focusing on reading point cloud, camera image and calibration parameters from sample Kitti dataset [1] and create dense depth image for certain camera whose translation and rotations are known. Here is a view of the point cloud.

![Sample image](Output/pointcloud.jpg?raw=true "Title")

In dataset, there are camera2 and camera3's rgb images and their projection's in calibration file. We read that calibration and create 3x4 dimensioned projection matrix *P* which transform *[X;Y;Z;1]* vector into pixel location into camera2 frame. Here is the camera image in the following image.

![Sample image](data/image_2/0000000001.png?raw=true "Title")

To do that projection, we use standard projection process which P,X,Y,Z are known but λ, x, y parameters are to be estimated.

*λ.[x;y;1]=P.[X;Y;Z;1]*

we can solve above equaiton and find each point's projection on to the image plane shown by (x,y). So we can set λ into (x,y)'s depth information. Basically we can create a map whose element is *Map(x,y)=λ*.

But this *Map* become too sparse. According to out test, we can see only 6% of the Map's indexes has value. To get rid of that problem, we calculate not just depth info of *(x,y)* location but also *ngird* number of left and right bottom and up locations depth information too. For instance is *ngrid=4*, it means we used 9x9 neighbourhood and we calculate weighted depth information according to distance of the neighbourhood. Basically we used distance of neightborhood as a weight of sum process. Here is the result of initial depth map without any process, and depth map with 1,2,3,4 and 5 grid size.

![Sample image](Output/depthimages.jpg?raw=true "Title")

As you can see, the quality of depth map increase by grid size. But note that the larger grid size, the more computational time. In our tests it needs almost 1 second for ngid=4 with single cpu implementataion. We tried to write matlab code efficient to avoid using loops.

To evaluate depth and image matching, you can see both inverse of depth map and camera image together by following image.

![Sample image](Output/inversedepth.jpg?raw=true "Title")

You can find c++ implementation of another method in reference[2]

## Reference
[1] Geiger, Andreas, et al. "Vision meets robotics: The KITTI dataset." The International Journal of Robotics Research 32.11 (2013): 1231-1237.

[2] Premebida, Cristiano, et al. "High-resolution LIDAR-based depth mapping using bilateral filter." arXiv preprint arXiv:1606.05614 (2016).
