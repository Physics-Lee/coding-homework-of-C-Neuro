clc; clear; close all;
wII_range = 1.1;
c_out_range = 0.0:0.2:1.0;
result = seizure_detection(wII_range, c_out_range);

figure;
imagesc(c_out_range,wII_range,result);
xlabel('c-out');
ylabel('w-II');
title('I Population Activity');
colorbar;