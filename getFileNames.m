function [ files ] = getFileNames(folderDir)
% [ files ] = getFileNames(folderDir)
% Give a string list of all .mat files under a certain folder

fileFolder = fullfile(folderDir);
dirOutput = dir(fullfile(fileFolder, '*.mat'));
fileNames = {dirOutput.name};
for i = 1 : length(fileNames)
    files = [folderDir, '\', cell2mat(fileNames(i))];
end