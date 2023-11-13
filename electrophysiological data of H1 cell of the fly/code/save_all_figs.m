% save all figs in the save folder path
%
% Yixuan Li, 2023-11-13
%

function save_all_figs(save_folder_path)

create_folder(save_folder_path);

% Get a list of all open figures
figHandles = findall(groot, 'Type', 'figure');

% Iterate through each figure and save it
for i = 1:length(figHandles)
    figure = figHandles(i);

    % Construct a filename for each figure
    filename = fullfile(save_folder_path, sprintf('figure_%d.png', figure.Number));

    % Save the figure
    saveas(figure, filename);
end

end