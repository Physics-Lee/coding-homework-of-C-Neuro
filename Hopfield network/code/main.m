clc;clear;close all;
for ii = 1:10
    fraction_of_perfect_recall_vs_fraction_of_corrupted_bits;
    folder_path = 'F:\1_learning\class\computational neuroscience\coding homework of C Neuro\Hopfield network\result\SD';
    file_name = ['group_' num2str(ii) '.png'];
    full_path = fullfile(folder_path,file_name);
    saveas(gcf,full_path);
    close;
end