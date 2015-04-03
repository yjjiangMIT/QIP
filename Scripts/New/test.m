function test(i)

workspaceDir = 'C:\Users\Yijun\Desktop\QIP\Data\Workspace';
phaseFileName = 'phase_03312015';
calibName = 'calib_03312015';
calib = importdata([workspaceDir, '\', calibName, '.mat'], 'calib');
calib