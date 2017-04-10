function [ R ] = WeightBetweenAttribute(Data,ColSumPercent)

%   Function:   该函数求出两列间的互信息，并标准化
%   Input:      数据集Data
%   Output:     权重矩阵

[row,col] = size(Data);
% fid = fopen('RelationshipBetweenAttribute', 'w');

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

[row,col] = size(R);

%   对权重矩阵选取所有列间权重的平均值作为阈值
SumWeight = 0;              %   权重值总和
for i = 1:row
    for j = 1:col
        SumWeight = SumWeight + R(i,j);
    end
end
ThresholdValue = SumWeight / (row * row);

for i = 1:row
    for j = 1:col
        if R(i,j) < ThresholdValue
            R(i,j) = 0;
            R(j,i) = 0;
        end
%         fprintf(fid,'%6.5f ', R(i,j));
    end
%     fprintf(fid,'\n');
end

end