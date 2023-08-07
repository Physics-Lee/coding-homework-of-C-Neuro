function save_and_not_close_v2(folder_path,file_name)
full_path = fullfile(folder_path,file_name);
saveas(gcf,full_path);
end