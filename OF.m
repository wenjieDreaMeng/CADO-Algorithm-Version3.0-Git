function [ Dist ] = OF( Data )

%   Author: wenjie
%   Data:   2017-4-11
%   功能：采用Occurence Frequency算法计算分类型数据集Data中对象间的距离
%   输入参数：分类型数据集Data
%   输出参数：距离矩阵

[row,col] = size(Data);

for i = 1:row;
    for j = 1:row;
        TotalDisSimilarity = 0;
        for attribute_index = 1:col
            a = size(find(Data(:,attribute_index) == Data(i,attribute_index)),1);
            b = size(find(Data(:,attribute_index) == Data(j,attribute_index)),1);
            %   相同值时相似度为1,不同值为 1/(1 + log2(row^2/a) + log2(row^2/b));
            if Data(i,attribute_index) ==  Data(j,attribute_index)
                disSimilarity = 0;
            else
                disSimilarity = 1 - 1/[1 + log2(row/a)*log2(row/b)];
            end
            TotalDisSimilarity = TotalDisSimilarity + disSimilarity;
        end
        Dist(i,j) = TotalDisSimilarity;
        Dist(j,i) = TotalDisSimilarity;
    end
end
end
