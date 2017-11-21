close all; clear all;

addpath('/usr/local/packages/caffe/matlab')

param.model_file = '../net/deploy.prototxt';
param.maxDisp = 25; % maximum displacement for both x and y direction
param.ratio   = 3;   % downsample scale
param.P1      = 7;   % SGM param
param.P2      = 485; % SGM param
param.outOfRange    = 0.251; % Default cost for out-of-range displacements
param.occ_threshold = 0.8;   % threshold for fwd+bwd consisntency check

if 0 %% KITTI
  param.weight_file = '../net/kitti.caffemodel';
  im1 = imread('../data/000000_10.png');
%   im2 = imread('../data/000000_11.png');
  im_size = size(im1); im_size = im_size(1:2)
%   im1 = imread('../data/left00004140.png');
%   im2 = imread('../data/right00004173.png');
im1 = imread('../data/left00000729.png');
  im2 = imread('../data/right00000736.png');
    im1 = crop(im1, im_size);
  im2 = crop(im2, im_size);
  
else %% Sintel
  param.P2 = 600;
  param.weight_file = '../net/sintel.caffemodel';
 %   im2 = imread('../data/frame_0002.png');
%   im_size = size(im1); im_size = im_size(1:2)
%   im1 = imread('../data/left00004140.png');
%   im2 = imread('../data/right00004173.png');
im1 = imread('../../data/sintel_h436w1024/sit_left.png');
  im2 = imread('../../data/sintel_h436w1024/sit_right.png');
  
end

caffe.set_mode_gpu();
net = caffe.Net(param.model_file, param.weight_file, 'test');

matches = dcflow(im1, im2, param, net);
dlmwrite('sit_left_matches.txt', matches, ' ');

