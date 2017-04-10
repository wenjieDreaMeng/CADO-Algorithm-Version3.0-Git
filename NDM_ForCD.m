function [ Dist ] = NDM_ForCD( Data )

%   Author:     wenjie
%   Data:       2017-3-6
%   Function:   实现Doc:A New Distance Metrix for Unsupervised Learning of Categorical Data
%   Input:      Data为数据集
%   Output:     样本间的距离矩阵

clc
global weight;

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
ps = ProbabilitySameValue( Data );
pf = ProbabilityDifferent( Data );

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

function [ ps ] = ProbabilitySameValue( Data )

%   Function:   该函数求出某一列中取相同值的概率
%   Input:      数据集Data
%   Output:     每一列取相同值的概率标量

[row,col] = size(Data);
for i = 1:col
    probability = 0;
    mr = unique(Data(:,i));     %   取出某一列的元素出现的集合
    for j = 1:size(mr,1)
        EqualXiNum = size(find(Data(:,i) == mr(j)),1);     %   计算出在对应列上值等于Xi的元素的个数
        probability = probability + (EqualXiNum / row) * ((EqualXiNum-1) / (row-1));
    end
    ps(i) = probability;
end

end

function [ pf ] = ProbabilityDifferent( Data )

%   Function:   该函数求出某一列中取不同值的概率
%   Input:      数据集Data
%   Output:     每一列取不同值的概率标量

pf = 1.- ProbabilitySameValue(Data);

end

function [ R ] = Weight( Data )

%   Function:   该函数求出两列间的互信息，并标准化
%   Input:      数据集Data
%   Output:     权重矩阵

[row,col] = size(Data);

for i = 1:col
    for j = 1:col
        I = 0;                              %   Mutual Information
        H = 0;                              %   The joint entropy
        Element_i = unique(Data(:,i));      %   取出某一列的元素出现的集合
        Element_j = unique(Data(:,j));      %   取出某一列的元素出现的集合
        
        for Element_i_index = 1:size(Element_i,1)
            for Element_j_index = 1:size(Element_j,1)
                P_i = size(find(Data(:,i) == Element_i(Element_i_index)),1)/row;     %   计算出在对应列上值等于Element_i(Element_i_index)的元素的个数
                P_j = size(find(Data(:,j) == Element_j(Element_j_index)),1)/row;     %   计算出在对应列上值等于Element_i(Element_i_index)的元素的个数
                [i_row,i_col] = ind2sub(size(Data),find(Data(:,i) == Element_i(Element_i_index)));     %  找出第i列为Element_i(Element_i_index)的元素
                Temp_i_j = find(Data(i_row,j) == Element_j(Element_j_index));                          %  在Temp_i的基础上找出值为Element_j(Element_j_index)的元素
                %                 fprintf('i:%3d  j:%3d  i_num:%3d  j_num:%3d\n', i,j,Element_i(Element_i_index),Element_j(Element_j_index));
                P_i_j = size(Temp_i_j,1)/row;
                if P_i_j == 0           %   没有交集时，互信息为零
                    I = I;
                    H = H;
                else                    %   有交集时，根据互信息公示进行计算
                    I = I + P_i_j * log2(P_i_j/(P_i*P_j));
                    H = H + P_i_j * log2(P_i_j);
                end
            end
        end
        H = -H;
        R(i,j) = I / H;
    end
end


end
