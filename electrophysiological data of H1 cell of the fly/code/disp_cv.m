function disp_cv(isi_ideal)

fprintf('Mean: %.4f\n', mean(isi_ideal));
fprintf('Standard Deviation: %.4f\n', std(isi_ideal));
fprintf('Coefficient of Variation: %.4f\n', std(isi_ideal)/mean(isi_ideal));

end