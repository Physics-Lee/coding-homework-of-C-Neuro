% MATLAB Script to Save All Open Figures
% Customize the save directory
saveDir = uigetdir(pwd, 'Select Directory to Save Figures');

if saveDir == 0
    disp('No directory selected. Exiting.');
    return;
end

% Get all figure handles
figHandles = findall(0, 'Type', 'figure');

if isempty(figHandles)
    disp('No figures are currently open.');
    return;
end

% Loop through each figure
for i = 1:length(figHandles)
    figHandle = figHandles(i);
    figureName = sprintf('Figure_%d', figHandle.Number); % Create a unique name
    
    % Save as .png
    saveas(figHandle, fullfile(saveDir, [figureName, '.png']));
    
    % Save as .fig (MATLAB figure file)
    % savefig(figHandle, fullfile(saveDir, [figureName, '.fig']));
end

disp(['All figures have been saved to ', saveDir]);
