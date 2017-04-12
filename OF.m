function [ Dist ] = OF( Data )

%   Author: wenjie
%   Data:   2017-4-11
%   ���ܣ�����Occurence Frequency�㷨������������ݼ�Data�ж����ľ���
%   ������������������ݼ�Data
%   ����������������

[row,col] = size(Data);

for i = 1:row;
    for j = 1:row;
        TotalSimilarity = 0;
        for attribute_index = 1:col
            a = size(find(Data(:,attribute_index) == Data(i,attribute_index)),1);
            b = size(find(Data(:,attribute_index) == Data(j,attribute_index)),1);
            %   ��ֵͬʱ���ƶ�Ϊ1,��ֵͬΪ 1/(1 + log2(row^2/a) + log2(row^2/b));
            if Data(i,attribute_index) ==  Data(j,attribute_index)
                similarity = 1;
            else
                similarity = 1/(1 + log2(row^2/a) + log2(row^2/b));
            end
            TotalSimilarity = TotalSimilarity + similarity;
        end
        Dist(i,j) = TotalSimilarity;
        Dist(j,i) = TotalSimilarity;
    end
end
end
