close all; clear all;

addpath('/usr/local/packages/caffe/matlab')

param.model_file = '../net/deploy.prototxt';
param.maxDisp = 25; % maximum displacement for both x and y direction
param.ratio   = 2;   % downsample scale
param.P1      = 7;   % SGM param
param.P2      = 485; % SGM param
param.outOfRange    = 0.251; % Default cost for out-of-range displacements
param.occ_threshold = 0.8;   % threshold for fwd+bwd consisntency check

run_sintel = true;
if run_sintel; model = 'sintel'; else model='kitti'; end
method = sprintf('_dcflow_%s_r%.2f_D%d', model, param.ratio, param.maxDisp);
in_folder = '../../data/sintel_h436w1024/';
match_folder = '../results/';
fn_pairs = {
    {'clean_bg_left', 'clean_bg_right'},...
    {'cluttered_bg_left', 'cluttered_bg_right'},...
    {'motion_blur_left', 'motion_blur_right'},...
    {'sit_left', 'sit_right'}};

mkdir(match_folder);

if ~run_sintel %% KITTI
  param.weight_file = '../net/kitti.caffemodel';
else %% Sintel
  param.P2 = 600;
  param.weight_file = '../net/sintel.caffemodel';
end
caffe.set_mode_gpu();
net = caffe.Net(param.model_file, param.weight_file, 'test');

for i = 1:length(fn_pairs)
    fns = fn_pairs{i};
    fns_im = add_prefix_suffix(in_folder, fns, '.png');

    % get matches
    matches = dcflow(imread(fns_im{1}), imread(fns_im{2}), param, net);

    % generate pair
    matches_pair = { matches, matches(:,[3,4, 1,2])};

    fns_match = add_prefix_suffix(match_folder, fns, [method, '_matches.txt']);
    for j = 1:length(matches_pair)
        dlmwrite(fns_match{j}, matches_pair{j}, ' ');
    end
end

function out_names = add_prefix_suffix(prefix, names, suffix)
    out_names = cell(size(names));
    for i = 1:length(names)
        out_names{i} = [prefix, names{i}, suffix];
    end
end
