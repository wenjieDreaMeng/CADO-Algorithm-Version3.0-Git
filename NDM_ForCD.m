function [ Dist ] = NDM_ForCD( Data )

%   Author:     wenjie
%   Data:       2017-3-6
%   Function:   实现Doc:A New Distance Metrix for Unsupervised Learning of Categorical Data
%   Input:      Data为数据集
%   Output:     样本间的距离矩阵

[row,col] = size(Data);
for i = 1:row
    for j = 1:row
        Dist(i,j) = DistCompute(Data,i,j);
        Dist(j,i) = Dist(i,j);
    end
end
end


function [ delta ] = delta( Xi , Xj )

%   Function:   该函数求出同一列属性中两个值间的权重值
%   Input:      样本编号Xi,Xj
%   Output:     两个样本之间的delta值

if Xi ~= Xj
    delta = 1;
else
    delta = 0;
end

end


function [dist] = DistCompute(Data, Xi, Xj)

%   Function:   该函数基于论文中的算法求出两个样本间的距离
%   Input:      数据集Data,样本编号Xi,Xj
%   Output:     样本Xi和样本Xj之间的距离

[row,col] = size(Data);
global ps;
global pf;
global weight;

dist = 0;
w = 0;
d = 0;

for i = 1:col
    if Data(Xi,i) ~= Data(Xj,i)
        for j = 1 : col
            [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Xi,i)));      %  找出第i列为Data(Xi,i)的元素
            Temp_i_j = find(Data(i_row,j) == Data(Xi,j));                           %  找出同时第j列为Data(Xi,j)的元素
            P_i = size(Temp_i_j,1)/row;
            P_i_No = (size(Temp_i_j,1) - 1)/(row - 1);
            
            [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Xj,i)));      %  找出第i列为Data(Xi,i)的元素
            Temp_i_j = find(Data(i_row,j) == Data(Xj,j));                           %  找出同时第j列为Data(Xi,j)的元素
            P_j = size(Temp_i_j,1)/row;
            P_j_No = (size(Temp_i_j,1) - 1)/(row - 1);
            d = d + weight(i,j) * (P_i * P_i_No + P_j * P_j_No);
        end
        wr = ps(i);
    else
        for j = 1 : col
            [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Xi,i)));      %  找出第i列为Data(Xi,i)的元素
            Temp_i_j = find(Data(i_row,j) == Data(Xi,j));                           %  找出同时第j列为Data(Xi,j)的元素
            P_i = size(Temp_i_j,1)/row;
            P_i_No = (size(Temp_i_j,1) - 1)/(row - 1);
            
            [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Data(Xj,i)));      %  找出第i列为Data(Xi,i)的元素
            Temp_i_j = find(Data(i_row,j) == Data(Xj,j));                           %  找出同时第j列为Data(Xi,j)的元素
            P_j = size(Temp_i_j,1)/row;
            P_j_No = (size(Temp_i_j,1) - 1)/(row - 1);
            d = d + weight(i,j) * delta(Data(Xi,j),Data(Xj,j)) * (P_i * P_i_No + P_j * P_j_No);
        end
        wr = pf(i);
    end
    w = w + wr;
    dist = dist + wr*d;
end
dist = dist / w;
end
