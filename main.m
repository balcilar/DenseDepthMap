% Written by Muhammet Balcilar, France
% All rights reserved

clear all
close all
clc

I=imread('data/image_2/0000000001.png');

%% read calibration file

fd = fopen('data/calib/000001.txt');
raw_data = fscanf(fd,'%c');
fclose(fd);

ii = find(raw_data == ':')+1;
ie = find(raw_data == 10 );

P0 = reshape(str2num( raw_data(ii(1):ie(1)) ),4,3)';
P1 = reshape(str2num( raw_data(ii(2):ie(2)) ),4,3)';
P2 = reshape(str2num( raw_data(ii(3):ie(3)) ),4,3)';
P3 = reshape(str2num( raw_data(ii(4):ie(4)) ),4,3)';
R0_rect = reshape(str2num( raw_data(ii(5):ie(5)) ),3,3)';
Tr_velo_to_cam = reshape(str2num( raw_data(ii(6):ie(6)) ),4,3)';
Tr_imu_to_velo = reshape(str2num( raw_data(ii(7):ie(7)) ),4,3)';

%% read Lidar data file
fd = fopen('data/velodyne/0000000001.bin','rb');
velo = fread(fd,[4 inf],'single')';
fclose(fd);

% remove all points behind image plane (approximation)
idx = velo(:,1)<5;
velo(idx,:) = [];

% exclude luminance make last column all 1
velo(:,4)=1;

% draw raw point cloud
figure;
plot3(velo(:,1),velo(:,2),velo(:,3),'r.');
title('Raw point Cloud');

% project to image plane 
P2(4,4)=1;
R0_rect(4,4)=1;
Tr_velo_to_cam(4,4)=1;
px = (P2 * R0_rect * Tr_velo_to_cam * velo')';

px(:,1) = px(:,1)./px(:,3);
px(:,2) = px(:,2)./px(:,3);

% remove out of image size indexes
px(px(:,1)<1,:)=[];
px(px(:,1)>size(I,2),:)=[];    
px(px(:,2)>size(I,1),:)=[];

[n m k]=size(I);

tic
[fulldepth depth] =dense_depth_map(px,n, m,4);
toc

figure;imagesc(fulldepth,[0 30]);
axis image
axis off
title('Full Depth map grid=4');

figure;imagesc(depth);
axis image
axis off
title('Initial Depth map');


% Composite image of grayscale left image and disparity map 

tmp(:,:,1) = double(rgb2gray(I))/255;
tmp(:,:,2) =tmp(:,:,1);
tmp(:,:,3) =tmp(:,:,1);

dmap=1./fulldepth;
dmap(isinf(dmap))=0;
dmap=63*(dmap-min(dmap(:)))./(max(dmap(:))-min(dmap(:)));
dmap=round(dmap);


figure;sc= colormap('jet');
DisparityImage = 0.5*tmp + 0.5*reshape(sc(dmap+1,:), [n,m ,3]);
imshow((DisparityImage));title('Inverse of Depth');


