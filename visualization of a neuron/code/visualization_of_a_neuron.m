%% clear
clc;clear;close all;

%% import data
prompt = "Which file do you want to see?" + newline + "1: pyramidal dendrite" + newline + "2: Purkinje dendrite" + newline + "3: arbor from larval zebrafish \n";
file = input(prompt);
switch file
    case 1
        data_imported = importdata('../data/1 pyramidal dendrite.txt');
    case 2
        data_imported = importdata('../data/2 Purkinjie dendrite.txt');
    case 3
        data_imported = importdata('../data/3 arbor from larval zebrafish.txt');
end
segment_index = data_imported(:,1);
segment_type = data_imported(:,2);
X = data_imported(:,3);
Y = data_imported(:,4);
Z = data_imported(:,5);
segment_diameter = data_imported(:,6);
father_segment_index = data_imported(:,7);
length_of_point = length(X);
fprintf("The number of the point is %d \n",length(X));

%% draw graph
prompt = "Do you want to draw the graph?" + newline + "1: Yes" + newline + "2: No \n";
flag = input(prompt);
switch flag
    case 1
        prompt = "Which method do you want to use to draw the graph?" + newline + "1: mesh function of matlab" + newline + "2: scatter3 function of matlab \n";
        method = input(prompt);
        switch method
            case 1
                for i = 1:length(segment_index)
                    [x,y,z] = sphere();
                    radius = segment_diameter(i)/2;
                    mesh(radius*x+(X(i)),radius*y+(Y(i)),radius*z+(Z(i)));
                    hold on;
                end
            case 2
                scatter3(X,Y,Z,segment_diameter);
        end
        
        % decorate
        axis equal;
        xlabel('x axis');
        ylabel('y axis');
        zlabel('z axis');
        switch file
            case 1
                title('dendrites of a pyramidal cell');
            case 2
                title('dendrites of a Purkinje cell');
            case 3
                title('arbors of a larval zebrafish');
        end
        
        % 按父子关系对散点图进行连线
        for i = 1:length_of_point
            for j = 1:length_of_point
                if father_segment_index(j) == segment_index(i) % If point i is the father of point j
                    line( [X(i) X(j)],[Y(i) Y(j)],[Z(i) Z(j)] );
                end
            end
        end
        
    case 0
end

%% calculate the number of branching points
prompt = "Do you want to calculate the number of branching points?" + newline + "1: Yes" + newline + "2: No \n";
flag = input(prompt);
switch flag
    case 1
        k = 0; % count variable
        number_of_2_child_branching_point = 0;
        number_of_3_child_branching_point = 0;
        for i = 1:length_of_point
            for j = 1:length_of_point
                if father_segment_index(j) == segment_index(i) % If point i is the father of point j
                    k = k+1;
                end
            end
            if k >= 2
                number_of_2_child_branching_point = number_of_2_child_branching_point + 1;
            end
            if k >= 3
                number_of_3_child_branching_point = number_of_3_child_branching_point + 1;
            end
            k = 0; % reset
        end
        fprintf('至少有2个孩子的节点的个数为%d \n 至少有3个孩子的节点的个数为%d \n',number_of_2_child_branching_point,number_of_3_child_branching_point);
    case 0
end

%% calculate the average path length from a dendrite segment to the soma
length_to_soma = zeros(1,length_of_point);
count = 3;
for i = 3:length_of_point
    for j = 1:length_of_point
        if father_segment_index(i) == segment_index(j) % If point j is the father of point i
            length_to_father = ((X(i)-X(j))^2+(Y(i)-Y(j))^2+(Z(i)-Z(j))^2)^(1/2); % Euclid metric
            length_to_soma(count) = length_to_father + length_to_soma(j);
            count = count + 1;
            break; % a point only has 1 father so we can use break;
        end
    end
end
average_length = mean(length_to_soma(3:length_of_point));
fprintf("The average path length from a dendrite segment to the soma is %.2f um \n", average_length);

%% calculate the spine reach zone of the Purkinje dendrite
length_total = length_of_point * average_length;
s = 2; % um
V_spine_reach_zone = length_total * pi * s^2; % 这样算出来的是上限，但我一时没想到如何去掉重复的
switch file
    case 1
        fprintf("The spine reach zone of the pyramidal dendrite is %.2f um^3 \n", V_spine_reach_zone);
    case 2        
        fprintf("The spine reach zone of the Purkinje dendrite is %.2f um^3 \n", V_spine_reach_zone);
    case 3
        fprintf("The spine reach zone of the arbor from larval zebrafish is %.2f um^3 \n", V_spine_reach_zone);
end

%% calculate the 3D convex hull
[graph_of_convex_hull,volume_of_convex_hull] = convhull(X,Y,Z);
switch file
    case 1
        fprintf("The volume of convex hull of the pyramidal dendrite is %.2f um^3 \n", volume_of_convex_hull);
    case 2        
        fprintf("The volume of convex hull of the Purkinje dendrite is %.2f um^3 \n", volume_of_convex_hull);
    case 3
        fprintf("The volume of convex hull of the arbor from larval zebrafish is %.2f um^3 \n", volume_of_convex_hull);
end
figure(2)
trisurf(graph_of_convex_hull,X,Y,Z,'FaceColor','cyan')

% decorate
axis equal;
xlabel('x axis');
ylabel('y axis');
zlabel('z axis');

%% linear Sholl plot
prompt = "Do you want to do a linear Sholl analysis?" + newline + "1: Yes" + newline + "2: No \n";
flag = input(prompt);
switch flag
    case 1
        count = 0;
        path_length = 10; % um
        switch file
            case 1
                max_length = 400;
            case 2
                max_length = 200;
            case 3
                max_length = 1400;
        end
        radius_of_the_sphere = 0:path_length:max_length;
        number_of_lines_puncture_the_sphere = zeros(1,length(radius_of_the_sphere));
        Euclid_metric = @(x,y,z) ((x - X(1))^2 + (y - Y(1))^2 + (z - Z(1))^2)^(1/2); % metric is a fashionable name of distance.
        for k = 1:length(radius_of_the_sphere)
            for i = 1:length_of_point
                for j = 1:length_of_point % 肯定不用跑遍O(n^2)，但我不想化简了，反正也花不了几分钟
                    if father_segment_index(j) == segment_index(i) % i is the father of j
                        d_i = Euclid_metric(X(i),Y(i),Z(i));
                        d_j = Euclid_metric(X(j),Y(j),Z(j));
                        if (d_i^2 - radius_of_the_sphere(k)^2) * (d_j^2 - radius_of_the_sphere(k)^2) < 0 % 父亲节点和儿子节点一个在里一个在外
                            count = count + 1;
                        end
                    end
                end
            end
            number_of_lines_puncture_the_sphere(k) = count;
            count = 0; % reset
        end
        plot(radius_of_the_sphere,number_of_lines_puncture_the_sphere);
        xlabel('radius of the sphere (\mum)');
        ylabel('number of lines puncture the sphere');
        title('linear Sholl plot');
    case 0
end