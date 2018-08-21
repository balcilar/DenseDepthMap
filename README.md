# Full Dense Depth Map Image for Known Poisitioned Camera from Lidar Point Cloud

Lidar sensors can supply us great information about circumferences and those information are very crucial for many automatic robotic application such as self-driving car. Although, Lidar sensor gives us 360 degree of view point cloud and it is quite dense, if we want to match any camera images within those point cloud, the depth map for certain camera become pretty sparse and it is far behind to use that matched depth information for any purpose.

In this project, we are focusing on reading point cloud, camera image and calibration parameters from sample Kitti dataset [1] and create dense depth image for certain camera whose translation and rotations are known.


## Reference
[1] Geiger, Andreas, et al. "Vision meets robotics: The KITTI dataset." The International Journal of Robotics Research 32.11 (2013): 1231-1237.

[2] Premebida, Cristiano, et al. "High-resolution LIDAR-based depth mapping using bilateral filter." arXiv preprint arXiv:1606.05614 (2016).
