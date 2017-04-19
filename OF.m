function [ Dist ] = OF( Data )

%   Author: wenjie
%   Data:   2017-4-11
%   ���ܣ�����Occurence Frequency�㷨������������ݼ�Data�ж����ľ���
%   ������������������ݼ�Data
%   ����������������

[row,col] = size(Data);

for i = 1:row;
    for j = 1:row;
        TotalDisSimilarity = 0;
        for attribute_index = 1:col
            a = size(find(Data(:,attribute_index) == Data(i,attribute_index)),1);
            b = size(find(Data(:,attribute_index) == Data(j,attribute_index)),1);
            %   ��ֵͬʱ���ƶ�Ϊ1,��ֵͬΪ 1/(1 + log2(row^2/a) + log2(row^2/b));
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
