function [ files ] = getFileNames( folderDir )
% [ files ] = getFileNames( folderDir )
% Give a string cell of all .mat files under a certain folder

fileFolder = fullfile(folderDir);
dirOutput = dir(fullfile(fileFolder, '*.mat'));
fileNames = {dirOutput.name};
files = cell(1, length(fileNames));
for i = 1 : length(fileNames)
    files(i) = {[cell2mat(fileNames(i))]};
end