function [ calib ] = loadCalib( folderDir, calibName )
% [ calib ] = loadCalib( folderDir, calibName )
% Load a struct named calib

load([folderDir, '\', calibName, '.mat'], 'calib');