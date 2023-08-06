clc;clear;close all;
r = 10;
number_of_neurons = 277;

%% draw points in model of neurons
theta = 0:2*pi/277:2*pi-2*pi/277;
x = r .* cos(theta); % vector-programming
y = r .* sin(theta); % vector-programming
scatter(x,y);
axis equal;
bound = 1.2 * r;
xlim([-bound,+bound]);
ylim([-bound,+bound]);
hold on;

%% read the file
% M = csvread('celegans277matrix.csv');
fileID = fopen('celegans277matrix.txt','r');
% for i = 1:number_of_neurons
%     for j = 1:number_of_neurons
%         if M(i,j) == 1
%             fprintf(fileID,'%d %d 1\n',i,j);
%         end
%     end
% end
size = [3 Inf];
edge_matrix = fscanf(fileID,'%d',size);
edge_matrix = edge_matrix';

%% use quiver to draw a line segment with an arrow between 2 points
X = x(edge_matrix(:,1));
Y = y(edge_matrix(:,1));
U = x(edge_matrix(:,2)) - x(edge_matrix(:,1));
V = y(edge_matrix(:,2)) - y(edge_matrix(:,1));
quiver(X,Y,U,V,'off')

%% draw the histogram of in-number and out-number
in_number = zeros(number_of_neurons,1);
out_number = zeros(number_of_neurons,1);

bin_width = 0.5;
edges = [0 0:bin_width:50 50];

count = 0;
for i = 1:number_of_neurons
    for j = 1:length(edge_matrix)
        if edge_matrix(j,1) == i
            count = count + 1;
        end
    end
    out_number(i) = count;
    count = 0;
end
figure(2)
histogram(out_number,edges);
title('out nubmer');

count = 0;
for i = 1:number_of_neurons
    for j = 1:length(edge_matrix)
        if edge_matrix(j,2) == i
            count = count + 1;
        end
    end
    in_number(i) = count;
    count = 0;
end
figure(3)
histogram(in_number,edges);
title('in nubmer');