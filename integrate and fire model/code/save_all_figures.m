function save_all_figures(save_folder_path)

% Ensure the target folder exists
if ~exist(save_folder_path, 'dir')
    mkdir(save_folder_path);
end

% Get handles to all currently open figures
all_figs = findall(0, 'Type', 'figure');

% Reverse the order of figure handles
all_figs = flip(all_figs);

% Iterate through all figures and save them as PNG files
for i = 1:length(all_figs)
    fig_handle = all_figs(i);
    full_path = fullfile(save_folder_path, sprintf('%d.png', i));
    saveas(fig_handle, full_path);
end

% close
close all;

end
