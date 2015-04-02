fileFolder = fullfile('/afs/athena.mit.edu/user/k/a/kakkarav/Desktop/QIP/03312015/Data_03312015/RawData_03312015/RawDataT90_03312015');
dirOutput = dir(fullfile(fileFolder, '*.mat'));
fileNames = {dirOutput.name};