function save_and_close(folder_path,file_name,ext_str)
full_path = fullfile(folder_path,file_name);
saveas(gcf,full_path,ext_str);
close;
end